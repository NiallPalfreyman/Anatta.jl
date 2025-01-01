#========================================================================================#
"""
	Ecosystem

In this model, Turtles move around a world, eating algae to gain energy. They reproduce if they
have enough energy and die if their energy falls to zero. Overall it implements a general
situation in which organisms interact with each other both directly and indirectly.

Author: Niall Palfreyman & Dominik Pfister, 26/1/2023.
"""
module Ecosystem

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, LinearAlgebra, .AgentTools

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	Turtle

A Turtle possesses, in addition to the standard id, pos and vel of all agents, the three
additional attributes speed, energy and Δenergy.
"""
@agent Turtle ContinuousAgent{2} begin
	speed::Float64						# My speed when moving
	energy::Float64						# My current energy
	Δenergy::Float64					# Energy-gain when I eat
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	ecosystem()

Create the world model.
"""
function ecosystem(;
	n_turtles=5,									# Initial number of turtles
	dims=(40, 40),									# Dimensions of model world
	turtle_speed=1.0,								# Turtles' speed
	prob_regrowth=0.01,								# Probability of algae regrowth
	initial_energy=100.0,							# Turtles' maximum initial energy
	Δenergy=7.0										# Energy benefit of one alga
)
	world = ContinuousSpace( dims, spacing=1.0)		# Generate Turtles' world

	# Set model properties:
	properties = Dict(
		:algae => trues(dims), 						# Grid representing presence of algae
		:prob_regrowth => prob_regrowth,
		:initial_energy => initial_energy,
		:n_turtles => n_turtles,
		:Δenergy => Δenergy,
		:turtle_speed => turtle_speed,
	)

	model = ABM( Turtle, world; properties, scheduler=Schedulers.randomly)

	# Populate model with Turtles: ??? This is the changed bit
	for _ in 1:n_turtles
		energy = rand(1:model.initial_energy)
		vel = (x->(cos(x),sin(x)))(2π*rand())
		add_agent!( model, vel, turtle_speed, energy, Δenergy)
	end

	model
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!(turtle, model)

One step in the life of a Turtle:
	- Move forward,
	- Eat algae if there is one here,
	- Die if my energy is below zero and reproduce if my energy is above model's initial_energy.
"""
function agent_step!( turtle, model)
	turtle.energy -= 1									# Living costs energy!

	if rand() < 0.3
		# 30% of Turtles rotate slightly and move forward:
		cs,sn = (x->(cos(x),sin(x)))((2rand()-1)*pi/15)
		turtle.vel = Tuple([cs sn;-sn cs]*collect(turtle.vel))
		move_agent!( turtle, model, turtle.speed)
	end

	eat!( turtle, model)								# Turtle eats

	if turtle.energy < 0
		kill_agent!(turtle, model)						# Turtle dies
		return
	end

	# Turtle reproduces if it has enough energy:
	if turtle.energy >= model.initial_energy
		reproduce!(turtle, model)
	end
end

#-----------------------------------------------------------------------------------------
"""
	eat!( turtle, model)

Eat the algae at turtle's current position if there are any, and receive a feeding-benefit towards
my own energy. Remove algae from current location.
"""
function eat!( turtle, model)
	indices = get_spatial_index( turtle.pos, model.algae, model)
	if model.algae[indices]
		turtle.energy += turtle.Δenergy
		model.algae[indices] = false
	end
end

#-----------------------------------------------------------------------------------------
"""
	reproduce!( parent, model)

Create a child with the same properties as the parent. Reproduction costs the parent the
model's initial_energy, which is then given to the child.
"""
function reproduce!( parent::Turtle, model)
	parent.energy -= model.initial_energy
	add_agent!( parent.pos, model,
		parent.vel, parent.speed, model.initial_energy, parent.Δenergy
	)
end

#-----------------------------------------------------------------------------------------
"""
	model_step!( model)

At each currently empty algae location, allow an alga to grow with the model-dependent
probability of regrowth.
"""
function model_step!( model)
	empties = .!model.algae
	model.algae[empties] .= (rand(count(empties)).<model.prob_regrowth)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Record an abmvideo to visualise the Ecosystem module.
"""
function demo()
	ecosys = ecosystem()

	# Set up plotting parameters for the Turtle Ecosystem:
	plotkwargs = (
		ac=:red, 													# Turtles' colour
		as=10,														# Turtles' size
		am=AgentTools.wedge,										# Turtles' marker
		title = "Turtles in an ecosystem",							# Title of presentation
		heatarray=(model->model.algae), 							# Background map of algae
		heatkwargs=(colormap=[:black,:lime],colorrange=(0,1)),		# Algae's colours
		add_colorbar=false,											# No need for algae colour bar
		adata=[(a->isa(a,Turtle),count)], alabels=["Turtles"],		# Agent data and labels
		mdata=[(m->sum(m.algae))], mlabels=["Algae"],				# Model data and labels
	)

	# Create an exploratory playground for the Ecosystem:
	params = Dict(
		:n_turtles		=> 1:200,
		:turtle_speed	=> 0.1:0.1:3.0,
		:prob_regrowth	=> 0:0.0001:0.01,
		:initial_energy	=> 10.0:200.0,
		:Δenergy		=> 0:0.1:5.0,
	)

	playground, = abmplayground( ecosys, ecosystem;
		agent_step!, model_step!,
		params, plotkwargs...
	)

	playground
end

end # ... end of module Ecosystem