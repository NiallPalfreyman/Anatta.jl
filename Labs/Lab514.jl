#========================================================================================#
#	Laboratory 514
#
# Reaction-diffusion systems
#
# Author: Niall Palfreyman (April 2023).
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 514: Flows and exploratory processes

		At the end of lab 511, we set out a programme of work for the remainder of this course:
			-	Investigate genetic structure and algorithms;
			-	Investigate ways of focusing problem-solving behaviour;
			-	Investigate exploratory developmental processes.

		In the module GeneticStructure, we investigated how to use genetic structure as a way of
		puzzling out new solutions from past solutions; in the module AntSearch, we saw how
		niche-construction focuses ants' behaviour on the problem they are solving by using flows
		as a means of communication between the ants. Notice that the ants do not DEFINE the
		dynamics of the flows - they merely influence them. Indeed, these flow dynamics are
		exploratory in the sense that they have a life of their own, independet of the ants'
		behaviour.

		In this lab, we investigate the surprising properties of exploratory flow processes.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		In the module WaveDynamics, we saw how flows can generate their own dynamics; however, the
		waves we saw there were very predictable. I implemented the module Turing in the usual way
		of software developers: I simply took the module WaveDynamics - which was already close to
		what I wanted - then stripped out the code I didn't need and modified the rest to implement
		the reaction-diffusion dynamics discovered by the mathematician Alan Turing shortly before
		his death in 1954.

		Run the simulation Turing.demo() now, and simply observe the results without changing any
		settings. Do you see a stable pattern emerging?
		""",
		"The image takes a while to settle down, but eventually you should see spots forming",
		x -> occursin('y',lowercase(x))
	),
	Activity(
		"""
		Imagine a population of slime-mould organisms on a surface. When slime-mould get hungry,
		they secrete a chemical called Activator (although I have set this secretion rate initially
		to zero). On the surface, Activator catalyses the chemical production of two chemicals: one
		product is Activator itself, and the other is a second chemical called Inhibitor. The
		chemical Inhibitor has this name because it inhibits the chemical production of Activator
		on the surface.

		In addition, these two chemicals also diffuse across the surface and evaporate over time.
		Turing showed (WITHOUT using a computer!) that the dynamics of this system of chemical
		reactions between Activator and Inhibitor can generate very interesting patterns of the
		kind you have just observed. What is the name of the method in the Turing module that
		implements the chemical reaction, evaporation and diffusion of the two substances?
		""",
		"",
		x -> x=="model_step!"
	),
	Activity(
		"""
		You may be wondering how these Turing dynamics work. Remember that Activator activates the
		production of Inhibitor, whereas Inhibitor INHIBITS the production of Activator. So
		wherever there is strong production of Inhibitor, this will prevent Activator from being
		produced, unless of course Activator levels are so strong that they can maintain themselves
		through autocatalysis. Now notice something interesting: Which chemical has the fastest
		diffusion rate?
		""",
		"I mean the default diffusion rates that I set up - you may need to restart to find them",
		x -> occursin("inhib",lowercase(x))
	),
	Activity(
		"""
		So if we start off at some location with a particularly high Activator concentration, this
		will promote the production of Inhibitor, which then diffuses more quickly than Activator
		away from that location This forms an inhibiting ring of Inhibitor around the area of high
		Activator concentration. In the Turing module, change the heatmap to :inhibitor to check
		whether this theory is correct: does Inhibitor form spots that are wider than the Activator
		spots?
		""",
		"",
		x -> occursin('y',lowercase(x))
	),
	Activity(
		"""
		While the simulation is running, press "reset" a few times. What changes in the pattern?
		What stays the same? Why? This is a common property of living systems: they exhibit complex
		behaviour that is unpredictable, yet nevertheless constrained by order.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		The reaction-diffusion mechanisms implemented in Turing also take place on the surface of
		animals' skin to create markings - the spots on a dalmation dog are produced in exactly
		the same way as the spots you observe. So what about stripes? Explore the four sliders for
		evaporation and diffusion rates of the two chemicals to find out which single parameter
		you need to change to produce curly stripes:
		""",
		"Change each slider individually, noting first the value to return it to after experimenting",
		x -> "a_diff_rate"
	),
	Activity(
		"""
		As you see, changing these parameters give us some control over the pattern-formation
		process. In the biological world, organisms determine these parameters genetically, and so
		influence the patterns that form. Note that the pattern-formation process is NOT controlled
		by the organism - all the organism does is modify a parameter that influences this process.
		Rather, the pattern-formation process constitutes an EXPLORATORY mechanism that relieves the
		organism of a lot of work and also a lot of organisational activity.

		In principle, the slime-moulds could influence the diffusion or evaporation rates of the
		chemicals they work with, but here we shall only work with the secretion rate. Raise the
		secretion rate of Activator in steps to find out its influence on the patterns. Does the
		number of slime-moulds occurring inside high concentrations of Activator increase or
		decrease?
		""",
		"",
		x -> occursin("incr",lowercase(x))
	),
	Activity(
		"""
		So we see that the slime-mould organisms can influence the position of the spots or stripes
		that are being formed. They can also stabilise these shapes. As a final exercise in this
		lab, implement tumbling in the slime-moulds:

		Copy the tumbling code from AntSearch and include a slider for the model attribute :speed.
		If the slime-moulds detect a lower concentration of Activator ahead of them, they reverse
		direction, and then perform a wiggle before moving forward with the model-defined speed.
		Now investigate the effects of the following factors on the patterns generated:
			-	Change the speed slowly upwards from 0.0 to 1.0
			-	Change the secretion rate upwards from 0.0
			-	Experiment with various evaporation and diffusion rates.

		Can you generate a pattern of solid, stable stripes?
		""",
		"",
		x -> true
	),
]