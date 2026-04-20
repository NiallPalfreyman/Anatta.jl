#========================================================================================#
#	Laboratory 314: Reaction-diffusion systems
#
# Author: Niall Palfreyman, March 2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 314: Exploratory processes

        In lab 311, we attempted - and failed - to reproduce the work of Hinton and Nowlan (1987).
        They had demonstrated that the life-cycle of organisms is central to the functioning of
        genetic selection. At the end of that lab, we set out a programme of work to help us
        discover how we might use their results to solve optimisation problems more effectively:
            -	Investigate genetic structure and algorithms;
            -	Investigate ways of focusing problem-solving behaviour;
            -	Investigate exploratory developmental processes.

        In the module SelectiveSearch, we investigated how GAs use genetic structure to recombine
        old solutions into new ones. In the module SelectiveExploration, we saw how agents find it
        difficult to optimise rugged (that is, spiky and multimodal) objective functions through
        recombination and selection alone. In the module NarrativeExploration, we will see how
        populations can improve their evolutionary problem-solving ability if they contain agents
        that are Not merely genetic black-boxes, but which actively construct meaning from their
        developmental experience through exploration and plasticity.
        """,
    ),
    Activity(
        """
        We will first find it useful to summarise the definition of several technical terms.
        -   Evolution is the process by which populations of organisms discover more effective
            ways of surviving.
        -   Development is the process by which individual organisms change over the course of
            their entire life-cycle. Development involves three subprocess: Exploration,
            Plasticity and Intention.
        -   Exploration is the organism's continuous trying-out of new forms of behaviour, and
        -   Plasticity is the organism's ability to stabilise its exploration, and so accumulate
            (i.e., learn) certain habits of behaviour.
        -   Intention is what makes organisms act In Order to achieve some goal. For the moment,
            I shall say nothing further here about intention, since its definition is complex.
        -   A Narrative is any process in which plastic exploration is guided by intention. For
            example, organism development is governed by intention, and is therefore a
            narrative process.
        
        The module NarrativeExploration investigates how evolutionary processes use developmental
        narratives to explore and solve problems ...
        """,
    ),
    Activity(
        """
        Please load the module NarrativeExploration now, and execute NarrativeExploration.demo().
        Then, in the graphical interface, raise the dt slider to 200 and press Step model five
        times. You will see the results of 1000 generations of a simulation that reproduces the
        work of Hinton and Nowlan (H&N).
        
        On the right-hand side, you can see three graphs displaying the mean dissonance, the mean
        plasticity and the minimum dissonance of the agent population. Each agent possesses a
        randomly valued 21-locus genome, and the allele value at each locus is either A or B. Each
        agent also possesses a 21-locus plasticity genome containing the allele true/false at each
        locus. These plasticity values will become relevant in a later experiment.

        From the sliders, you can see that the mutation rate is 2e-3, the length of the target
        string is 21 characters (one at each locus), and the number of distinct alleles (or
        possible string characters) at each locus is 2 (automatically labelled A and B). How much
        life energy does each agent possess at the beginning of its life?
        """,
        "life_energy",
        x -> x==2
    ),
    Activity(
        """
        At each step of the simulation, each agent 'ages' by losing a small living_cost==0.1 units
        of energy. When the agent's energy reaches zero, it dies, so an agent lives by default how
        many generations?
        """,
        "How many living_costs make up one life_energy?",
        x -> x==20
    ),
    Activity(
        """
        At each step, an agent can give birth to a new agent, provided it has sufficient energy and
        the maximum population has not been exceeded. Giving birth costs the agent a further energy
        cost of birth_cost==2living_cost, so if the maximum population has not yet been reached, an
        agent can theoretically live for 6 generations and give birth to 6 babies.
        
        In our simulation, I have transformed selection into an interaction game between agents. At
        each step, an agent can raise its energy (and so extend its life and fertility) by
        comparing its objective function value with that of its best neighbour. If the agent's own
        objective value is better than that of the neighbour, the agent's energy is raised by an
        amount (benefit*living_cost). Look up the value of benefit in the sliders. What is the
        numerical value of the energy that an agent can currently gain by comparing its objective
        value with that of a neighbour?
        """,
        "benefit*living_cost",
        x -> x==0.2
    ),
    Activity(
        """
        So we see that agents whose objective value is better than that of their neighbours can
        extend their fertility and so spread their genes more widely through the population.
        Therefore, the objective function determines which problem the agents are solving through
        their survival. The dissonance function is defined to lie within the interval [0,1]: the
        value 0 means that two genomes (strings) are identical; the value 1 means they are
        maximally different. If you look at the code in the second half of the method
        NarrativeExploration.explore!(), you will find that each agent natalia compares the
        following value with that of her best neighbour:
            objective(natalia,ne) == spiky( 1-natalia.dissonance, ne.difficulty)

        The first thing to notice here is that the compared value is based not on natalia's
        dissonance, but on (1-natalia.dissonance). If natalie's string is an exact copy of the
        target string, what will be her value of 1-natalia.dissonance?
        """,
        "An exact match has dissonance zero with the target string",
        x -> x==1
    ),
    Activity(
        """
        So each agent natalia is trying to maximise the value of this objective function:
            spiky( 1-natalia.dissonance, ne.difficulty)

        What is the current value of ne.difficulty?
        """,
        "Look at the difficulty slider",
        x -> x==1.0
    ),
    Activity(
        """
        The method spiky( x, spikiness) is defined in AgentTools.jl - look at the code now. In
        NarrativeExploration.explore!(), I use the difficulty value 1.0 to define the spikiness
        argument of this method. What is the value of spiky(x,1.0), where x is any value less
        than 1.0?
        """,
        "Study the code of the spiky() method carefully",
        x -> x==0.0
    ),
    Activity(
        """
        You have just discovered that the objective value of any random agent natalia whose genome
        is even slightly different from the target string, is:
            spiky( 1-natalia.dissonance, 1.0) == 0.0

        Therefore, the Only agents who have any advantage over other agents are those whose genome
        Exactly matches the target string. This is a very hard problem to solve indeed! What is the
        probability that a genome of 21 random allele values A or B will exactly match the target
        string A^21 (i.e., 21 A's in a row)?
        """,
        "How many different strings of length 21 can you create from the characters {A,B}?",
        x -> x<2^(-20)
    ),
    Activity(
        """
        Now you can understand how the results in your graphs arise. The agents run around,
        creating random strings that will almost never exactly match the target string! Some of the
        strings have a better-than-average match with the target, and some have a worse-than-
        average match. What is the average probability that any random A/B allele will match
        another random A/B allele?
        """,
        x -> x==0.5
    ),
    Activity(
        """
        You can see that this is indeed the average value of the mean dissonance graph at the top
        right of the window. The minimum dissonance graph at the bottome right shows the best
        dissonance achieved in the population. What is its typical value?
        """,
        x -> 0.2<x<0.3
    ),
    Activity(
        """
        Now press Run model and observe the results for about 5000 generations to verify that the
        values of mean and minimum dissonance stay approximately the same. Then press Run again to
        pause the model. Next, set the difficulty slider to 0.0 and press update. If you now press
        Run, you will quickly see that the mean and minimum dissonancees fall to zero, and many
        agents become yellow, indicating that their genome is practically identical to the target
        string.

        What has happened? To find this out, look back at the spiky() code. What is the numerical
        value of the method call spiky(0.3,0.0)
        """,
        x -> x==0.3
    ),
    Activity(
        """
        As you see, if the difficulty (or spikiness) is zero, the call spiky(x,0) returns the value
        x. This means that the objective function:
            spiky( 1-natalia.dissonance, ne.difficulty)

        no longer returns only the value 0 and 1, but a whole range of values in the range [0,1]
        returned by the expression (1-dissonance). In other words, All agents now receive feedback
        on how well or badly they match the target string, and this correspondingly influences
        their fertility. This allows the system to achieve the target string A^21, which you
        should see in red text in the bottom graph.
        """,
    ),
    Activity(
        """
        Let's summarise what we have observed so far: It takes about 2 million (2e21) attempts to
        guess at random the 21-bit target string "AAAAAAAAAAAAAAAAAAAAA", which is what our agents
        must do if they receive feedback only on whether their genome exactly matches the target.
        If, however, they receive graded feedback on how good or bad their current guess is, they
        can use this feedback to home in much more quickly on the target string.
        """,
    ),
    Activity(
        """
        At this point, H&N introduced a new aspect of evolution into their simulation, that is
        different from genetic selection: semiotic adaptation. As we discussed in the previous lab,
        Semiotic adaptation involves exploration and plasticity. It treats the genome as the
        specification, not of a phenotype, but rather of the lifecycle narrative that an organism
        uses to explore and interact with its environment. In the context of our simulation, if
        you now move the Narrative slider to True, the genome now specifies a base phenotype string
        that is modified at each step of the agent's lifecycle.

        However, NarrativeAgents also possess a second part to their genome. Study the very first
        assignment statement in NarrativeExploration.explore!(): at each lifecycle step, this
        statement selects a new random character at specific loci along the agent's phenotype.
        These locus positions are specified by the allele 1 (true) at the corresponding locus on
        the plasticity genome of the NarrativeAgent. What is the name of the NarrativeAgent field
        that stores this plasticity genome?
        """,
        "",
        x -> occursin("p_genom",lowercase(x))
    ),
    Activity(
        """
        Together, v_genome and p_genome specify the possible phenotype explorations that the agent
        can perform. Look at NarrativeExploration.explore!() and notice that it contains two
        if-statements: the first explores new phenotypes, while the second implements plasticity
        by halting this exploration:
        -   In the first (exploratory) if-statement, if the agent is not yet fixed, the code
            explores new phenotypes by randomising those alleles of v_genome whose loci are
            specified by a 1 (true) in the p_genome.
        -   In the second (plasticity) if-statement, if the agent's current phenotype yields a
            better objective value than that of all nearby neighbours, the code increases the
            agent's energy then fixes its phenotype, preventing the phenotype string from returning
            to its original, genome-specified form.

        From our earlier definitions, what do we call this combination of exploration and plasticity?
        """,
        "",
        x -> any(occursin.(["learn","develop"],lowercase(x)))
    ),
    Activity(
        """
        Let's test our learning simulation to reproduce the results of H&N. Start the demo program
        afresh, set dt==200 and make sure difficulty==1 and narrative==false. Run the simulation
        for a couple of thousand generations, then pause it by pressing Run again, to check that:
        -   none of the three graphs is converging,
        -   the agents are all blue or black (i.e., far from the target string), and
        -   the red text of the current best candidate contains random A/B alleles.

        Now slide the Narrative slider to true to switch on the organisms' life-narrative and press
        the Update button. Then watch what happens. It might happen sooner, or it might take 1e5
        generations to hqppen, but eventually the minimum dissonance will latch onto 0.0, and the
        mean dissonance will slowly work its way down to zero. When this has occurred, pause the
        simulation again by pressing Run, and study carefully the story told by the three graphs...
        """,
    ),
    Activity(
        """
        First, note that the minimum dissonance curve may not have immediately clung to the value
        0.0. Remember that this dissonance is a property of the phenotype, rather than of the
        genome, and so the agent cannot pass on this success directly to its children. However,
        when the minimum dissonance of the population touches zero, you might see that the mean
        dissonance drops significantly.

        When the minimum dissonance stays firmly at zero, you should observe two things. First, the
        number of orange and yellow (i.e., successful) agents increases, as successful agents
        pass on to their children their current best recipe for building the target string.
            
        Second, the mean dissonance of the population falls sharply as more and more agents inherit
        the ability to construct the target string within their own life-narrative. Does this mean
        dissonance value drop immediately to zero?
        """,
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        You should see that the mean dissonance initially falls, but then pauses at a lower value,
        possibly between 0.2 and 0.3. At this stage, many agents can construct the target string,
        but this construction is not yet reliable, requiring developmental exploration to achieve
        it. You will see that the plasticity then drops, as new agents establish a genome that more
        reliably constructs the target. The agents can construct the target maximally reliably when
        all v_genome loci contain the allele A and all p_genome loci contain the value ... ?
        """,
        "",
        x -> x==0 || any(occursin.(["zero","false"],lowercase(x)))
    ),
    Activity(
        """
        Let's study this evolutionary process in action. Restart the simulation - either by closing
        the program and re-executing or by pressing Reset Model - but before you do so, set:
            dt==200; sleep==0.1; narrative==true

        We want to observe the process of semiotic adaptation in action, which is why we slow down
        the simulation. These settings should enable you to observe the model's behaviour in slow
        motion; however, if it takes too long before the system discovers the target phenotype, you
        may choose to restart the simulation. You will be best able to see what's happening if the
        minimum dissonance curve clings to zero within the first 10000 generations. Allow the
        simulation to run until Just After the mean dissonance starts to drop, then pause the
        simulation by pressing Run.

        Now study the three graphs in the paused simulation carefully. You should see that the
        mean dissonance curve has started to drop. Does the mean plasticity curve drop before,
        simultaneously, or after the mean dissonance curve?
        """,
        "",
        x -> occursin("after",lowercase(x))
    ),
    Activity(
        """
        Use the Step Model button to find a generation in which there is at least one B in the
        minimum-dissonance v_genome. Now look at the corresponding locus in the (blue) p_genome.
        What is its value?
        """,
        "",
        x -> x==true
    ),
    Activity(
        """
        As you see, the minimum dissonance v_genome can achieve the target string if at each locus
        it has either an A-allele or else a B-allele at the locus corresponding to a True in the
        p_genome. Only in this way can the agent achieve the target allele value A through
        exploration at this locus. This is the key to the success of the NarrativeAgents: they can
        achieve the target phenotype by flexibly exploring different alleles at plastic loci.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now press Run Model again see the mean dissonance curve drop to zero. Notice that the
        mean dissonance and mean plasticity curves drop to zero in steps, with the plasicity steps
        always following the dissonance steps. This is because the system discovers a new way of
        achieving the target string through exploration, and then the plasticity of the agents is
        selected to stabilise this new way of achieving the target string, so that it can be
        reliably passed on to future generations.
        
        This is the process of semiotic adaptation in action. First the v_genome explores a new
        way of achieving the target string, but then new children can achieve the target even more
        quickly by setting the v_genome locus to A and the corresponding p_genome locus to False,
        so that the target allele A is achieved without exploration. The system constantly
        discovers new ways of achieving the target string through exploration, then stabilises
        these new ways through plasticity.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now relaunch the simulation and set:
            dt==200; narrative==true; target_length==22

        Press Reset and then Run. If you are lucky, the simulation may discover the target string
        A^22 within 1e5 generations; however, as soon as you set target_length to 23 or higher,
        the simulation will not manage to discover the target string at all.

        So although exploration and plasticity can help to solve problems that are just beyond the
        reach of traditional evolutionary search, they are no panacea for solving hard problems.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now it's your turn to experiment with plastic exploration. Try running the A^22 simulation
        with Narrative set to true, but with different mutation rates, difficulty values and
        benefit values. Get a feel for how these parameters influence the system's ability to
        discover the target string.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now relaunch the simulation and set:
            dt==200; narrative==false; allele_count==1; difficulty==0.0; target_length==188

        These settngs reproduce our earlier experiments with the Kant quotation string. You
        should see that the system can discover the quotation string fairly quickly.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Using the same settings as in the previous activity, gradually increase the value of
        difficulty to localise the dissonance information availability until the system is no
        longer able to discover the Kant quotation string. What is the highest value of
        difficulty at which the system can still discover the target string?
        """,
        "",
        x -> x==0.5
    ),
    Activity(
        """
        Using this observation, now relaunch the simulation and set:
            dt==200; narrative==false; allele_count==1; difficulty==0.6; target_length==188

        This is the Kant quotation string again, but with a much higher difficulty value, so that
        dissonance information is more localised, and the system is no longer able to discover the
        target string under these conditions.
        
        Now set narrative==true and reset the simulation. Now the system does somewhat better at
        discovering the target string, and after about 1e5 generations, you should see that the
        letters of the minimum dissonance string are quite close to those of the target string. 
        
        How many generations does the system take to get close enough to the target string for
        most of the agents to turn yellow?
        """,
        "",
        x -> x > 2e5
    ),
    Activity(
        """
        Now go back to either the A^22 or the Kant quotation string problem, and set
            unimodal_fitness==false

        This setting changes the objective function from a unimodal function to a bimodal
        function, which can trap the system in local optima. Can you find a setting of the other
        parameters that allows the system to escape from these local optima and discover the target
        string?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, that's all for this lab. You have seen how the life-cycle of organisms can be used to
        solve problems that are just beyond the reach of traditional evolutionary search. You have
        seen how the combination of exploration and plasticity can allow organisms to discover new
        ways of achieving a target phenotype, and then stabilise these new ways so that they can
        be reliably passed on to future generations.
        
        In the next lab, we will see how populations of agents can use exploration and plasticity
        as opportunities to solve problems cooperatively.
        """,
        "",
        x -> true
    ),
 ]