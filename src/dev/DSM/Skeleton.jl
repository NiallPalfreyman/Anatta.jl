"""
	Skeleton

This simulation demonstrates how flow is enacted into structure by simulating the building
of a skeleton (Skeleton) by Osteoblasts using Turing reaction-diffusion dynamics.

Author: Niall Palfreyman (July 2023)
"""
module Skeleton

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, Random, .AgentTools

#-----------------------------------------------------------------------------------------
# Module constants:
#-----------------------------------------------------------------------------------------
const TINY_CONCENTRATION	= 0.001			# Minimum functional chemical concentration
const STEP_LENGTH			= 0.1			# Length of a single Osteoblast step
const ACCELERATION			= 0.01			# Acceleration factor
const TOLERANCE				= 0.01			# Minimum detectable change in concentration
const TEMPERATURE			= 0.0001		# Skeleton temperature: Source of thermal jitter
const POP_DENSITY			= 1.0			# Population density of Osteoblasts in Skeleton
const DT					= 0.5			# Simulation timestep length
const GENS_PER_SCENARIO		= 3000			# Number of cycles per training scenario
const SCENARIOS_PER_EPOCH	= 2				# Number of training scenarios per epoch
const EPOCHS_PER_REGIME		= 30			# Number of training epochs in entire training regime
const TRAINING_STRENGTH		= 05			# Strength factor of training patterns

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Osteoblast

An Osteoblast moves with a certain speed, and secretes a chemical activator.
"""
@agent Osteoblast ContinuousAgent{2} begin
	speed::Float64					# Osteoblast's current speed
	secretion_rate::Float64
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	create_skeleton( kwargs)

Initialise the Skeleton reaction-diffusion system.
"""
function create_skeleton(;
	# The following parameter values generate 4 dots in a (14,14) space:
	a_diff_rate = 0.04,
	i_diff_rate = 0.40,
	a_evap_rate = 0.02,
	i_evap_rate = 0.03,
)
	width = 14
	extent = (width,width)
	properties = Dict(
		:activator		=> zeros(extent),
		:inhibitor		=> zeros(extent),
		:a_diff_rate	=> a_diff_rate,
		:i_diff_rate	=> i_diff_rate,
		:a_evap_rate	=> a_evap_rate,
		:i_evap_rate	=> i_evap_rate,
		:generation		=> 0,
		:scenario		=> 1,
		:epoch			=> 1,
		:training		=> true,
	)

	skeleton = ABM( Osteoblast, ContinuousSpace(extent,spacing=1.0); properties)

	for _ in 1:POP_DENSITY*prod(extent)
		# Baby emilies have maximum (unit) speed in a random direction:
		θ = 2π * rand()
		add_agent!( Osteoblast, skeleton, (cos(θ),sin(θ)), 1.0, TINY_CONCENTRATION)
	end

	skeleton
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( ossie::Osteoblast, skeleton::ABM)

Osteoblast dynamics: Somersault if activator concentration is falling, but decelerate if it is
unchanging. Also, slow down if other emilies are around. Finally, add some random thermal jitter
and deposit activator protein.
"""
function agent_step!( ossie::Osteoblast, skeleton::ABM)
	# Gather local information:
	prev_idx = get_spatial_index( ossie.pos, skeleton.activator, skeleton)
	prev_activator = skeleton.activator[prev_idx]

	# Deposit activator and move on:
	skeleton.activator[prev_idx] += DT * ossie.secretion_rate
	if rand() < ossie.speed
		move_agent!( ossie, skeleton, STEP_LENGTH)
	end

	# Note step-change in local activator concentration:
	new_idx = get_spatial_index( ossie.pos, skeleton.activator, skeleton)
	delta_activator = skeleton.activator[new_idx] - prev_activator
	if delta_activator < -TOLERANCE
		# Somersault if local activator concentration is falling:
		turn!( ossie, 2π*rand())
	elseif abs(delta_activator) < TOLERANCE
		# Settle down if local activator concentration is unchanging:
		accelerate!( ossie, -ACCELERATION)
	else
		# "Fall uphill": Accelerate if local activator concentration is rising:
		accelerate!( ossie, ACCELERATION)
	end

	if length(collect(nearby_agents( ossie, skeleton, STEP_LENGTH))) != 0
		# Slow down for neighbours:
		accelerate!(ossie,-ACCELERATION)
	end

	# Add in some random jitter:
	if rand() < TEMPERATURE
		accelerate!(ossie)
	end
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(skeleton)

Skeleton dynamics: Allow both A and I to react, evaporate and diffuse.
"""
function model_step!( skeleton::ABM)
	# Chemical reactions:
	(skeleton.activator,skeleton.inhibitor) = (
		skeleton.activator + DT * skeleton.activator.^2 ./ max.(skeleton.inhibitor,TINY_CONCENTRATION),
		skeleton.inhibitor + DT * skeleton.activator.^2
	)
	
	# Evaporation:
	skeleton.activator *= (1 - DT*skeleton.a_evap_rate)
	skeleton.inhibitor *= (1 - DT*skeleton.i_evap_rate)

	# Diffusion:
	diffuse4!( skeleton.activator, DT*skeleton.a_diff_rate)
	diffuse4!( skeleton.inhibitor, DT*skeleton.i_diff_rate)

	# Training:
