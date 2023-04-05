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
		Welcome to Lab 511: Semiotic adaptation and theory-development.

		There are many indications that evolution is not driven purely by random mutation. If I
		as a politician choose to discourage some particular cultural group from having children,
		this will clearly have evolutionary effects. It is also well-known that the choice of some
		cultures to farm cattle has influenced the evolution of genes involved in lactose
		digestion. But do these effects have any importance in evolution?

		In the late 1890's, the biologists Baldwin, Morgan and Osborne proposed a theory in which
		an organism's choices may influence evolution. If male ostriches brood their eggs on hot
		sand, it is helpful to have calluses on their rumps. Calluses are a 'plastic' feature of
		an organism's development, caused not by genes, but by irritation of the organism's skin,
		yet male ostriches already have these calluses on their rump when they are born! How might
		this congenital trait evolve in ostriches?
		
		Think about and discuss carefully the following question with a friend. You have heard
		people mock Lamarke's (early 19th century) idea that 'wanting' to reach higher leaves might
		cause giraffes to evolve long necks. This idea is genuinely mistaken, so: How might the
		male ostriches' choice to brood their eggs on hot sand provide the selection pressure for
		them to develop calluses BEFORE birth?
		""",
		"To explain this, you need to remember that ostriches live in colonies with each other",
		x -> occursin("compet",lowercase(x))
	),
    Activity(
		"""
		We often think of evolution as being driven by some random genetic mutation that happens
		to improve an organism's ability to produce offspring. Yet we can calculate that such
		purely random changes would require far longer than the current age of the Earth to produce
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
		x -> all(map(occursin(lowercase(x)),["ate","fruit"]))
	),
    Activity(
		"""
		Semiotic adaptation has enormous potential interest for artificial intelligence software
		that uses genetic search to solve problems. We will see later in this course that genetic
		search suffers from suboptimisation problems, and semiotic adaptation may offer a way to
		solve these problems.

		Geoffrey Hinton and Steven Nowlan (1987) used a computer simulation to show that semiotic
		adaptation can accelerate genetic search and help it out of suboptima. They designed a
		genetic algorithm based on three allele-values (0, 1 and 2) to find a secret 30-bit
		number. How many different numbers would the algorithm need to search through?
		""",
		"Each bit can have 2 values - 0 or 1. How many different 30-bit permutations are there?",
		x -> (x>1e10)
	),
    Activity(
		"""
		This search would take days on the computers Hinton and Nowland were using. Instead, they
		designed their algorithm to generate candidate numbers both genetically and
		developmentally: The allele values 0 and 1 were interpreted as bits, but the allele value 2
		was interpreted as an unknown bit value, so in order to interpret a genome consisting of
		values [0,1,2], the algorithm rolled a dice to explore 1000 candidates to fill in the
		missing bits. These randomly generated bits corresponded to the developmental plasticity of
		an organism. Hinton and Nowlan's semiotic adaptation algorithm was able to find the secret
		number MUCH faster than would have been possible using purely random genetic search.

		An important question for us in this course is therefore: How might we be able to make use
		of semiotic adaptation to accelerate genetic search algorithms?
		""",
		"Don't worry: I'm not expecting you to answer this question! Read on ... :)",
		x -> true
	),
    Activity(
		"""
		The module SemioticAdaptation implements a simulation to evaluate Kull's idea of semiotic
		adaptation and to investigate its use for solving a search problem. It uses several terms
		you may not be familiar with. For example, 'reaction norm' describes the extent to which
		we can expect an organism's phenotype to vary within the parameters of its genotype due to
		variations in its developmental environment. If the reaction norm is large, a single genome
		may generate many different phenotypes; If the reaction norm is zero, the organism is
		defined precisely by its genotype. In Nature, the reaction norm is never zero.

		The turtles in SemioticAdaptation.jl race around the world looking for food to survive, but
		all of the available food is concentrated in small discs around the world locations with
		integer-valued coordinates ((3,4), (-9,5), and so on). If the turtle does not find food, it
		dies, managing typically to produce only one child. To produce more children, turtles must
		therefore locate food by evolving a search disc radius that is small enough to help them
		locate a food disc when they land on one.

		In the initial version of SemioticAdaptation, food discs have a feeding_radius of 1e-5 on
		the unit square between integer-valued locations. Of what order of magnitude is the
		probability that a turtle will land by chance on a food disc?
		""",
		"",
		x -> x==-10
	),
    Activity(
		"""
		You can see that our problem has the same order of magnitude as Hinton and Nowlan's problem,
		but your computer is much faster, so we can try out ideas much faster than they could.
		
		If you now start SemioticAdaptation.demo(), you will see the turtles' world on the left,
		while the two graphs on the right display the number of turtles who have evolved a search
		radius inside the feeding_radius. This search radius tells the turtle how close it needs
		to be to an integer-valued location for it to stop and feed. If its search radius is too
		large, the turtle will try to feed outside the feeding disc and will die of starvation.

		Use the sliders to set feeding_radius=1e-5, reaction_norm=0.0 and food_benefit=3.0. This
		means the chances of a turtle landing randomly on a food disc are around 3e-6; there is no
		difference between the turtle's genetically determined search radius and its phenotypically
		expressed search radius; and the benefit of finding food is high enough to enable turtles
		to have more than one child.

		Run the simulation with these parameter values until the first turtles appear with a
		successful search radius. Now stop the simulation and use the mouse cursor to find out
		how many generations were needed to locate the solution purely genetically.
		""",
		"You may want to raise the steps-per-unit (spu) slider to speed things up!",
		x -> 1e4<x<1e5
	),
    Activity(
		"""
		If you look at the turtles in the left-hand window, you should be able to see the
		successful turtles coloured lime green. Turtles possess two search radii: genetic_radius,
		which is determined by the turtle's parents, and develop_radius, which is determined by
		both the genetic radius and the reaction_norm. Success means the turtle has found the
		correct genetic_radius of less than 1e-5, and the method set_exploitation!() displays
		this success as the colour :lime. What colour is used to characterise turtles that have
		achieved a develop_radius of 1e-5?
		""",
		"Look in the set_exploitation!() method",
		x -> x==:orange
	),
    Activity(
		"""
		Since we set reaction_norm=0.0, there is no difference between the turtles' genetic and
		developmental radii. For this reason, you will not yet see any orange turtles (study
		set_exploration!() to see why this is so). Now study the give_birth() method to find out
		how the develop_radius of a new-born turtle is calculated from its genetic_radius.

		A turtle stops moving when it is feeding, and it stops to feed when it is within its own
		develop_radius of an integer-valued feeding point. Give me the method that sets the
		turtle's status to 'feeding'?
		""",
		"",
		x -> x==Main.feed!
	),
    Activity(
		"""
		If reaction_norm==0.0, the turtle seeks purely genetically - it stops when it is within
		its own genetic_radius of a feeding point (because genetic_radius==develop_radius). But
		because the feeding_radius is so small, it is very unlikely that the turtle will stop
		inside the feeding disc (because genetic_radius is typically bigger than feeding_radius).

		Furthermore, if the turtle stops outside the feeding disc, it receives no information about
		where it went wrong: Should its children choose their genetic_radius smaller or larger than
		their parent's radius? You and I know the children's radius should be smaller, but we want
		the turtles to discover this for themselves through random mutation!

		We hope that we can accelerate this search by allowing a turtle's develop_radius to vary
		randomly from its genetic_radius. In this case, the turtle has a greater chance of finding
		a develop_radius that allows it to feed - even though it cannot pass on this radius to its
		children (since it can only pass on its genetic_radius). Set reaction_norm=0.2 and find
		out how many generations it takes for the first genetic successes to appear:
		""",
		"",
		x -> 1e4<x<1e5
	),
	Activity(
		"""
		It may be that your simulation run with reaction_norm=0.2 is either faster or slower than
		with reaction_norm=0.0. Either way, it is still difficult to tell whether plasticity has
		accelerated the search because any difference we observe may be due to random variation.

		Nevertheless, you can see that something interesting is happening. First, the new random
		plasticity continuously produces successful values of develop_radius - and we can evaluate
		this continuous supply of phenotypic diversity by measuring its ability to locate food. Why
		doesn't the simulation reward the very first successful develop_radius values with food?
		""",
		"Think about how the turtle searches for food",
		x -> all(map(occursin(lowercase(x)),["find","food"]))
	),
    Activity(
		"""
		That's right - just because a turtle has a successful radius doesn't mean that it actually
		lands on a food disc. However, if you look at the graph of successful develop_radius
		values, you can see that the number of successful develop_radius values builds up
		immediately BEFORE the first successful genetic_radius values appear. This means our idea
		is working: turtles are getting rewarded for good developmental values when their genetic
		values are approaching the target value of 1e-5. Hurray! :)

		OK, now it's you turn. I have provided you with three sliders for the values of
		feeding_radius, reaction_norm and food_benefit. Play with these values now to test our
		theory that plasticity can accelerate genetic search. First change feeding_radius up to
		1e-3 and explain what happens. Then change feeding_radius back, and explain the results
		of setting food_benefit down to 1.0. Finally, conduct a set of simulation runs to check
		whether our theory works: Is search accelerated when reaction_norm>0.0?

		Important: This is not an easy activity. Experiment with various slider settings, think
		about your results and discuss this thinking with friends, but do NOT take longer than
		30 minutes over the activity!
		""",
		"",
		x -> true
	),
    Activity(
		"""
		OK, you have hopefully drawn your own conclusions about the validity of using plasticity
		to accelerate genetic search. I can tell you that I spent three full days testing this
		simulation, and the results were very informative! On the basis of what you have observed,
		what is your opinion: Does plasticity accelerate genetic search?
		""",
		"",
		x -> occursin("yes",lowercase(x)) || occursin("no",lowercase(x))
	),
    Activity(
		"""
		In the results of these experiments, we see the difficulties of conducting simulation
		experiments: In order to achieve general valid results, we must work with random
		simulations, however this randomness means it is difficult to be sure about the meaning of
		our results. After three days of testing, I came to the conclusion that the simulation
		provides no evidence at all to support my theory that plasticity accelerates search.

		So our experiment was a dismal failure! :-o

		... or was it? Please read on ...
		""",
		"",
		x -> true
	),
    Activity(
		"""
		As scientists, we constantly come up against this problem: Our own beautiful theory gets
		torn apart by a few irritating facts that we can't get deny. What makes us true scientists
		is that we accept this disappointment as reality, and USE it as a way to move forward ...

		First, notice how much you learned by testing the effect of sliders on the simulation.
		This learning is not a waste of time: it is a very important part of this course!

		Second, science hss a special technique for dealing with experimental failure - it is
		called "Constructive Alignment (CA)":
			1.	We construct a believable story to explain some scientific observation.
			2.	We construct a Null Hypothesis which, if true, would destroy our lovely story.
			3.	We construct an experiment to prove the null hypothesis (and destroy our story).
			4.	If the experiment fails to prove the null hypothesis, our story is well-aligned
					with our observations. After enjoying this, loop back to step 2.
			5.	If the experiment proves the null hypothesis, our story is incomplete. In this
					case, we make a list of the prior assumptions of our story and decide which
					assumption is probably wrong and needs changing.
			6. Loop back to stage 1.

		What was the experimental observation that we sought to explain with our story?
		""",
		"What is the single fact of which we are certain in this lab?",
		x -> occursin("hinton",lowercase(x))
	),
    Activity(
		"""
		We know that Hinton and Nowlan managed to accelerate a genetic search. Now, what
		believable story did we implement in our Turtle simulation? We assumed that:
			Genetic search can be accelerated by simply randomising the route from genotype
			to phenotype.

		The null hypothesis that was proven by our simulation was therefore:
			Randomising the route from genotype to phenotype does NOT accelerate genetic search!

		Think about what aspects of Hinton and Nowlan's work we missed out of our story. If you
		are interested, you can find the Hinton & Nowlan (1987) paper in the Docs subdirectory.
		""",
		"",
		x -> true
	),
    Activity(
		"""
		Here are my thoughts contrasting our Turtle simulation with Hinton and Nowlan's model:
			-	Their individuals have a genotypic structure that is mutated and recombined;
			-	Their phenotypes are selected ONLY on their ability to guess the secret
					number, whereas our turtles are also selected on a behaviour over which
					they have no control: whether they happen to land on a food disc.
			-	Their genotype encodes an exploratory process that generates the phenotype;

		These thoughts give us a way forward. If we want to reproduce the accelerated search of
		Hinton and Nowlan, we might need to give our turtles three additional features:
			-	Selection OF recombinable genetic structure;
			-	Selection OF structure-flow niches that focus problem-solving behaviour on ONE
					SPECIFIC objective.
			-	Selection ON exploratory developmental processes;

		That's a lot to do - maybe we'd better get started! :)
		""",
		"",
		x -> true
	),
]