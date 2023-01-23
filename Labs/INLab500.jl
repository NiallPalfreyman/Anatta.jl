#========================================================================================#
#	Laboratory 500
#
# Welcome to course 500: An Introduction to Dynamical Systems Modelling!
#
# Authors:  Emilio Borelli, Nick Diercksen, Stefan Hausner, Dominik Pfister (July 2022)
#========================================================================================#
# * `move_agent` now needs to specify `dt` for an agent to move correspondong to its vel
# * nearby_ids has no longer a kw `exact`
[
	Activity(
		"""
		Hi! Welcome to course component 5 on Dynamical Systems Modelling (DSM)! :)

		DSM develops the idea that behaviour in biological systems arises not from complex
		planning algorithms, but from random interactions between many independent components. The
		massive advantage of this dynamical architecture is that it DEGRADES GRACEFULLY. That is,
		if conditions are not ideal, dynamical systems will typically not crash, but will instead
		perform les well, but still correctly.

		DSM uses two important tools: Agent-Based Modelling (ABM) and System Dynamics (SD).
		In ABM, we call the components AGENTS; in SD we call them STOCKS. For our experimental
		work, we will use the two julia packages Agents and DynamicalSystems; to display this work,
		we will use the packages GLMakie and InteractiveDynamics.

		You can find an introduction to the Agents package here:
			juliadynamics.github.io/Agents.jl/stable/tutorial

		I have already installed the packages Agents, GLMakie and InteractiveDynamics, but you will
		need to load them yourself. What keyword do you use to do this?
		""",
		"Please make sure you have loaded these 3 packages - you will need them!",
		x -> x == "using"
	),
	Activity(
		"""
		In object-oriented software development, we think of processes as belonging to software
		agents - after all, it is YOU who performs the processes of breathing and speaking, isn't
		it? So it makes sense to think of these processes as belonging to you.

		However, a major emphasis of the julia language is that PROCESSES are the primary actors
		of a system, whereas agents are only the localised nodes that store (or STOCK) the
		properties created and manipulated by these processes. We therefore think of an Agent as a
		struct - a collection of local properties that can influence, or CONDITION, the processes,
		which in turn are able to change those same properties at that agent's location.

		OK, so let's try making use of all this information. First, derive a new concrete type
		`Beetle` from the abstract type AbstractAgent. Your Beetles should be mutable and
		contain two fields: first an integer field `id` to uniquely identify the Beetle, and
		second a float field `speed` ...
		""",
		"You will need to load the Agents package and recall how to use the `<:` operator.",
		x -> Main.Beetle <: Main.AbstractAgent && fieldnames(Main.Beetle) == (:id,:speed)
	),
	Activity(
		"""
		Now create a vector `beetles` of six Beetles with id's from 0:5 and random speeds between
		0 and 1. Use comprehension to do this, then give me the expression beetles[3].speed
		""",
		"agents = [Beetle(i,rand()) for i in 0:5]",
		x -> (0.0<x<1.0)
	),
	Activity(
		"""
		Execute the following code:
			beetles[3].speed = 0.5

		Check the resulting effect on your beetles Vector, then give me the expression beetles[3]:
		""",
		"This code should have changed the speed of Beetle number 3 to 0.5",
		x -> x isa Main.AbstractAgent && x.id == 4 && x.speed == 0.5
	),
	Activity(
		"""
		We now know how to create agents using a constructor, but there is a problem with using
		constructors to create agents. In an AgentBasedModel (ABM), agents are not just free-
		floating nodes: they live within a space that defines how near they are to each other, so
		they can decide with whom they will interact. This means we must always create our agents
		with a unique id, a valid location within the space, plus various other constraints that
		agents must fulfill. All this book-keeping is quite boring to do, so in practice, we
		hand over the job of agent-construction to a very useful macro: @agent().
		
		OK, so let's start again and do things properly. We will use @agent() to create and display
		a small ABM of gas particles flying around in a 2-dimensional space. First, we create the
		agent type Particle:
			@agent Particle ContinuousAgent{2} begin
				speed::Float64
			end
	
		Execute this code at the julia prompt, then show me the list of fieldnames of a Particle:
		""",
		"Use the method fieldnames()",
		x -> x == (:id, :pos, :vel, :speed)
	),
	Activity(
		"""
		Notice that @agents() has added several book-keeping fields to your Particle agents that
		match the specification of a continuous, 2-dimensional space:
			id::Int64							# Particle's unique identifier
			pos::Tuple{Float64, Float64}		# Particle's position in 2-dimensional space
			vel::Tuple{Float64, Float64}		# Particle's bearing (facing direction)
			speed::Float64						# Particle's speed property (that we added)

		The Agents package offers us several useful spaces that our Particles can move in. For now,
		we will represent the space in which our Particles move as a ContinuousSpace in two
		dimensions with coordinate extent (100,40):
			space = ContinuousSpace( (100,40))

		Define this coordinate space, then show it to me please:
		""",
		"Use the above code to create a continuous space of the correct size",
		x -> x isa Main.ContinuousSpace && x.extent == (100.0, 40.0)
	),
	Activity(
		"""
		Now we put our Particle agent type together with our coordinate space to build a container
		in which our Particles can move around:
			box = ABM(Particle,space)

		Let's have a look at your box:
		""",
		"",
		x -> x isa Main.AgentBasedModel
	),
	Activity(
		"""
		Let's get this straight: So far, you have created a box 100 units long and 40 units high,
		which can contain Particles, but currently doesn't contain any. So let's now place three
		Particles into the box with random direction and respective speeds 0.5, 1.0 and 1.5:
			add_agent!( box, Tuple(2rand(2).-1), 0.5)
			add_agent!( box, Tuple(2rand(2).-1), 1.0)
			add_agent!( box, Tuple(2rand(2).-1), 1.5)

		You can inspect the Particles in your container by entering:
			box.agents

		May I see your container again, please?
		""",
		"Make sure you have 3 Particles with appropriate parameters vel and speed",
		x -> -1 < x.agents[3].vel[2] < 1
	),
	Activity(
		"""
		OK, so we now have three Particles in our container. Let's get them moving! You can move
		a single agent 5 units within its model like this:
			move_agent!( box.agents[3], box, 5)

		Do this now, and check that the third agent really has moved about 5 units:
		""",
		"Again, inspect the :agents field of your box",
		x -> true
	),
	Activity(
		"""
		But it is hard work to have to move each agent by hand. Instead, we want to tell all agents
		in the model to move at once with their own respective speed. To make this happen, we need
		to define what it means for an agent to step:
			function agent_step!( particle, model)
				move_agent!( particle, model, particle.speed)
			end

		Now enter:
			step!( box, agent_step!)

		and again inspect the agents to check that they have all moved appropriately. Now go on to
		the next activity.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Now we would like to create an animation of our set of Particles. Do you remember
		Observables from Lab06? Since the GLMakie plotting framework is based on Observables, we
		can use GLMakie together with InteractiveDynamics to create dynamic and interactive plots
		of our agent-based models. To do this, use the following function call:
			abmvideo( "Particles.mp4", box, agent_step!)

		This will take a while to compile, but when it is finished, open the movie-file that it
		has created and enjoy the show! :)

		While watching the video, notice what is happening when the Particles reach the edge of
		the space in the box. This behaviour is called "wrapping". It is very common in ABMs,
		and is a way of avoiding the problem of particles drifting outside the ABM's space.

		What is the correct topological name for the shape of the space in our box?
		""",
		"Think about the fact that the left- and right-edges (and top and bottom) are linked!",
		x -> contains(lowercase(x),"tor") || contains(lowercase(x),"nut")
	),
	Activity(
		"""
		Congratulations - now you know how to design and run an ABM! :)

		Now let's make our ABM a little more useful: We will turn it into a model of particles
		flying around and bounce off each other within an ideal gas. The above code that
		you have entered in the Julia console is also contained in the file SimpleParticles.jl.
		Study and run this file to be sure you understand the extra code I have added there.

		Don't expect the particles to bounce off each other yet - that will be our next job! :)
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Next, look for the TODO tag in the file SimpleParticles.jl. I have written the skeleton
		code for making the particles bounce off each other in the method agent_step!(). However,
		I have left out the code that calculates the bearing direction from one particle to
		another. It is your task to add this code (it's only a couple of lines) starting from the
		TODO line. When you have done this, run SimpleParticles.demo() again to make sure the
		particles are behaving properly (that is, that they are bouncing away from each other in
		the correct directions).
		""",
		"Only move on when your particles are successfully bouncing off each other.",
		x -> true
	),
	Activity(
		"""
		Our simulation certainly looks good, doesn't it? But is it a physically accurate model
		of an ideal gas? The whole point of ABMs is to test our theories on systems that are too
		complex for us to do without a computer, and we can only test a theory if our model is a
		physically accurate model of an N-particle ideal gas. This means that our model should
		satisfy momentum and energy conservation.

		We need to test this. First write in the SimpleParticles module two new methods that
		calculate the momentum and energy of a particle, for example:
			momentum(particle) = particle.speed * collect(particle.vel)
		""",
		"Don't worry about the mass of the particles - just assume it is equal to 1.0",
		x -> true
	),
	Activity(
		"""
		Now use the following function call to run the SimpleParticles model for 50 iterations,
		while collecting data on the sum of all momenta and energy of the particles in the box:
			run!( model, agent_step!, 50; adata=[(momentum,sum),(energy,sum)])

		You can do this either in the demo() method or from the Julia command prompt. In either
		case, you need to display and study a Dataframe for the total momentum and energy of the
		particles in the box. Is the total energy of the particles in the model constant?
		""",
		"",
		x -> occursin('y',lowercase(x))
	),
	Activity(
		"""
		What about the momentum? Is the total momentum of the particles in the model constant?
		""",
		"",
		x -> occursin('n',lowercase(x))
	),
	Activity(
		"""
		OK, so we have a job to do. In the next lab, we must re-implement our ideal gas model
		so that the collisions between particle satisfy momentum and energy conservation.

		See you later in lab 501! :)
		""",
		"",
		x -> true
	),
]
