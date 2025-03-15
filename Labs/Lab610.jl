#========================================================================================#
#	Laboratory 610
#
# Particle-Swarm Optimisation
#
# Author: Niall Palfreyman, March 2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 610: Particle-Swarm Optimisation (PSO).

        In the previous lab (Suboptimisation), we saw how a collective of agents using regular
        search methods can get trapped in suboptimal solutions of a difficult optimisation problem.
        In this lab, we look at how stabilisation and particle-swarm optimisation (PSO) offer a
        solution to this problem by endowing the swarming particles with a memory. For this reason,
        we will call our agents "Ants" to acknowledge that individuals are endowed with the first
        primitive components of cognition.
        
        While wandering around, each ant in the swarm remembers the best solution it has yet
        discovered, and if its current solution is worse than this remembered value, it communicates
        its dissatisfaction to other ants in the form of accelerated motion. This memory and
        the spreading random motion make the behaviour of the entire swarm emergent.

        First run and observe the PSO model as it comes - using the valleys objective function.
        Where do the ants gather at first?
        """,
        "",
        x -> occursin("minim",lowercase(x))
    ),
    Activity(
        """
        At first, the groupings within the three minima are fairly stable, but notice how the two
        non-global minima suddenly start to 'boil', as the ants' random motion becomes affected by
        the dissatisfaction of ants that have already visited the global minimum. At this point,
        the large green dot representing the centre of mass of all ants starts to move more
        rapidly. Toward which minimum does the centre of mass start to move?
        """,
        "",
        x -> x=="global"
    ),
    Activity(
        """
        Communication is crucial to swarm optimisation. Demonstrate this now by locating the line
        of code in PSO.jl, in which the current ant communicates its dissatisfaction to its
        neighbours by telling them to accelerate. Comment out this line of code and notice how
        stabilisation on its own is capable of locating the minima, but how many minima does the
        swarm end up choosing?
        """,
        "",
        x -> x==3
    ),
    Activity(
        """
        Now restore the code line that you previously commented out, so that the non-global
        maxima boil away towards the global maximum. Experiment with the Temperature control - this
        raises and lowers the probability that ants will spontaneously accelerate. First set the
        temperature to 0.0. Does this speed up or slow down the search process?
        """,
        "",
        x -> occursin("slow",lowercase(x))
    ),
    Activity(
        """
        Now set the temperature to its maximum value (1.0). Does this speed up or slow down the
        search process?
        """,
        "",
        x -> occursin("speed",lowercase(x))
    ),
    Activity(
        """
        Keeping the temperature at maximum, study the behaviour of the ants around the global
        minimum. Are the ants capable of locating the global minimum precisely?
        """,
        "",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Find a value for temperature that in your opinion generates an optimal search for the
        global minimum.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        There is something else that we can do to accelerate the PSO search: improve the
        communication between the ants. What if each ant informed others of its own best-so-far
        remembered value of the objective function? Try this now. Find an ELEGANT and EFFICIENT
        place in the method agent_step!() to insert a for-loop in which the ant informs neighbours
        of its memory value - but ONLY if this information is useful. Then run the PSO simulation
        again to check that the ant-swarm can now locate the global minimum faster.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Before we move on, I want to emphasise the basic idea of stabilisation in relation to PSO.
        The ants are not aware of the global minimum, but they do respond to their circumstances by
        speeding up or slowing down: they slow down when they are close to other ants, and when they
        find a minimum that is better than their current best-so-far. In this way, they locate the
        global minimum without any one ant having to know where it is. This is an example of the
        principle of emergence in action.
        """,
        "",
        x -> occursin("right",lowercase(x)) && occursin("up",lowercase(x))
    ),
    Activity(
        """
        Now switch the Difficult flag to True, in order to investigate the far harder optimisation
        problem of the dejong2() function. Use all the tips and tricks you have so far learned in
        this lab to locate the global minimum as efficiently as possible.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        You will notice that there is a slight problem with this simulation. Although the swarm is
        capable of locating the global minimum, the green centre-of-mas dot never really approaches
        this minimum very closely. Why is this?
        
        Notice that after a while, all agents have disappeared from the left-hand and lower
        quadrants, but there are still many in the upper-right quadrant. Use your mouse cursor to
        compare the depth of minima in the various quadrants. Which quadrant contains the deepest
        minima?
        """,
        "",
        x -> occursin("right",lowercase(x)) && occursin("up",lowercase(x))
    ),
    Activity(
        """
        As you can see, the upper-right quadrant contains deeper minima, and so traps many ants
        where they cannot cross to - or even become aware of - the global minimum. I suspect that
        it is possible to fix this problem using Simulated Annealing.

        In practice, artificial intelligence systems often use Annealing to find solutions. That
        is, they start off the search with a high temperature in order to accelerate the search,
        and then gradually lower the temperature in order to improve the accuracy of its result.
        Implement an annealing schedule to see if I am right in assuming that we can improve the
        search quality for the dejong2() objective function.

        But be careful! You may find that it is very difficult to find an annealing schedule
        which is a perfect fit for both the valleys() AND the dejong2() objective functions.
        This difficulty is a consequence of the so-called No-Free-Lunch Theorem! (Look this up!)
        """,
        "",
        x -> true
    ),
]