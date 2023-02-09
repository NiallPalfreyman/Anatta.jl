#========================================================================================#
"""
	Computability

This module generates system-level properties that illustrate an important aspect of emergence:
"Non-computability". Non-computable properties are not yet emergent, since the process of
generating them does not make use of downward selection by the system. However, non-computable
properties can arise reliably from the random behaviour of individual system components, yet
CANNOT be computed from those individual behaviours.

Author: Niall Palfreyman (January 2020), Nick Diercksen (May 2022)
"""
module Computability

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module data:
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
	computability()

Initialise a Computability model.
"""
function computability(;
	n_particles=1,
	r=0.5,
	n_vertices=3,
	worldsize=100
)
	properties = Dict(
		:n_particles => n_particles,
		:r => r,
		:vertices => [],
		:n_vertices => n_vertices,
		:spu => 30,
		:footprints => Vector{Vector{Float64}}(undef,0)
	)

	compy = ABM(Particle, ContinuousSpace((worldsize, worldsize)); properties)

	# Create n_vertices vertices of the Computability model:
	step = 2π/n_vertices
	compy.vertices = map(0:step:2π-step) do θ
		Tuple(0.5*worldsize*(1 .+ 0.9.*[-sin(θ),cos(θ)]))
	end

	for _ in 1:n_particles
		# Create a particle at a random initial position in the world:
		add_agent!( worldsize.*Tuple(rand(2)), compy, (0.0,0.0))
	end
	
	return compy
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( particle, compy)

Move particle towards a random vertex position.
"""
function agent_step!( particle, compy)
	move_agent!( particle,
		(compy.r.*rand(compy.vertices) .+ (1-compy.r).*particle.pos),
		compy
	)
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(compy)

After all agents have moved one step, record their current position as a footprint.
"""
function model_step!(compy)
	append!( compy.footprints, [collect(p.pos) for p in allagents(compy)])
end

#-----------------------------------------------------------------------------------------
"""
	vertices(compy)

Return all vertex locations of the Computability model.
"""
function vertices(compy)
	collect.(compy.vertices)
end

#-----------------------------------------------------------------------------------------
"""
	footprints(compy)

Return all footprints of the Computability model.
"""
function footprints(compy)
	compy.footprints
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Create an interactive playground for the Computability model.
"""
function demo()
	params = Dict(	# Playground slider values:
		:n_particles => 1:10,
		:r => 0:0.1:1,
		:n_vertices => 3:7
	)

	# Create playground displaying particles:
	playground, abmplt = abmplayground( computability(), computability;
		agent_step!, model_step!,
		params,
		ac=:blue, as=30, am=:circle
	)

	# Add to abmplot both footprints and vertices:
	footpath = Observable(Vector{Point{2,Float32}}(undef, 2))
	corners = Observable(Vector{Point{2,Float32}}(undef, 2))

	# Whenever abmplt is updated, also update arrays for the plots:
	on(abmplt.model) do m
		footpath[] = Point2f.(footprints(m))
		corners[] = Point2f.(vertices(m))
	end

	scatter!( footpath, color=:black, markersize=1)
	scatter!( corners,  color=:red,  markersize=20)

	playground
end

end # ... of module Computability