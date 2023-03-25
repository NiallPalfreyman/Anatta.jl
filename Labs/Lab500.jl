#========================================================================================#
#	Laboratory 500
#
# Welcome to course 500: An Introduction to Dynamical Systems Modelling!
#
# Author:  Niall Palfreyman, 1/7/2022.
#========================================================================================#
# * `move_agent` now needs to specify `dt` for an agent to move correspondong to its vel
# * nearby_ids has no longer a kw `exact`
[
	Activity(
		"""
		Hi! Welcome to Anatta course 500: An Introduction to Dynamical Systems Modelling (DSM)!
		
		Course 500 is immediately under construction - its grass is growing under your feet as you
		watch! In this course, we use DSM to study biological organism systems that consist of many
		interacting, NON-LIVING components. Organisms generate behaviour that is emergent, complex
		and autonomous:
			- EMERGENT behaviour is COLLECTIVE (arises from the interactions of many individual
				components) and UNPREDICTABLE (is not computable from the component behaviours).
			- COMPLEX behaviour is emergent, and is also easy to describe at the system level.
			- AUTONOMOUS behaviour is complex behaviour that we can describe at the system level as
				maintaining the existence of the system that generates that autonomous behaviour.

		The tremendous advantage of autonomous systems in both Nature and Industry is that they
		DEGRADE GRACEFULLY. That is, if the working conditions are not ideal, an autonomous systems
		will typically not crash, but will instead continue to perform its function, although less
		efficiently than under ideal conditions. Autonomous system achieve this by having a very
		special structure that we will investigate in this course.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		DSM uses two important tools: Agent-Based Modelling (ABM) and System Dynamics (SD). In ABM,
		we call the components AGENTS; in SD we call them STOCKS. For our experimental work, we
		will use the two julia packages Agents and DynamicalSystems; to display this work, we will
		use the packages GLMakie and InteractiveDynamics. Make sure you have loaded the Agents
		package, then go and read this introduction to its functionality:
			juliadynamics.github.io/Agents.jl/stable/tutorial
		""",
		"",
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
		x -> x isa Main.AbstractAgent && x.id == 2 && x.speed == 0.5
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
		Fetch the Dynamical Systems Modelling code now:
			fetchcode("DSM")

		Now study and run the file Development\\DSM\\SimpleParticles.jl to be sure you understand
		the extra code I have added there. Don't expect the particles to bounce off each other yet -
		that will be our next job! :)
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Next, look for the TODO tag in the file SimpleParticles.jl. I have written the skeleton
		code for making the particles bounce off each other in the method agent_step!(). However,
		I have left out the code that calculates the displacement direction from one particle
		position (.pos) to another. It is your task to add this code (it's only a couple of lines)
		starting from the TODO line. When you have done this, run SimpleParticles.demo() again
		to make sure the particles are behaving properly (that is, that they are bouncing away
		from each other in the correct directions).

		Only move on from this activity when your particles successfully bounce off each other.
		""",
		"""
		I suggest that you open a separate julia console and use it to create two Tuples of your
		own, and investigate how to calculate the vector difference between them.
		""",
		x -> true
	),
	Activity(
		"""
		Our simulation certainly looks good, doesn't it? But is it a physically accurate model
		of an ideal gas? The whole point of ABMs is to test our theories on systems that are too
		complex for us to manage without a computer, and we can only test a theory if our model is
		a physically accurate model of an N-particle ideal gas. This means that our model should
		satisfy conservation of both momentum and kinetic energy.

		We call such rules REFERENCE MODES: A reference mode is any behaviour of our model that
		will reassure us that we have implemented the model correctly. A model is only valid if
		it satisfies all reference modes that ensure its faithfulness to the "real system" we wish
		to model. So let's test our reference mode right now. First write in the SimpleParticles
		module two new methods that calculate the momentum and kinetic energy of a particle, for
		example:
			momentum(particle) = particle.speed * collect(particle.vel)
		""",
		"Don't worry about the mass of the particles for now - just assume it is equal to 1.0",
		x -> true
	),
	Activity(
		"""
		Now use the following function call to run the SimpleParticles model for 50 iterations,
		while collecting the required agent data (adata) on the sum of all momenta and
		kinetic_energy of the particles in the box:
			run!( model, agent_step!, 50; adata=[(momentum,sum),(kinetic_energy,sum)])

		You can call this either in the demo() method or from the Julia command prompt. In either
		case, you will need to look up run!() in the juliadynamics documentation and find out how
		to capture and display the returned Dataframe for the total momentum and kinetic_energy of
		the particles in the box. Is the particles' total kinetic energy constant?
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
		Oops! We have a problem, Houston! Our little universe violates the conservation of momentum!

		So, we need to re-implement our ideal gas model so that the collisions between particles
		satisfy momentum conservation. You will see that I have done this in the file IdealGas.jl.
		To create this file, I simply did the following:
			1. I copied SimpleParticles.jl to IdealGas.jl and renamed its internals accordingly;
			2. I added some nice-to-haves like putting mass and radius into Particle;
			3. I ensured strict normalisation of Agent.vel into a unit vector;
			4. I stripped out agent_step!() and reimplemented it.

		Study my implementation of IdealGas now and test whether it solves the problem of
		conserving momentum in the system. This will be of absolute importance if we wish to write
		ABMs that will deliver understanding and insights into real-life thermodynamical systems!

		So: Does my implementation of IdealGas obey strict conservation of momentum?
		""",
		"",
		x -> occursin("n",lowercase(x))
	),
	Activity(
		"""
		Ok, I have to confess that I purposely built one small bug into the IdealGas model. If you
		correct this bug now, you will find that IdealGas works properly. In which line of code
		is my bug?
		""",
		"",
		x -> x==93
	),
	Activity(
		"""
		Now you have one last job to do. It is of ultimate importance to satisfy the reference
		modes of our simulations. If I advise the Berlin City Services to invest in one kind of
		sewage system or bridge design rather than another, I am putting my reputation, career and
		the lives of others on the line: I need to KNOW that my advice is based on sound reasoning.

		Here is the point: My model is not reality, but an approximation. If lives depend on that
		approximation, I need to ensure that fufils all essential laws of physics, chemistry and
		biology! Think back to your Altruism project: Suppose a child died as a result of relying on
		your conclusions from that project. Could you SWEAR before a court of law that your
		implmentation was an absolutely accurate model of context-dependent selection in social
		systems?!

		So now: Analyse my implementation of agent_step!() carefully, discussing with others the
		following issues that might make this implementation unreliable:
			1. Did I do it right?
			2. Which simplifying assumptions did I make? Do these invalidate my model?
			3. Did I exclude any cases that might occur in reality?
			4. Which mathematical tricks did I use?
			5. Which physical laws did I make use of?
			6. Which of these considerations might make you worry about relying on my implementation
				for the success of your assessed project for this course???!!
		""",
		"",
		x -> true
	),
]
