#========================================================================================#
"""
	SimpleParticles

Module SimpleParticles: A first, primitive simulation of particles in an ideal gas.

Author: Niall Palfreyman, 20/01/23
"""
module SimpleParticles

using Agents, LinearAlgebra, GLMakie, InteractiveDynamics

#-----------------------------------------------------------------------------------------
# Module types:

"""
	SimpleParticle

The populating agents in the SimpleParticles model.
"""
@agent SimpleParticle ContinuousAgent{2} begin
	speed::Float64					# Speed of this Particle
end

#-----------------------------------------------------------------------------------------
# Module methods:

"""
	init_simpleparticles( kwargs)

Create and initialise the SimpleParticles model.
"""
function init_simpleparticles(;
    n_particles = 100,				# Number of SimpleParticles in box
    speed = 1.0,					# Initial speed of SimpleParticles in box
	radius = 1,						# Radius of SimpleParticles in the box
    extent = (100, 40),				# Extent of SimpleParticles space
)
    space = ContinuousSpace(extent; spacing = radius/1.5)
    box = ABM( SimpleParticle, space;
		properties = (
			# Box properties (apply to all SimpleParticles in the box):
			radius = radius,
		),
		scheduler = Schedulers.Randomly()
	)
    for _ in 1:n_particles
        vel = Tuple( 2rand(2).-1)
        add_agent!( box, vel, speed)
    end

    return box
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( kwargs)

This is the heart of the SimpleParticles model: It calculates precisely how each SimpleParticle
agent behaves in order to be repulsed away from its nearest SimpleParticle neighbours.
"""
function agent_step!(particle, box)
	neighbour_ids = nearby_ids(particle, box, 2*box.radius)
	n_nbrs = 0								# Number of  neighbours
	repulsion = (0.0, 0.0)					# Upcoming repulsion from neighbours
	stiffness = 1.0							# How stiff is the repulsive boundary of particles?

	for id in neighbour_ids
		# Accumulate repulsion from this neighbour:
		n_nbrs += 1
		;									# TODO: Calculate bearing from me to this neighbour:

		# `repulsion` REPELS me away from the neighbouring particle:
		repulsion = repulsion .- bearing ./ norm(bearing)
	end

	n_nbrs = max(n_nbrs, 1)
	repulsion = repulsion ./ n_nbrs .* stiffness		# Average repulsion from neighbours
	particle.vel = (particle.vel .+ repulsion)
	particle.vel = particle.vel ./ norm(particle.vel)	# New velocity heading

	move_agent!( particle, box, particle.speed)			# Adjust particle's speed and heading
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a simulation of the SimpleParticles model.
"""
function demo()
	model = init_simpleparticles()
	abmvideo(
		"SimpleParticles.mp4", model, agent_step!;
		framerate = 20, frames = 1000,
		title = "Simple particles in an ideal gas"
	)
end

end	# of module SimpleParticles