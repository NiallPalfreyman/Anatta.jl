#========================================================================================#
"""
	Leafy

This module generates an approximation to a noncomputable fern.

Author: Niall Palfreyman (February 2023)
"""
module Leafy

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Particle

A Particle is a very simple Agent with no internal state other than the default properties id,
pos, vel. The only thing we really need from a Particle here is that we know its position.
"""
@agent Particle ContinuousAgent{2} begin end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	leafy()

Initialise a Leafy model.
"""
function leafy(;
	n_particles=1,
	base_point=[5.0,0.0],
	worldsize=10
)
	properties = Dict(
		:n_particles => n_particles,
		:base_point => base_point,
		:spu => 30,
		:footprints => Vector{Point2f}(undef,0)
	)

	leaf = ABM(Particle, ContinuousSpace((worldsize, worldsize)); properties)

	for _ in 1:n_particles
		# Create a particle at leaf's base_point:
		add_agent!( Tuple(leaf.base_point), leaf, (0.0,0.0))
	end
	
	return leaf
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( particle, leaf)

Move particle towards a random vertex position.
"""
function agent_step!( particle, leaf)
	pos = collect(particle.pos) - leaf.base_point
	dice = rand()

	rule1 = [0.85 0.04;-0.04 0.85]
	rule2 = [0.20 -0.26; 0.23 0.22]
	rule3 = [-0.15 0.28; 0.26 0.24]
	rule4 = [0 0;0 0.16]

	if dice < 0.85
		pos = rule1*pos + [0,1.6]
	elseif dice < 0.92
		pos = rule2*pos + [0,1.6]
	elseif dice < 0.99
		pos = rule3*pos + [0,0.44]
	else
		pos = rule4*pos
	end

	move_agent!( particle, Tuple(pos+leaf.base_point), leaf)
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(leaf)

After all agents have moved one step, record their current position as a footprint.
"""
function model_step!(leaf)
	append!( leaf.footprints, [Point2f(p.pos) for p in allagents(leaf)])
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Create an interactive playground for the Computability model.
"""
function demo()
	params = Dict(	# Playground slider values:
		:n_particles => 1:10,
	)

	# Create playground displaying particles:
	playground, abmplt = abmplayground( leafy(), leafy;
		agent_step!, model_step!,
		params,
		ac=:blue, as=30, am=:circle
	)
	# Add footprints to abmplot:
	scatter!( lift( (m->m.footprints), abmplt.model), color=:black, markersize=1)

	playground
end

end # ... of module Leafy