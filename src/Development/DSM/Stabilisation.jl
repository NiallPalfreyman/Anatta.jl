#========================================================================================#
"""
	Stabilisation

Demonstrate the stabilisation of movement within a dynamical system.

Author: Niall Palfreyman (January 2020), Dominik Pfister (July 2022).
"""
module Stabilisation

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Particle

A Particle simply moves around with a speed, however this speed is influenced by the presence of
other nearby Particles.
"""
@agent Particle ContinuousAgent{2} begin
	speed::Float64
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	stabilisation()

Create the stabilisation model.
"""
function stabilisation(;
	binding_radius = 0.2,			# Radius of attraction between Particles
)
	width = 20
	space = ContinuousSpace((width,width), spacing=0.5)

	properties = Dict(
		:binding_radius => binding_radius,
	)

	world = ABM( Particle, space; properties, scheduler=Schedulers.randomly)
	
	for _ in 1:round(Int,width*width)
		# Random facing direction:
		add_agent!( world, Tuple(2rand(2).-1), 1.0)
	end

	return world
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( particle, world)

The particle moves in its facing direction with a speed that adjusts according to the number of
nearby particles, and then turns to face in a new random direction.
"""
function agent_step!( particle, world)
	# Chance of moving is lower if other particles are nearby:
	if rand() < (1 / (1 + length(collect(nearby_agents(particle,world,world.binding_radius)))^2))
		move_agent!(particle, world, particle.speed)
	end
	turn!(particle,2π*rand())
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Set up a playground for a simple stabilisation process.
"""
function demo()
	params = Dict(
		:binding_radius => 0.05:0.05:1,
	)

	plotkwargs = (
		ac=:green,
		am=(ag->wedge(ag,as=0.5)),
	)

	world = stabilisation()

	playground, = abmplayground( world, stabilisation;
		agent_step!, params, plotkwargs...
	)

	playground
end

end