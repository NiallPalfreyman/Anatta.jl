#========================================================================================#
"""
	Boids

This module reproduces the work of Craig Reynolds in 1986 on flocking behaviour. It was later first
used in cinema in the film Jurassic Park, where it was used to generate the herd behaviour of
dinosaurs running from a predator.

Author: Niall Palfreyman (January 2023), Emilio Borelli (May 2022)
"""
module Boids

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools
using LinearAlgebra:norm

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Boid

The populating (flocking) agents in the Boids model.
"""
@agent Boid ContinuousAgent{2} begin
	speed::Float64					# Speed of this Boid
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	boids( kwargs)

Create and initialise the Boids model.
"""
function boids(;
	n_boids = 100,					# Number of Boids in model
	speed = 1.0,					# Initial speed of Boids in model
	visual_range = 5.0,				# Visual eyesight range of Boids
	alignment_weight = 0.01,		# Priority of aligning velocity between Boids
	min_separation = 4.0,			# Preferred minimum separation between Boids
	separation_weight = 0.25,		# Priority of separation between Boids
	cohesion_weight = 0.25,			# Priority of cohesion between Boids
	extent = (100, 100),			# Extent of model space
)
	model = ABM( Boid, ContinuousSpace(extent; spacing=visual_range/2);
		properties = Dict(			# Model properties applying to all Boids:
			:n_boids			=> n_boids,
			:visual_range		=> visual_range,
			:alignment_weight	=> alignment_weight,
			:min_separation		=> min_separation,
			:separation_weight	=> separation_weight,
			:cohesion_weight	=> cohesion_weight,
		),
		scheduler = Schedulers.Randomly()
	)

	velocities = [Tuple(2rand(2) .- 1) for _ in 1:n_boids]
	map( velocities) do vel
		add_agent!( model, vel./norm(vel), speed)
	end

	return model
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( boid, flock_model)

This is the heart of the Boids model: It calculates precisely how each agent (Boid) behaves in
response to the behaviour of its nearest neighbours.
"""
function agent_step!(boid, flock)
	neighbour_ids = nearby_ids(boid, flock, flock.visual_range)
	n_nbrs = 0									# Number of visual neighbours
	align = separate = cohere = (0.0, 0.0)		# Upcoming adjustments to boid's behaviour

	for id in neighbour_ids
		# Apply Reynolds' flocking rules with respect to this neighbour:
		n_nbrs += 1
		nbrpos = flock[id].pos
		heading = get_direction(boid.pos,nbrpos,flock)	# Periodic-respecting displacement vector

		# SEPARATE to avoid colliding with neighbouring boid:
		if euclidean_distance(boid.pos, nbrpos, flock) < flock.min_separation
			separate = separate .- heading
		else
			# Align and cohere ONLY if neighbour is not too close!
			# ALIGN my flight to the trajectory of neighbouring boid:
			align = align .+ flock[id].vel
			# COHERE towards neighbouring boid:
			cohere = cohere .+ heading
		end
	end
	n_nbrs = max(n_nbrs, 1)

	# Calculate average velocity adjustments biased by priority:
	align		= align		./ n_nbrs .* flock.alignment_weight
	separate	= separate	./ n_nbrs .* flock.separation_weight
	cohere		= cohere	./ n_nbrs .* flock.cohesion_weight

	# Apply flocking rules to my current velocity:
	boid.vel = (boid.vel .+ align .+ separate .+ cohere) ./ 2
	boid.vel = boid.vel ./ norm(boid.vel)

	# Now move forward according to my newly adjusted velocity and speed:
	move_agent!(boid, flock, boid.speed)
end

#-----------------------------------------------------------------------------------------
function demo()
	params = Dict(
		:visual_range		=> 0:10,
		:alignment_weight	=> 0:0.1:10,
		:min_separation		=> 0:10,
		:separation_weight	=> 0:0.1:10,
		:cohesion_weight	=> 0:0.1:10,
	)

	playground, = abmplayground( boids(), boids;
		agent_step!,
		params,
		am=wedge, ac=multicoloured,
		title="Reynolds' Boids model"
	)

	playground
end

end