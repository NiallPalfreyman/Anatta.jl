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
		vel = vel ./ norm(vel)
        add_agent!( box, vel, speed)
    end

    return box
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( particle, box::ABM)

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
		nbr_pos = box[id].pos
		bearing = nbr_pos .- particle.pos

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
	momentum( particle)

Return the momentum of this particle.
"""
function momentum(particle)
	particle.speed * collect(particle.vel)
end

#-----------------------------------------------------------------------------------------
"""
	energy( particle)

Return the energy of this particle.
"""
function energy(particle)
	particle.speed^2 / 2
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a simulation of the SimpleParticles model.
"""
function demo()
	box = init_simpleparticles()
	abmvideo(
		"SimpleParticles.mp4", box, agent_step!;
		framerate = 20, frames = 1000,
		title = "Simple particles in an ideal gas",
		adata = [(:speed,s->sum(s.^2))]
	)

	agentdata, = run!( box, agent_step!, 500; adata=[(momentum,sum),(energy,sum)])

	# Return momentum and energy statistics:
	agentdata
end

end	# of module SimpleParticles