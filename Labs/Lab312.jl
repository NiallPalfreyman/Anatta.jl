#========================================================================================#
#	Laboratory 312: Selective Search.
#
# Author: Niall Palfreyman, March 2026.
#========================================================================================#
[
    Activity(
        """
        Hi - Welcome to Anatta Subject 312: How do we select recombinable genetic structures?

        We wish to endow our agents with a genetic structure that enables them to solve some kind
        of problem. The simplest such problem that occurs to me is that of guessing the contents of
        some given string. Suppose I am thinking of a famous quotation from Kant's Critique of Pure
        Judgement, and you have to guess that quotation. You are allowed to suggest a line to me,
        and I tell you whether you are getting warmer or colder. You can then use this information
        to make a better guess, and I again tell you whether you are getting warmer or colder.

        So this is our task in this lab: We will construct a world of agents that each possesses a
        genome specifying an arbitrary character string candidate. We will call this first iteration
        of the simulation SelectiveSearch. Although it contains agents, they do not move, but
        merely swap genomes as a kind of monolithic "genetic algorithm machine" that Only makes use
        of the selection of genetic search structures.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Run the SelectiveSearch module as-is. You will see that it guesses more and more closely
        the contents of a target string - when I ran the program just now, it needed about 2000
        generations to find the target string.

        If you re-run the simulation several times, you will find that the number of generations
        can vary considerably. It may even sometimes be the case that the simulation will stop
        because all of the agents die. If this happens, just stop the simulation, reset both
        simulation and data, and start the run again. This variability of outcome is the price we
        pay for the powerful flexibility of genetic algorithms (GAs).
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice how the colour of the agents changes to match the quality of their candidate
        solution: :black is terrible, :blue, :red and :orange are better, and :yellow is very close.
        What is the name of the method where these colours are set?
        """,
        "",
        x -> x=="set_dissonance!"
    ),
    Activity(
        """
        This method uses the method dissonance() to calculate the average Hamming distance per
        character per locus between the candidate string and the target string. Make sure
        you understand the meaning of the term "Hamming distance". What would be the value of the
        dissonance when the candidate string is exactly the same as the target string?
        """,
        "",
        x -> x==0
    ),
    Activity(
        """
        At the beginning of model_step!(), the dissonances of all agents are gathered into a
        vector, which is then passed to the method select_parents(), which uses the dissonance
        values to select parents for reproduction. Study this method - it uses an important tool
        of genetic algorithms, called Sigma-Scaling. First, it calculates the mean and standard
        deviation (sigma) of all dissonances in the ss model population. Then it uses these mean
        and standard deviation values to calculate the agents' fitness using this formula:
            `(ss.mean - dissonance)/(ss.sigma) - ss.elitism`

        Give me a Tuple containing the value of the fraction in this expression in the three cases
        where the turtle's dissonance is equal to a) the mean dissonance value for the population,
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
            `(ss.mean - dissonance)/(ss.sigma)`

        The method `select_parents()` now subtracts from this fraction the value `ss.elitism`. What is
        the default value for this model variable?
        """,
        "Look in the initialising method selective_search()",
        x -> x==-1
    ),
    Activity(
        """
        Now suppose we changed the value of elitism from 0 to -1. This would have the effect of ADDing
        1 to the value of fitness for all turtles. In other words, `select_parents()` would then boost
        all fitness values up by one standard deviation. What percentage of the population will now
        have a fitness value less than zero?
        """,
        """
        Think about what percentage of a gaussian distributed population is contained between plus
        and minus one standard deviation away from the population mean.
        """,
        x -> (15<x<18)
    ),
    Activity(
        """
        Finally, select_parents() creates and uses two vectors: `roulette` and `throws`. The
        `roulette` vector contains the cumulative angles of the slots in a roulette wheel, and the
        `throws` vector contains random angles around this roulette wheel. select_parents() then
        uses these two vectors to select parents for reproduction. To which method is this vector
        of selected parents returned?
        """,
        "",
        x -> occursin( "model_step!", lowercase(x))
    ),
    Activity(
        """
        Selection is one of three important processes used by GAs; the other two are mutation and
        recombination. We will investigate these now. First, set both sliders mu_rate and crossover
        to the left (i.e., to the values 0.0 and false respectively). Also, set the dt slider all
        the way to the right to speed up the simulation. Now press Update and perform a run. To
        which value does the mean dissonance of the population converge?
        """,
        "",
        x -> (0.19<x<0.25)
    ),
    Activity(
        """
        As you can see, these parameter values do not solve our String problem very well - in fact,
        the best solution that you see on the screen is merely the best of the 500 strings that we
        created randomly in the initialisation method selective_search(). This poor solution is the
        result of the fact that we are only using simple selection of existing structures.

        Now change the value of crossover from false to true, reset the model, clear the data and
        perform a new run. To which value does the mean dissonance now converge?
        """,
        "",
        x -> (0.15<x<22)
    ),
    Activity(
        """
        As you can see, the solution that the genetic algorithm achieves is significantly better
        when we include crossover. That is, we achieve lower values of mean and minimum dissonance
        between our solution and the target string when we use crossover.
        
        Crossover is one mechanism of genetic recombination in which the first part of Daddy's
        genome is combined with the second part of Mummy's genome. The point at which the two
        partial chromosomes are linked is called the Crossover Point (xpt). Find the julia code
        that performs crossover, and tell me: How much of Mummy's genome is appended to Billy's
        genome when xpt==len?
        """,
        "",
        x -> x==0 || occursin("none",lowercase(x)) || occursin("empty",lowercase(x))
    ),
    Activity(
        """
        Crossover is like structural puzzling: it takes pieces of different existing solutions and
        puts them together in new ways, in the hope that this (re)combination of two partial
        solutions might yield an even better solution. What important barrier places a lower bound
        on the dissonance that can be achieved through crossover?
        
        For example, our target sentence demands a 'w' at the second locus in the genome. If no
        agent in the random intial population happens to contain a 'w' at this locus, what is the
        probability that we will obtain a 'w' at the second locus by recombining existing solutions?
        """,
        "Think about how crossover achieves exactly the right character at a specific locus",
        x -> x==0
    ),
    Activity(
        """
        OK, I think you now understand how recombination and crossover work. Let's move on to look
        at mutation. Reset crossover to false, and push mu_rate all the way up to the maximum
        value 0.01. Perform a new run and tell me to what value the mean dissonance now converges:
        """,
        "This graph will be quite noisy, but you should still see an approximate convergence",
        x -> (0.13<x<0.15)
    ),
    Activity(
        """
        As you can see, using pure mutation without crossover does not completely solve our problem.
        Under these conditions, the genetic algorithm is now simply inserting random values for the
        characters in the genome. To see how this is implemented, look at the following two lines
        of code from model_step!():
			mutation_loci = rand(gene_length).<ss.mu_rate
			sally[mutation_loci] = rand(ss.alphabet,count(mutation_loci))

        What is the type of the variable `mutation_loci`?
        """,
        "Try re-creating a variable of the correct type at the julia prompt",
        x -> (typeof(x) <: BitVector)
    ),
    Activity(
        """
        What do we call the type of indexing used in second line of the above code, that is:
            sally[mutation_loci] = rand(ss.alphabet,count(mutation_loci))
        """,
        "",
        x -> occursin("boolean", lowercase(x)) || occursin("logical", lowercase(x))
    ),
    Activity(
        """
        Mutation certainly moves rapidly towards a solution, but the mutation rate 0.01 is so high
        that candidates are mutated too rapidly for selection to decide which of them should be
        allowed to reproduce. Now lower the mutation rate to mu_rate=0.0001, then run a new
        simulation until it converges to a stable value.

        As you see, lowering the mutation rate improves the quality of our solution; however, it
        takes a long time to reach this improved solution. Now set mu-rate=0.001 and
        crossover=true. How many generations does it now take until you can read all words of
        the quotation string?
        """,
        "This value will vary between runs, but it should be around 20000.",
        x -> x>3000
    ),
    Activity(
        """
        OK, so we know how to achieve an optimal solution, but it still takes a long time to get
        there. And indeed there is a way we can improve this running time. Use the same settings
        as before (mu_rate=0.001, crossover=true), but now set elitism to its maximum value 0.2.
        How many generations does it take to reach the optimal solution?
        """,
        "",
        x -> x<1500
    ),
    Activity(
        """
        To find out what elitism does, go back to the calculation of fitness in select_parents():
		    fitnesses = (ss.mean .- dissonances)/sigma .- ss.elitism
		    fitnesses[fitnesses .<= 0] .= 0

        The second of these lines sets all fitnesses to zero if the first line has produced a
        negative value. So now think carefully about the value of the expression:
            (ss.mean - sally.dissonance)/sigma
        
        What is the value of this expression when sally's dissonance is equal to the population
        mean (i.e., ss.mean)?
        """,
        x -> (x==0)
    ),
    Activity(
        """
        What is the value of the expression
            (ss.mean - sally.dissonance)/sigma

        when sally's dissonance is one standard deviation (i.e., sigma) GREATER than the population
        mean (i.e., sally's candidate solution is WORSE than average)?
        """,
        x -> (x==-1)
    ),
    Activity(
        """
        What is the value of the expression
            (ss.mean - sally.dissonance)/sigma

        when sally's dissonance is one standard deviation (i.e., sigma) LESS than the population
        mean (i.e., sally's candidate solution is BETTER than average)?
        """,
        x -> (x==1)
    ),
    Activity(
        """
        So the value of the expression
            (ss.mean - sally.dissonance)/sigma

        tells us how many standard deviations sally's candidate solution is BETTER than the
        population mean. If elitism is zero, then the value of the expression
            (ss.mean - sally.dissonance)/sigma - ss.elitism

        will be positive for candidates that are better than the population mean, so the code line
            fitnesses[fitnesses .<= 0] .= 0

        will eliminate from reproduction all candidates that are worse than the population mean.
        If, however, elitism is -1, then sally's fitness will be boosted by one standard deviation,
        so will her chances of reproducing be improved or worsened?
        """,
        x -> occursin("improved", lowercase(x))
    ),
    Activity(
        """
        Now let's return to the two lines that calculate fitness in select_parents():
		    fitnesses = (ss.mean .- dissonances)/sigma .- ss.elitism
		    fitnesses[fitnesses .<= 0] .= 0

        In our last experimental run, we set elitism to 0.2. In this case, this second line of code
        will set to zero the fitness of all candidates whose dissonance is greater/worse than the
        population mean by at least 0.2 standard deviations. This is the meaning of elitism: it
        allows us to exclude from reproduction all candidates that do not score significantly
        higher than the population mean on our measure of fitness.

        As we saw, using elitism definitely speeds up a GA's convergence to the optimal solution.
        However (and this is a big however), we Never have any guarantee that our measure of
        is a good and efficient measure of our approach to the optimal solution. Indeed, there is
        a theorem (the No Free Lunch Theorem) that states that whatever measure of fitness we use,
        there will always be some problems for which this measure of fitness is the worst possible!
        Therefore, elitism can be very dangerous, since it may exclude candidates from reproduction
        that are actually very close to the optimal solution, but which do not score well on our
        measure of fitness!
        """
    ),
    Activity(
        """
        Because it is so difficult (indeed, impossible!) to define an effective measure "fitness",
        we tend in the GA world to avoid that term, and instead use the alternative term
        "objective function" to describe an measure like dissonance that we wish to optimise.
        Before we move on to look deeper at objective functions in the next lab, I first want to
        make you aware of a further difficulty with GAs...
        
        At present, the method set_dissonance!() uses the method dissonance() to calculate the
        calculate the objective function value for each agent. This method calculates the average
        Hamming distance per character between the candidate string and the target string; in
        particular, this objective function has a global minimum when the two strings are exactly
        identical. But what if our objective function were Bimodal. That is, what if it had a
        global minimum at the same point, but also had a local minimum at some other point, where
        the two strings are not identical? This idea is implemented in the method bimodal_dissonance().
        
        In SelectiveSearch, set the slider unimodal_fitness to false, then reset the model and see
        if you can find values for the three parameters mu_rate, crossover and elitism that enable
        you to locate the correct target quotation.
        """,
    ),
]