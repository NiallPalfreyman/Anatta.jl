#========================================================================================#
"""
	PSO

This model demonstrates how a Particle Swarm can solve a minimisation problem - and also the major
difficulty of minimisation: suboptimisation.
	
Author: Niall Palfreyman (March 2023), Nick Diercksen (May 2022).
"""
module PSO

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Ant

Ants run around the world seeking to minimise the value of an objective function, but unlike the
Scouts of the Suboptimisation model, they have a memory of their best-yet objective value.
"""
@agent Ant ContinuousAgent{2} begin
	speed::Float64
	memory::Float64						# Lowest value of u that I have yet found in my travels
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	pso()

Initialise a PSO model.
"""
function pso(;
	difficult=false,
	temperature=0.002,
	tolerance=0.4,
)
	width = 90
	extent = (width,width)
	pPop = 0.1			# Proportion of populated locations
	space = ContinuousSpace( extent; spacing=1.0)

	properties = Dict(
		:objective => (difficult ? dejong2(width) : valleys(width)),
		:pPop => pPop,
		:difficult => difficult,
		:temperature => temperature,
		:tolerance => tolerance,
		:mass_centre => extent ./ 2
	)

	world = ABM( Ant, space; properties)
	
	for _ in 1:pPop*prod(extent)
		# Baby Ant has unit speed and ridiculously inflated memory of objective function:
		θ = 2π * rand()
		add_agent!( world, (cos(θ),sin(θ)), 1.0, 1e301)
	end

	world
end

#-----------------------------------------------------------------------------------------
"""
	model_step!( world)

Recalculate mass_centre of all Ants in the world.
"""
function model_step!(world)
	mc = (0.0, 0.0)
	for (_, ant) in world.agents
		mc = mc .+ ant.pos
	end
	world.mass_centre = mc ./ length(world.agents)

	return world
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( ant, world)

This is the stabilising procedure for Ants: Somersault away if objective value is rising, but stay
on track if it is decreasing. Also, slow down if other agents are around. Finally, add some random
jitter - especially if you remember there is somewhere with a lower objective value than this.
"""
function agent_step!( ant, world)
	tactic_range = 1.5
	flow = world.objective
	prev_obj = flow[get_spatial_index( ant.pos, flow, world)]

	if rand() < ant.speed
		move_agent!( ant, world, tactic_range)
	end
#	move_agent!( ant, world, ant.speed)
	curr_obj = flow[get_spatial_index( ant.pos, flow, world)]
	nbrs = collect(nearby_agents( ant, world, tactic_range))

	# Remember lower values of objective function - otherwise spread dissatisfaction:
	if curr_obj < ant.memory
		ant.memory = curr_obj
	elseif curr_obj > ant.memory + world.tolerance
		accelerate!(ant)
		for aunty in nbrs
			accelerate!(aunty)
		end
	end

	# Somersault if objective is increasing:
	if curr_obj > prev_obj
		turn!(ant,2π*rand())
	end

	# Slow down for neighbours - otherwise speed up:
	if length(nbrs) != 0
		accelerate!(ant,false)
	else
		accelerate!(ant)
	end

	# Add in some random jitter:
	if rand() < world.temperature
		accelerate!(ant)
	end
end

#-----------------------------------------------------------------------------------------
"""
	accelerate!( ant::Ant, really::Bool=true)

If ant is really accelerating, increase speed; otherwise slow down.
"""
function accelerate!( ant::Ant, really::Bool=true)
	if really
		ant.speed = 0.5(ant.speed+1.0)
	else
		ant.speed *= 0.5
	end
end

#-----------------------------------------------------------------------------------------
"""
	demo()

creates an interactive abmplot of the PSO module to visualize
Particle Swarm Optimizations.
"""
function demo()
	world = pso()
	params = Dict(
		:difficult => false:true,
		:temperature => 0.0:0.002:1.0
	)

	plotkwargs = (
		ac=:lime,
		as=15,
		add_colorbar=false,
		heatarray=:objective,
	)

	playground,obs = abmplayground( world, pso;
		agent_step!, model_step!, params, plotkwargs...
	)

	# Whenever mass_centre is changed, update its representation on the heatmap:
	mc = lift( (wld->wld.mass_centre), obs.model)
	scatter!( mc, color=:darkgreen, markersize=30)

	playground
end

end