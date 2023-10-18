"""
	Skeleton

This simulation demonstrates how flow is enacted into structure by simulating the building
of a skeleton (Skeleton) by Osteoblast agents using Turing reaction-diffusion dynamics.

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
const ACTIVATION_RADIUS		= 2				# Inner radius of activation
const INHIBITION_RADIUS		= 4				# Outer radius of inhibition
const INHIBITION_RATIO		= 0.34			# 0.33 links up long lines; 0.36 chops them up
const DT					= 1.0			# Simulation timestep length
const GENS_PER_SCENARIO		= 1000			# Number of cycles per training scenario
const SCENARIOS_PER_EPOCH	= 2				# Number of training scenarios per epoch
const EPOCHS_PER_REGIME		= 100			# Number of training epochs in entire training regime
const TRAINING_STRENGTH		= 9				# Strength factor of training patterns

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Osteoblast

An Osteoblast moves with a certain probability, and secretes a chemical activator.
"""
@agent Osteoblast ContinuousAgent{2} begin
	speed::Float64					# Osteoblast's current speed
	secretion_rate::Float64			# Rate of secretion of activator/inhibitor
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	create_skeleton( kwargs)

Initialise the Skeleton reaction-diffusion system.
"""
function create_skeleton(;
	population_density = 1.0,
	secretion = TINY_CONCENTRATION
)
	width = 100
	extent = (width,width)
	properties = Dict(
		:differentiation 	=> zeros(Float64,extent...),
		:activators 		=> fill(Int[],extent),
		:inhibitors			=> fill(Int[],extent),
		:population_density	=> population_density,
		:secretion			=> secretion,
		:generation			=> 0,
		:scenario			=> 1,
		:epoch				=> 1,
		:training			=> true,
	)

	skeleton = ABM( Osteoblast, ContinuousSpace(extent,spacing=1.0); properties)

	for i in 1:width, j in 1:width
		# Inner circle of activating next-door neighbours:
		skeleton.activators[i,j] = nearby_patches(
			(i,j), skeleton, (ACTIVATION_RADIUS,ACTIVATION_RADIUS)
		)
		# Outer circle of inhibiting distant neighbours:
		skeleton.inhibitors[i,j] = setdiff(
			nearby_patches( (i,j), skeleton, (INHIBITION_RADIUS,INHIBITION_RADIUS)),
			skeleton.activators[i,j]
		)
	end

	for _ in 1:population_density*prod(extent)
		# Baby emilies have maximum (unit) speed in a random direction:
		θ = 2π * rand()
		add_agent!( Osteoblast, skeleton, (cos(θ),sin(θ)),
			1.0, secretion*(2rand() - 1)
		)
	end

	skeleton
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( ossie::Osteoblast, skeleton::ABM)

Osteoblast dynamics: Builders tend to climb activator concentration gradients, while non-builders
tend to slide down them. This is achieved as follows:
	-	Builders deposit activator protein; somersault if ambient activator concentration is falling;
	-	Non-builders deposit inhibitor protein; somersault if activator concentration is rising;
	-	All Osteoblasts decelerate if activator concentration is unchanging;
	-	All Osteoblasts decelerate if other ossies are in the immediate neighbourhood;
	-	All Osteoblasts add some random thermal acceleration.
"""
function agent_step!( ossie::Osteoblast, skeleton::ABM)
	# Gather local information:
	prev_idx = get_spatial_index( ossie.pos, skeleton.differentiation, skeleton)
	prev_differentiation = skeleton.differentiation[prev_idx]

	# Deposit either activator or inhibitor, then move on:
	if skeleton.secretion != 0.0
		skeleton.differentiation[prev_idx] += DT*ossie.secretion_rate
	end
	if rand() < ossie.speed
		move_agent!( ossie, skeleton, STEP_LENGTH)
	end

	# Note step-change in local activator concentration:
	new_idx = get_spatial_index( ossie.pos, skeleton.differentiation, skeleton)
	delta_differentiation = skeleton.differentiation[new_idx] - prev_differentiation
	if builder(ossie) && delta_differentiation < -TOLERANCE ||
			!builder(ossie) && delta_differentiation > TOLERANCE
		# Somersault if local activator concentration is changing against my needs:
		turn!( ossie, 2π*rand())
	elseif abs(delta_differentiation) < TOLERANCE
		# Settle down if local activator concentration is unchanging:
		accelerate!( ossie, -ACCELERATION)
	else
		# Accelerate if local activator concentration is changing according to needs:
		accelerate!( ossie, ACCELERATION)
	end

	if length(collect(nearby_agents( ossie, skeleton, STEP_LENGTH))) > skeleton.population_density
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
	for i in shuffle(1:length(skeleton.differentiation))
		# Calculate total activatory influence on me ...
		activation = sum( skeleton.differentiation[skeleton.activators[i]]) -
			INHIBITION_RATIO * sum( skeleton.differentiation[skeleton.inhibitors[i]])

		# ... then adjust differentiation level accordingly - either downwards towards zero:
		skeleton.differentiation[i] *= (1-DT)
		if activation > 0
			# ... or else upwards:
			skeleton.differentiation[i] += DT
		end
	end

	# Training:
