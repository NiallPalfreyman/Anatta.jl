#========================================================================================#
#	Laboratory 508
#
# Stabilisation
#
# Author: Niall Palfreyman (March 2023), Dominik Pfister (July 2022)
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 509: Stabilisation.

		Stabilisation is quite generally the process by which almost all systems build structure
		over time. Imagine sand swirling around the bottom of the ocean: occasionally it comes to
		rest at an obstacle, whereupon it creates even more of an obstacle for more sand, until
		the sand builds up around the obstacle. This is stabilisation: stability begets stability.
		
		Now imagine an empty shell that falls onto the seabed: at first, it can float around
		freely, but slowly it becomes stuck in sand. Then, because it is no longer moving, even
		more sand gathers around the shell, making it even more stable. This process is called
		DYNAMICAL STABILISATION:
			Things stay the same simply because randomly ocurring stability induces more stability.

		The concept of stabilisation actually solves a very deep question in evolutionary theory:
		What is fitness? Think about this question for a moment. We all learned in school that
		fitness is decides whether some organism, population or gene pool can reproduce itself
		effectively, yes? OK, but now consider the answer to this question:
			How can someone measure fitness?
		""",
		"Discuss this with partners: What is the only measurable criterion of an organism's fitness?",
		x -> occursin("child",lowercase(x)) || occursin("reproduc",lowercase(x))
	),
	Activity(
		"""
		That's right! The only way to measure fitness of an organism is by counting the number of
		its children. But in that case, the clarion call "Survival of the fittest!" that supposedly
		lies at the centre of evolutionary theory, actually states nothing more than this:
			Organisms that have more children, have more children!

		This circular definition shows that Darwin's revolutionary idea is not actually expressed
		correctly by the notions of fitness and population growth!

		Stabilisation resolves this dilemma by reformulating fitness in terms of stability. In order
		to survive and evolve, organisms and ecosystems do not need to grow faster than everyone else.
		Rather, they simply need to achieve stable co-existence with other ecosystems. Viewed in this
		way, the central statement of evolutionary theory becomes:
			Systems that are more stable give rise to even more stability.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		So stabilisation is the crucial idea at the centre of evolution. In the Stabilisation
		model, agents move around randomly, but they also stick to each other: they slow down when
		they come close to each other. Do you remember Reynolds' flocking boids? There, a simple
		set of rules led to the boids clustering into flocks. Here, the same thing happens as a
		result of just one rule: if you have a neighbour, slow down and chat; otherwise, speed up.

        Run the Stabilisation model now to see what the resulting behaviour looks like.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Again, we see that the Stabilisation model is capable of making decisions. As it runs,
		the agents form a series of 'piles' that slowly redistribute their component agents until
		eventually only one pile is left: the model has 'chosen' that location. Yet notice that
		there are still individual agents flying around and able to look for new, better choices.

		Test this search flexibility of the Stabilisation model by first creating one 'sticky'
		point for the agents to find, and then later shifting this sticky point to a new location
		to see if the agents can shift their choice to the new location.
		""",
		"",
		x -> true
	),
]