"""
	EnactWorld

This simulation demonstrates the emergence of complex activity in a reaction-diffusion
(i.e., Turing) system.

Author: Niall Palfreyman (July 2023)
"""
module EnactWorld

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, Random, .AgentTools

#-----------------------------------------------------------------------------------------
# Module constants:
#-----------------------------------------------------------------------------------------
const TINY_CONCENTRATION	= 0.001			# Minimum functional concentration
const SENSORY_RANGE			= 0.1			# How far a Enactor can 'see'
const ACCELERATION			= 0.01			# Acceleration factor
const TOLERANCE				= 0.01			# Minimum detectable change in concentration
const TEMPERATURE			= 0.0001		# EnactWorld temperature: Source of thermal jitter
const POP_DENSITY			= 0.6			# Population density in EnactWorld
const DT					= 0.5			# Simulation timestep length

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Enactor

A Enactor can in principle move, and secretes the chemical A(ctivator).
"""
@agent Enactor ContinuousAgent{2} begin
	speed::Float64					# Enactor's current speed
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	enact_world( kwargs)

Initialise the EnactWorld reaction-diffusion system.
"""
function enact_world(;
	a_secr_rate = TINY_CONCENTRATION,
	a_diff_rate = 0.022,				# These parameter values deliver curved stripes
	i_diff_rate = 0.40,
	a_evap_rate = 0.01,
	i_evap_rate = 0.03,
)
	width = 50
	extent = (width,width)
	properties = Dict(
		:activator		=> zeros(extent),
		:inhibitor		=> zeros(extent),
		:a_secr_rate	=> a_secr_rate,
		:a_diff_rate	=> a_diff_rate,
		:i_diff_rate	=> i_diff_rate,
		:a_evap_rate	=> a_evap_rate,
		:i_evap_rate	=> i_evap_rate,
	)

	enworld = ABM( Enactor, ContinuousSpace(extent,spacing=1.0); properties)

	for _ in 1:POP_DENSITY*prod(extent)
		# Baby emilies have maximum (unit) speed in a random direction:
		θ = 2π * rand()
		add_agent!( Enactor, enworld, (cos(θ),sin(θ)), 1.0)
	end

	enworld
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( emily::Enactor, enworld::ABM)

Enactor dynamics: Somersault if activator concentration is falling, but decelerate if it is
unchanging. Also, slow down if other emilies are around. Finally, add some random thermal jitter
and deposit activator protein.
"""
function agent_step!( emily::Enactor, enworld::ABM)
	# Gather local information:
	idx_here = get_spatial_index( emily.pos, enworld.activator, enworld)
	prev_activator = enworld.activator[idx_here]

	# Deposit activator and move on:
	enworld.activator[idx_here] += DT * enworld.a_secr_rate
	if rand() < emily.speed
		move_agent!( emily, enworld, SENSORY_RANGE)
	end

	# Note step-change in local activator concentration:
	step_activator =
		enworld.activator[get_spatial_index( emily.pos, enworld.activator, enworld)] - prev_activator
	if step_activator < -TOLERANCE
		# Somersault if local activator concentration is falling:
		turn!( emily, 2π*rand())
	elseif abs(step_activator) < TOLERANCE
		# Settle down if local activator concentration is unchanging:
		accelerate!( emily, -ACCELERATION)
	end

	if length(collect(nearby_agents( emily, enworld, SENSORY_RANGE))) != 0
		# Slow down for neighbours:
		accelerate!(emily,-ACCELERATION)
	end

	# Add in some random jitter:
	if rand() < TEMPERATURE
		accelerate!(emily)
	end
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(enworld)

EnactWorld dynamics: Allow both A and I to react, evaporate and diffuse.
"""
function model_step!( enworld::ABM)
	# Chemical reaction:
	(enworld.activator,enworld.inhibitor) = (
		enworld.activator + DT * enworld.activator.^2 ./ max.(enworld.inhibitor,TINY_CONCENTRATION),
		enworld.inhibitor + DT * enworld.activator.^2
	)
	
	# Evaporation:
	enworld.activator *= (1 - DT*enworld.a_evap_rate)
	enworld.inhibitor *= (1 - DT*enworld.i_evap_rate)

	# Diffusion:
	diffuse4!( enworld.activator, DT*enworld.a_diff_rate)
	diffuse4!( enworld.inhibitor, DT*enworld.i_diff_rate)
end

#-----------------------------------------------------------------------------------------
"""
	accelerate!( emily::Enactor, accn::Float64=0.5)

If emily is positively accelerating, increase speed; otherwise slow down.
"""
function accelerate!( emily::Enactor, accn::Float64=1.0)
	if accn > 0.0
		emily.speed += accn * (1.0-emily.speed)
	else
		emily.speed *= (1.0+accn)
	end
end

#-----------------------------------------------------------------------------------------
"""
	run()

Create and run a playground with a complete EnactWorld full of Emily Enactor babies.
"""
function run()
	enworld = enact_world()
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

	playground, abmobs = abmplayground( enworld, enact_world;
		agent_step!, model_step!, params, plotkwargs...
	)

	# Display inhibitor heatmap on right-hand side:
	inhibitor = @lift($(abmobs.model).inhibitor)
	ax_heatmap, _ = heatmap(playground[1,2], inhibitor; colormap=:magma)
	ax_heatmap.aspect = AxisAspect(1)

	playground
end

end