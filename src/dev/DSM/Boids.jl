#========================================================================================#
"""
	Boids

This module generates system-level properties that illustrate an important aspect of emergence:
"Non-computability". Non-computable properties are not yet emergent, since the process of
generating them does not make use of downward selection by the system. However, non-computable
properties can arise reliably from the random behaviour of individual system components, yet
CANNOT be computed from those individual behaviours.

Author: Niall Palfreyman (January 2020), Nick Diercksen (May 2022)
"""
module Boids

using Agents, LinearAlgebra, Random, GLMakie, InteractiveDynamics

"""
	Boid

The populating agents in the Boids model.
"""
@agent Boid ContinuousAgent{2} begin
	speed::Float64					# Speed of this Boid
end

"""
	initialise_model( kwargs)

Create and initialise the Boids model.
"""
function initialise_model(;
    n_boids = 100,					# Number of Boids in model
    speed = 1.0,					# Initial speed of Boids in model
    priority_coherence = 0.25,		# Priority of coherence between Boids
    min_separation = 4.0,			# Preferred minimum separation between Boids
    priority_separation = 0.25,		# Priority of separation between Boids
    priority_matching = 0.01,		# Priority of matching speed between Boids
    visual_distance = 5.0,			# Eyesight distance of Boids
    extent = (100, 100),			# Extend of model space
)
    space2d = ContinuousSpace(extent; spacing = visual_distance/1.5)
    model = ABM( Boid, space2d;
		properties = (	# Model properties (will apply to all Boids in model):
			priority_coherence = priority_coherence,
			min_separation = min_separation,
			priority_separation = priority_separation,
			priority_matching = priority_matching,
			visual_distance = visual_distance,
		),
		scheduler = Schedulers.Randomly()
	)
    for _ in 1:n_boids
        vel = Tuple(rand(model.rng, 2) * 2 .- 1)
        add_agent!( model, vel, speed)
    end
    return model
end

"""
	agent_step!( kwargs)

This is the heart of the Boids model: It calculates precisely how each agent (Boid) behaves in
response to the behaviour of its nearest neighbours.
"""
function agent_step!(boid, model)
	neighbour_ids = nearby_ids(boid, model, model.visual_distance)
	n_nbrs = 0									# Number of visual neighbours
	match = separate = cohere = (0.0, 0.0)		# Upcoming adjustments to boid's behaviour

	for id in neighbour_ids
		n_nbrs += 1
		neighbour = model[id].pos
		heading = neighbour .- boid.pos

		# `cohere` computes the average position of neighbouring birds:
		cohere = cohere .+ heading
		if edistance(boid.pos, neighbour, model) < model.min_separation
			# `separate` repels the bird away from neighbouring birds:
			separate = separate .- heading
		end
		# `match` computes the average trajectory of neighbouring birds:
		match = match .+ model[id].vel
	end
	n_nbrs = max(n_nbrs, 1)
	# Calculate average velocity adjustments biased by priority:
	cohere		= cohere	./ n_nbrs .* model.priority_coherence
	separate	= separate	./ n_nbrs .* model.priority_separation
	match		= match		./ n_nbrs .* model.priority_matching
	# Compute velocity based on Reynolds' flocking rules defined above:
	boid.vel = (boid.vel .+ cohere .+ separate .+ match) ./ 2
	boid.vel = boid.vel ./ norm(boid.vel)
	# Move boid according to new velocity and speed
	move_agent!(boid, model, boid.speed)
end

"""
	boid_polygon

Shape of the Boid marker.
"""
const boid_polygon = Polygon(Point2f[(-0.5, -0.5), (1, 0), (-0.5, 0.5)])

"""
	boid_marker(boid)

Plotting function for the marker of a boid.
"""
function boid_marker(boid::Boid)
	φ = atan(boid.vel[2], boid.vel[1])		# Facing direction of boid
	scale(rotate2D(boid_polygon, φ), 2)
end

## Plotting the flock
function demo()
	model = initialise_model()
	abmvideo(
		"flocking.mp4", model, agent_step!;
		am = boid_marker,
		framerate = 20, frames = 100,
		title = "Flocking"
	)
#=	params = Dict(
		:n_boids => 100:500,
		:visual_distance => 0:10,
		:min_separation => 0:10,
		:priority_coherence => 0:0.1:10,
		:priority_separation => 0:0.1:10,
		:priority_matching => 0:0.1:10
	)
	#create the interactive plot with our sliders
	fig, p = abmexploration(model; (agent_step!)=agent_step!, params, am=boid_marker)
#	reinit_model_on_reset!(p, fig, initialise_model)
	fig=#
end

end