#	orchestrate!( skeleton)
end

#-----------------------------------------------------------------------------------------
"""
	accelerate!( ossie::Osteoblast, accn::Float64=0.5)

If ossie is positively accelerating, increase speed; otherwise slow down.
"""
function accelerate!( ossie::Osteoblast, accn::Float64=1.0)
	if accn > 0.0
		ossie.speed += accn * (1.0-ossie.speed)
	else
		ossie.speed *= (1.0+accn)
	end
end

#-----------------------------------------------------------------------------------------
"""
	tick!( skeleton::Skeleton)

Step the skeleton's time-clock (generation,scenario,epoch) forward one tick.
"""
function tick!( skeleton::ABM)
	skeleton.generation += 1

	if skeleton.training
		if skeleton.generation > GENS_PER_SCENARIO
			skeleton.generation = 1
			skeleton.scenario += 1
		end
		if skeleton.scenario > SCENARIOS_PER_EPOCH
			skeleton.scenario = 1
			skeleton.epoch += 1
		end
		if skeleton.epoch > EPOCHS_PER_REGIME
			skeleton.epoch = 1
			skeleton.training = false
		end
	end
end

#-----------------------------------------------------------------------------------------
"""
	orchestrate!( skeleton::Skeleton)

Orchestrate the training and testing regime: tick!() time forwards, advance training scenario,
and move to testing after training has completed requisite number of EPOCHS_PER_REGIME.
"""
function orchestrate!( skeleton::ABM)
	tick!( skeleton)

	if skeleton.generation == 1
		skeleton.activator[:] .= 0.0
	end
	if skeleton.training
		# Conduct a training regime:
		if skeleton.scenario == 1
			# Conduct first training scenario:
			skeleton.activator[19:23,23:27] .+= TRAINING_STRENGTH * TINY_CONCENTRATION
		else
			# Conduct second training scenario:
			skeleton.activator[27:31,23:27] .+= TRAINING_STRENGTH * TINY_CONCENTRATION
		end
	else
		# Conduct a testing regime:
		if skeleton.generation < GENS_PER_SCENARIO
			# Conduct first test scenario:
			skeleton.activator[21,:] .+= TRAINING_STRENGTH * TINY_CONCENTRATION
		else
			# Conduct second test scenario:
			skeleton.activator[:,21] .+= TRAINING_STRENGTH * TINY_CONCENTRATION
			if skeleton.generation >= 2GENS_PER_SCENARIO
				skeleton.generation = 0
				skeleton.epoch += 1
			end
		end
	end
end

#-----------------------------------------------------------------------------------------
"""
	run()

Create and run a playground with a complete Skeleton full of Ossie Osteoblast babies.
"""
function run()
	skeleton = create_skeleton()
	params = Dict(
		:a_diff_rate => 0:0.001:0.05,
		:i_diff_rate => 0:0.01:1,
		:a_evap_rate => 0:0.001:0.1,
		:i_evap_rate => 0:0.001:0.1,
	)
	plotkwargs = (
		am = :circle,
		ac = :red,
		as = 15,
		heatarray = :activator,
		add_colorbar = false,
		spu = 1:20,
	)

	playground, abmobs = abmplayground( skeleton, create_skeleton;
		agent_step!, model_step!, params, plotkwargs...
	)

	# Display inhibitor heatmap on right-hand side:
	inhibitor = @lift($(abmobs.model).inhibitor)
	ax_heatmap, _ = heatmap(playground[1,2], inhibitor; colormap=:magma)
	ax_heatmap.aspect = AxisAspect(1)

	playground
end

end