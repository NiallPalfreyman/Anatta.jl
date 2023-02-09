#========================================================================================#
#	Laboratory 503
#
# Emergence.
#
# Author: Niall Palfreyman (February 2023), Emilio Borrelli (July 2022)
#========================================================================================#
[
	Activity(
		"""
		To summarise our discoveries so far in this course: We have reason to believe that
		biological systems are both collective and non-computable. That is, their behaviour arises
		from the interactions between many individuals, and generates figures that we cannot
		compute, but which we might be able to approximate using computation. We will measure the
		success of our computational experiments by PATTERN-FITTING; that is, we will generate
		patterns experimentally and measure how well they 'fit' with the corresponding biological
		figures.
		
		In doing this, we will investigate the meaning of "emergence". Basically, emergence is
		behaviour that is collective and non-computable, but which achieves reliable results by
		selectively constraining the behaviours of its component agents. We will start exploring
		emergence by studying Reynold's (1979) Boids model (defined in the file Boids.jl).
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Each agent follows 3 simple , wich results in all agents moving in the same direction.
        Look at the code and tell me what rules that are give me the reply like this:
        ["rule1", "rule2", "rule3"]
		""",
		" match, cohere, seperate ",
		x -> x==["match", "cohere", "seperate"]
	),
    Activity(
		"""
		Now run the simulation. I equiped it with sliders, that let you manipulate those rules.
        try unbalancing or completely turning those rules off and see how it influences the agent's behaviour
		""",
		"no hint here",
		x -> true
	),
    Activity(
		"""
		Study the code and try to understand how the rules are implemented.
        Do the agents communicate with each other?
        return your answer like this: "true", "false"
		""",
		" they don't communicate, everybody just follows its own rules ",
		x -> x=="true"
	),
]