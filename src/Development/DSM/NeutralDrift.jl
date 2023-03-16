#========================================================================================#
"""
	NeutralDrift

This model runs a very simple simulation called a Moran process. At each step, individuals change
their state to that of a random neighbour. 

Author: Niall Palfreyman (March 2023), Nick Diercksen (May 2022).
"""
module NeutralDrift

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Moran

A Moran agent has an attribute (in this case `altruist`) that is determined at each step by the
distribution of attributes of its neighbours.
"""
@agent Moran ContinuousAgent{2} begin
	altruist::Bool				# Type of the agent
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	neutraldrift( kwargs)

Create and initialise the NeutralDrift model.
"""
function neutraldrift(;
	altruism_cost = 0.0,				# Individual benefit of acting altruistically
)
	width = 30
	space = ContinuousSpace((width,width); spacing = 1.0)
	properties = Dict(
		:altruism_cost => altruism_cost,
	)

	world = ABM( Moran, space; properties, scheduler = Schedulers.Randomly())

	for _ in 1:width*width
		add_agent!( world, (0,0), rand(Bool))
	end

	return world
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( me, box)

On each step, each agent replaces its altruistic attribute by that of a random neighbour.
"""
function agent_step!( me::Moran, world::ABM)
	nbr = random_nearby_agent( me, world, 1.5)
	me.altruist =
		(nbr.altruist && rand() < 1 - world.altruism_cost) ? true : false
end

#-----------------------------------------------------------------------------------------
"""
	acolour( mn::Moran)

Select the agent's colour on the basis of their altruism.
"""
acolour( mn::Moran) = mn.altruist ? :lime : :blue

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a simulation of the IdealGas model.
"""
function demo()
	nd = neutraldrift()
	params = Dict(
		:altruism_cost => 0:1e-5:1e-3
	)
	plotkwargs = (
		ac = acolour,
		as = 20,
	)

	playground, = abmplayground( nd, neutraldrift;
		agent_step!, params, plotkwargs...
	)

	playground
end

end	# of module IdealGas