#	orchestrate!( skeleton)
end

#-----------------------------------------------------------------------------------------
"""
	nearby_patches( centre::Tuple, skeleton::ABM, r::Tuple)

Return a Vector of all indices of skeleton model within range r from a centre location.
Note: This implementation is still quite inefficient and only works for 2d spaces.
"""
function nearby_patches( centre::Tuple, skeleton::ABM, r::Tuple)
	# Set up neighbourhood Cartesian indices:
	rsq = r.^2
	rint = (s->round(Int,s)).(r)
	nbhd = [(i,j)
		for i in -rint[1]:rint[1], j in -rint[2]:rint[2]
			if (i^2/rsq[1] + j^2/rsq[2] ≤ 1.0)
	]
	setdiff!(nbhd,[(0,0)])						# We only want neighbours - not the centre

	# Displace (0,0)-based neighbourhood locations to the centre location:
	cint = (s->round(Int,s)).(centre)
	disc = map(nbhd) do pt
		cint .+ pt
	end

	# Extract linear matrix indices for the neighbourhood locations:
	ext = Int.(skeleton.space.extent)
	ind = LinearIndices((w->1:w).(ext))

	map(disc) do tupl
		ind[mod(tupl[1]-1,ext[1])+1,mod(tupl[2]-1,ext[2])+1]
	end
end

#-----------------------------------------------------------------------------------------
"""
	accelerate!( ossie::Osteoblast, accn::Float64=1.0)

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
	builder( ossie::Osteoblast)

Does this Osteoblast build up the differentiation level with a positive secretion_rate?
"""
function builder( ossie::Osteoblast)
	ossie.secretion_rate > 0
end

#-----------------------------------------------------------------------------------------
"""
	agent_colour( ossie::Osteoblast)

Builders are blue; non-builders are red.
"""
function agent_colour( ossie::Osteoblast)
	if builder(ossie)
		:blue
	else
		:red
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

	idx_quarter = round(Int,skeleton.space.extent[1]/4)
	dollop = TRAINING_STRENGTH * TINY_CONCENTRATION
	if skeleton.generation == 1
		skeleton.activator[:] .= 0.0
	end
	if skeleton.training
		# Conduct a training regime:
		if skeleton.scenario == 1
			# Conduct first training scenario:
#			println( "Yup: ", skeleton.epoch, "; ", skeleton.scenario, "; ", skeleton.generation)
			skeleton.activator[2idx_quarter,idx_quarter]		+= dollop
#			skeleton.activator[idx_quarter,3idx_quarter]	+= dollop
#			skeleton.activator[3idx_quarter,1]				+= dollop
#			skeleton.activator[3idx_quarter,2idx_quarter]	+= dollop
		else
			# Conduct second training scenario:
			skeleton.activator[2idx_quarter,3idx_quarter]		+= dollop
#			skeleton.activator[3idx_quarter,idx_quarter]	+= dollop
#			skeleton.activator[1,3idx_quarter]				+= dollop
#			skeleton.activator[2idx_quarter,3idx_quarter]	+= dollop
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
		:population_density	=> 0:0.1:5,
		:secretion			=> 0:0.1TINY_CONCENTRATION:10TINY_CONCENTRATION,
	)
	plotkwargs = (
		am = :circle,
		ac = agent_colour,
		as = 15,
		heatarray = :differentiation,
		add_colorbar = false,
		spu = 1:20,
	)

	playground, = abmplayground( skeleton, create_skeleton;
		agent_step!, model_step!, params, plotkwargs...
	)

	playground
end

end