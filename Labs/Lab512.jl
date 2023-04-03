#========================================================================================#
#	Laboratory 512
#
# Genetic structure.
#
# Author: Niall Palfreyman (April 2023).
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 512: Selection OF recombinable genetic structure.

		We wish to endow our turtles with a genetic structure that enables them to solve some kind
		of problem. The simplest such problem that occurs to me is that of guessing the contents of
		a particular string. Imagine that I am thinking of a famous line from a song, and you have
		to guess that line. You are allowed to suggest a line to me, and I tell you whether you are
		getting warmer or colder.

		So this is our task in this lab: We will construct a world of turtle agents, each possessing
		a genome that specifies an arbitrary character string candidate. The turtles will interact
		with each other in the same way as in SemioticAdaptation, but now their energy will depend
		on how closely their genome fits with the target string. Higher energy turtles will tend to
		survive longer and have more children, until they have discovered the target string.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Run the GeneticStructure module as-is. You will see that it guesses more and more closely
		the contents of a target string - when I ran the program just now, it needed about 3.3e4
		generations to find the target string.

		If you re-run the simulation several times, you will find that the number of generations
		can vary considerably. It may even sometimes be the case that the simulation will stop
		because all of the turtles die. If this happens, just stop the simulation, reset both
		simulation and data, and start the run again. This variability of outcome is the price we
		pay for the speed and flexibility of genetic algorithms.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Notice how the colour of the turtles changes to match the quality of their candidate
		solution: :black is way off, :blue, :red and :orange are better, and :yellow is very close.
		What is the name of the method where these colours are set?
		""",
		"",
		x -> x=="set_fitness!"
	),
	Activity(
		"""
		Study this method - it uses an important tool of genetic algorithms: Sigma-Scaling. First,
		it calculates the average Hamming distance per character between the candidate and the
		target strings. (I have used the term "dissonance" to describe this measure.) Make sure
		you understand the meaning of the term "Hamming distance".
		
		Next, `set_fitness!()` uses the mean and standard deviation (sigma) values of dissonance
		over all turtles in the gs model population. What is the name of the method where these
		population statistics were calculated?
		""",
		"",
		x -> x=="model_step!"
	),
	Activity(
		"""
		set_fitness!() uses these mean and standard deviation values to calculate the turtle's
		fitness from its dissonance using this formula:
			`(gs.mean - turtle.dissonance)/(gs.sigma) - gs.elitism`

		Give me a Tuple containing the value of the fraction in this expression in the three cases
		when the turtle's dissonance is equal to a) the mean dissonance value for the population,
		b) one standard deviation GREATER than the mean, and c) one standard deviation LESS than
		the mean.
		""",
		"Remember that high dissonance means the candidate string is very different from the target",
		x -> x==(0,-1,1)
	),
	Activity(
		"""
		You have just discovered that the following fraction measures how much "better" a candidate
		is than the population mean:
			`(gs.mean - turtle.dissonance)/(gs.sigma)`

		The method `set_fitness!()` now subtracts from this fraction the value `gs.elitism`. What is
		the default value for this model variable?
		""",
		"Look in the initialising method genetic_structure()",
		x -> x==-1
	),
	Activity(
		"""
		In other words, `set_fitness!()` pushes all fitness values up by one standard deviation. What
		percentage of the population will now typically have a fitness value less than zero?
		""",
		"""
		Think about what percentage of a gaussian distributed population is contained between plus
		and minus one standard deviation away from the population mean.
		""",
		x -> (15<x<18)
	),
	Activity(
		"""
		Finally, `set_fitness()` awards the turtle a life energy equal to its fitness multiplied by
		a standard amount `gs.life_energy`. However, it awards NEGATIVE life energy to those turtles
		whose dissonance was worse than one standard deviation from the mean. Which fateful method
		will be called on those turtles as soon as they take their first `agent_step!()`? :-o
		""",
		"",
		x -> occursin( "kill_agent!", lowercase(x))
	),
	Activity(
		"""
		OK, now we understand how the Grim Reaper of selection works. It is time for us to
		understand three important processes associated with genetic algorithms: mutation,
		recombination and elitism. First, set all three sliders mu_rate, crossover and elitism
		to the left - so, to the values 0.0, false and -3. Now reset the model, clear the data
		and perform a run. To which value does the mean dissonance converge?
		""",
		"",
		x -> (25<x<35)
	),
	Activity(
		"""
		Clearly, these parameter values do not solve our String problem very well - in fact, the
		best solution that you see on the screen is merely the best of the 300 strings that were
		randomly created during initialisation. This is the result of only using selection.

		Now change the value of crossover from false to true, reset the model, clear the data and
		perform a new run. To which value does the mean dissonance now converge?
		""",
		"",
		x -> (8<x<20)
	),
	Activity(
		"""
		As you can see, the solution that the genetic algorithm achieves is significantly better
		when we include crossover. Crossover is one mechanism of recombination in which the first
		part of Daddy's genome is combined with the second part of Mummy's genome. The point at
		which the two partial chromosomes are linked is called the Crossover Point (xpt). Find the
		julia code that performs crossover, and tell me: How much of Mummy's genome is appended to
		Billy's genome when xpt==len?
		""",
		"",
		x -> x==0 || occursin("none",lowercase(x)) || occursin("empty",lowercase(x))
	),
	Activity(
		"""
		Crossover is structural puzzling: it takes pieces of different existing solutions and
		puzzles them together in new ways, in the hope that this (re)combination of two partial
		solutions might yield an even better solution. What important barrier places a lower bound
		on the dissonance that can be achieved through crossover?
		
		For example, our target sentence demands a 'w' at the third locus in the genome. If no
		turtle in the random intial population contains a 'w' at the third locus, what is the
		probability that we will obtain a 'w' at the third locus by recombining existing solutions?
		""",
		"Think about how crossover achieves exactly the right character at a specific locus",
		x -> x==0
	),
	Activity(
		"""
		OK, I think you now understand how recombination and crossover work. Now let's move on to
		look at mutation. Reset crossover to false, and push mu_rate all the way up to the maximum
		value 0.1. Perform a new run and tell me to what value the mean dissonance now converges:
		""",
		"This graph will be quite noisy, but you should still see an approximate convergence",
		x -> (20<x<30)
	),
	Activity(
		"""
		Under these conditions, the genetic algorithm is now simply inserting random values for the
		characters in the genome. To see how this is implemented, look at the following two lines
		of code from give_birth!():
			mutated_loci = rand(len).<gs.mu_rate
			billy[mutated_loci] = rand(gs.alphabet,count(mutated_loci))

		What is the type of the variable `mutated_loci`?
		""",
		"Try re-creating a variable of the correct type at the julia prompt",
		x -> (typeof(x) <: BitVector)
	),
	Activity(
		"""
		What do we call the type of indexing used in second line of the above code, that is:
			billy[mutated_loci] = rand(gs.alphabet,count(mutated_loci))
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Mutation certainly moves towards a solution, but the mutation rate 0.1 is so high that
		those candidates solutions are mutated once again before selection has time to decide which
		of them should be allowed to reproduce. Reset the population and sliders to the values
		mu_rate=0.05, crossover=false, elitism=-3, then run a new simulation until it converges to
		a fairly stable value. Now halt the simulation without clearing any values or data. What is
		the approximate value of dissonance?
		""",
		"",
		x -> (17<x<23)
	),
	Activity(
		"""
		As you see, lowering the mutation rate improves the quality of our solution. However, it
		still isn't good enough. Now, without changing anything else, change crossover to true and
		press "update" and "run model" to continue the run using crossover. Notice how the graph of
		dissonance takes a downturn: crossover works well together with mutation!
		
		Now reduce the mutation rate to 0.01, while keeping crossover==true. You should now be able
		to achieve the optimal solution with dissonance 0.0. How many generations does it take to
		achieve this optimal solution?
		""",
		"This value will vary between runs, but it should certainly be above 30000.",
		x -> x>2e4
	),
	Activity(
		"""
		OK, so we know how to achieve an optimal solution, but it still takes a long time to get
		there. And indeed there is a way we can improve this running time. Reset everything and
		then set these values: mu_rate=0.01, crossover=true, elitism=-1. How long does it now
		take to reach the optimal solution?
		""",
		"",
		x -> x<1e4
	),
	Activity(
		"""
		To find out what elitism does, go back now to the calculation of fitness in set_fitness!():
			fitness = (gs.mean - turtle.dissonance)/(gs.sigma) - gs.elitism

		Suppose we vary the elitism parameter between the values -2 and -1. Remember we discovered
		earlier that elitism==-1 corresponds to ADDing 1 to the value of fitness. The result of
		this change is to boost the gaussian distribution by 1 standard deviation, thus excluding
		one-sixth of individuals from reproducing.

		Now consider the value elitism==-2. From your knowledge of the gaussian distribution, what
		fraction of the population lies outside two standard deviations from the mean? And
		therefore, what percentage of the population gets excluded when elitism==-2?
		""",
		"Remember the percentage outside 2*sigma is divided between 2 tails of the distribution",
		x -> (2<x<3)
	),
	Activity(
		"""
		So we see that higher values of elitism EXCLUDE more members of the population. If you
		raise elitism to the value +3, you will find so few turtles survive that the simulation
		no longer runs!

		Now I have a final challenge for you. At present, the first line of set_fitness!() calls
		the method dissonance(). Replace this call by a call to the alternative method
		local_dissonance(). Although this method also has a global minimum when its two argument
		strings are equal, you will discover that the genetic algorithm no longer converges to the
		target sentence. Find out why, and see if you can find values for the three parameters
		mu_rate, crossover and elitism that enable you to locate the correct target sentence.
		""",
		"",
		x -> true
	),
]