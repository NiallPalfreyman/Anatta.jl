#========================================================================================#
#	Laboratory 308: Stabilisation
#
# Author: Niall Palfreyman, March 2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 308: Stabilisation.

        Stabilisation is the construction process by which almost all systems build structure
        over time. Imagine sand swirling around the bottom of the ocean, and imagine a large
        shipwreck lying stably in the sand. The shipwreck is already resting quite stably on the
        ocean floor, so that randomly moving sand washes up against it, raising a sand-bank all
        around the wreck. This sand-bank increases the stability of the shipwreck's position, thus
        also increasing the possibility of more sand washing up against it. This is Stabilisation:
            When stability is already present, random environmental fluctuations tend to
            consolidate this stability!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The previous example assumes that a shipwreck is already resting stably on the ocean bed,
        but of course some other object might also function as an anchor for stability ...
        
        What about a single grain of sand? Well, this clearly wouldn't work, because it can be too
        easily dislodged and pushed away by incoming sand.

        But what about a small twig? It might not be at all heavy, at first floating around freely,
        but slowly, sand arriving on one side supports the twig in one direction, settling it
        slightly more firmly in the sand. Meanwhile, because the twig is now moving less, sand
        arriving from the other side builds up against it nd supports the twig in the opposite
        direction. Because the twig is long enough to weave together the effects of multiple grains
        of sand, more and more sand accumulates around the twig, increasing its stability even
        further. The twig links together the effect of multiple grains of sand, building structure
        out of nothing at all through the process of Dynamical Stabilisation:
            Provided some non-local field (such as the twig) is present that can link together the
            influence of small, randomly occurring fluctuations in the environment, this field can
            consolidate these fluctuations into larger scale stability.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The concept of stabilisation resolves a deep question at the centre of evolutionary theory:
            What is evolutionary fitness?!
            
        Take a moment to think about your own answer to this question. You may think that fitness
        is the ability to fight well, or hunt for food, or have lots of children or a strong immune
        system. But what if you have a long infertile life? Or fight well, but find no food? Or
        have lots of children that are not themselves interested in having children.

        Or: What if you yourself are not interested in having children, but in saving the lives of
        other people's children?

        Think hard about your own opinions on this issue.
        """,
        "There are no right or wrong ansers here: What is your opinion?",
        x -> true
    ),
    Activity(
        """
        Now that you have considered your own answers to this question, team up with one or two
        others to discuss your group answers to this question:
            How can anyone measure fitness?
        """,
        "Discuss with your partners: What is the only measurable criterion of an organism's fitness?",
        x -> any(occursin.(["child","reproduc","fertil","offspr"],lowercase(x)))
    ),
    Activity(
        """
        You may have come to the conclusion that the only way to measure fitness of an organism is
        by counting the number of its offspring over several generations. But in that case, the
        clarion call "Survival of the fittest!" that supposedly lies at the centre of evolutionary
        theory, actually means nothing more than this:
            Organisms that have more children, have more children!

        This circular definition shows that Darwin's revolutionary idea is not actually expressed
        very well by classical notions of fitness and population growth!

        Stabilisation resolves this dilemma by reformulating fitness in terms of stability. In
        order to survive and evolve, organisms and ecosystems do not need to grow faster than
        everyone else. Rather, they simply need to achieve stable co-existence with their
        environment. Viewed in this way, the central idea of evolutionary theory becomes:
            Systems that are more stable generate even wider stability.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        So stabilisation is the crucial idea at the centre of evolution. In the module
        Stabilisation, agents move around randomly, but they also stick to each other: they slow
        down when they come close to each other. Do you remember Reynolds' flocking boids? There,
        a simple set of rules led to the boids clustering into flocks. Here, the same thing happens
        as a result of just one rule: if you have a neighbour, slow down and chat.

        Run the Stabilisation model now to see what the resulting behaviour looks like.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Again, we see that the Stabilisation model is capable of making decisions. As it runs,
        the agents form a series of 'heaps' that slowly redistribute their component agents until
        eventually only one pile is left: the model has 'chosen' that location. Yet notice that
        there are still individual agents flying around and able to look for new, better choices.

        Test this search flexibility of the Stabilisation model: Adapt the method agent_step!()
        to create a specific 'sticky' location in the environment for agents to find. Then, when
        they have chosen this location, shift the sticky point to a new location to see if the
        agents are capable of shifting their choice to the new location.
        """,
        "",
        x -> true
    ),
]