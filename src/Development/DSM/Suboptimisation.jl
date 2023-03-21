"""
	Suboptimisation

Demonstrate the idea of suboptimisation using two objective functions: a set of three valleys
and a member of the De Jong test suite.

Author: Niall Palfreyman (March 2023), Stefan Hausner (June 2022).
"""
module Suboptimisation

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Scout

Scouts fly around the world seeking to minimise the value of an objective function.
"""
@agent Scout ContinuousAgent{2} begin
	speed::Float64
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
Initialise the Suboptimisation model, also setting up an objective function which is either
easy (valleys) or difficult (De Jong 2).
"""
function suboptimisation(;
	difficult::Bool= false,
)
	width = 80			# Width of world
	pPop = 0.1			# Proportion of populated locations
	space = ContinuousSpace((width,width), spacing=1.0)

	properties = Dict(
		:objective => (difficult ? dejong2(width) : valleys(width)),
		:pPop => pPop,
		:difficult => difficult,
	)
	
	world = ABM( Scout, space; properties)
	
	for _ in 1:pPop*width*width
		add_agent!( world, Tuple(2rand(2).-1), 1)
	end

	world
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!(scout,world)

Scout takes a small step in the direction of a nearby location with a smaller objective value than
at the Scout's own location.
"""
function agent_step!( scout, world)
	scout.vel = .-gradient(scout.pos,world.objective,world)
	move_agent!(scout,world,scout.speed)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate the Suboptimisation model.
"""
function demo()
	subopt = suboptimisation()
	params = Dict(
		:difficult => false:true,
	)
	plotkwargs = (
		am = wedge,
		ac = :red,
		add_colorbar=false,
		heatarray=:objective,
	)

	playground, = abmplayground( subopt, suboptimisation;
		agent_step!, params, plotkwargs...
	)

	playground
end

end