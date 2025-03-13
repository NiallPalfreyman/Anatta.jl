#========================================================================================#
#	Laboratory 608
#
# Stabilisation
#
# Author: Niall Palfreyman, March 2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 608: Stabilisation.

        Stabilisation is the construction process by which almost all systems build structure
        over time. Imagine sand swirling around the bottom of the ocean: occasionally it comes to
        rest at an obstacle, whereupon it creates even more of an obstacle for more sand, until
        the sand builds up around the obstacle. This is Stabilisation: stability begets stability.
        
        Now imagine an empty shell that falls onto the seabed: at first, it can float around
        freely, but slowly it becomes stuck in sand. Then, because it is no longer moving, even
        more sand gathers around the shell, making it even more stable. This process is called
        Dynamical Stabilisation:
            Things stay the same because randomly ocurring stability encourages more stability.
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
        point for the agents to find, and then later move this sticky point to a new location
        to see if the agents are capable of shifting their choice to the new location.
        """,
        "",
        x -> true
    ),
]