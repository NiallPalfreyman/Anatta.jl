#========================================================================================#
#	Laboratory 511
#
# Semiotic adaptation.
#
# Author: Niall Palfreyman (March 2023).
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 511: Kull's semiotic adaptation.

		There are many indications that evolution is not driven purely by random mutation. If I
		as a politician choose to discourage some particular cultural group from having children,
		this will clearly have evolutionary effects. It is also well-known that the choice of some
		cultures to farm cattle has influenced the evolution of genes involved in lactose
		digestion. But are these effects important in evolution?

		In the late 1890's, the biologists Baldwin, Morgan and Osborne proposed a theory in which
		an organism's choices may influence evolution. If male ostriches brood their eggs on hot
		sand, it is helpful to have calluses on their bottoms. Calluses are a Plastic feature of
		organisms' development that is caused by irritations of the organism's skin, yet male
		ostriches already have these calluses on their bottom when they are born! How might this
		Congenital trait evolve in ostriches?
		
		Think about and discuss carefully the following question with others: You have heard people
		laugh about Lamarke's (early 19th century) idea that 'wanting' to reach higher leaves might
		cause giraffes to evolve long necks. Lamarke's idea is genuinely mistaken, so how might the
		male ostriches' choice to brood their eggs on hot sand provide the selection pressure for
		them to develop calluses BEFORE birth?
		""",
		"To explain this, you need to remember that ostriches live in colonies with each other",
		x -> occursin("compet",lowercase(x))
	),
    Activity(
		"""
		We often think of evolution as being driven by some random genetic mutation that happens
		to improve an organism's ability to produce offspring. Yet it is possible to show that such
		purely random changes would need far longer than the current age of the Earth to produce
		organisms as complex as ourselves. Is there some other evolutionary mechanism at work here?

		Mary-Jane West-Eberhard (2005) suggested that the major driver of evolutionary change is
		not genetic mutation, but Developmental Plasticity. Kalevi Kull (2014) formalised West-
		Eberhard's idea under the title of Semiotic Adaptation: If the development of organisms in
		a population is influenced beneficially by an external circumstance that persists over
		many generations, genetic drift will shape their evolution in ways that make that benefit
		essential for their survival. If we then take away this external influence, either neutral
		drift will have made the organism capable of compensating for the lacking influence, or the
		population will die.

		Can you use Kull's argument to explain why we humans need to eat fruit to obtain the
		essential vitamin C, while many other animals are able to manufacture it in their bodies?
		""",
		"What relevant choices might humans have made in their evolutionary past?",
		x -> occursin("eat",lowercase(x)) && occursin("fruit",lowercase(x))
	),
    Activity(
		"""
		Semiotic adaptation is extremely interesting for artificial intelligence programs that use
		genetic search to solve problems. We see later in this course that genetic search suffers
		from suboptimisation problems, and semiotic adaptation may be a way to solve these issues.

		Geoffrey Hinton and Steven Nowlan (1987) used a computer simulation to show that semiotic
		adaptation can accelerate genetic search and help it out of suboptima. They designed a
		genetic algorithm that used three allele-values (0, 1 and 2) to find a secret 30-bit
		number. How many different numbers would the algorithm need to search through?
		""",
		"Each bit can have 2 values - 0 or 1. How many different 30-bit permutations are there?",
		x -> (x>1e10)
	),
    Activity(
		"""
		This search would take hours on the computer Hinton and Nowland were using. Instead, they
		allowed candidate numbers to be defined both genetically and developmentally: The allele
		values 0 and 1 were interpreted as bits, but the allele value 2 was interpreted as an
		unknown bit value, so in order to interpret a genome consisting of values [0,1,2], the
		algorithm rolled a dice to explore 1000 candidates to fill in the missing bits. These
		random bits corresponded to the developmental plasticity of an organism. This model of
		semiotic adaptation was able to find the secret number much faster than would have been
		possible with purely random genetic search.
		""",
		"",
		x -> true
	),
    Activity(
		"""
		The module SemioticAdaptation presents a complete simulation to evaluate Kull's idea of
		semiotic adaptation and to investigate its use for solving a search problem. It uses
		several terms you may not be familiar with. For example, "reaction norm" describes the
		variation that occurs in an organism's development due to its environment. If the reaction
		norm is large, a single genome may produce many different phenotypes; If the reaction norm
		is small, the organism is defined more precisely by its genotype.

		The turtles in Semiotic Adaptation race around the world looking for food to survive, but
		all of the available food is concentrated in small discs around the integer-valued location
		coordinates in the world ((3,4), (-9,5), and so on). If the turtle does not find food, it
		dies, managing to produce only one child. To produce more children, turtles must therefore
		evolve a disc radius small enough to be able to locate the food discs when they land on them.

		???
				read the code, to understand what it is about. I added a description at the top
		run the simulation, and study how  the reactionNorm influences the evolution of our agents


		play around with the food radius and benefit, eventually you will kill all agents before they
		can find anything, 
        or you make it very easy to find the right radius
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		""",
		"",
		x -> true
	),
    Activity(
		"""
		Try to understand how ineffective pure random search is in this case.
        Manipulate the searchSpeed variable in the code, and turn the reactionNorm of
		""",
		"no hint here",
		x -> true
	),
]