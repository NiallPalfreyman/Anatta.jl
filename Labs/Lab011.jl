#========================================================================================#
#	Laboratory 11
#
# Deterministic CHAOS and software development.
#
# Author: Niall Palfreyman, 06/09/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 011: Chaos and software development

        In this laboratory, we implement a program to demonstrate chaos in a gravitational system
        containing three bodies of equal mass in two dimensions. We will use julia to analyse the
        execution of a complex simulation program, and adapt this program to use Runge-Kutta
        integration to demonstrate graphically chaotic 3-body motion.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In this lab, we investigate DETERMINISTIC CHAOS. Chaos is extremely important in biology,
        because it is the source of the spontaneity that we observe in living organisms. To see how
        chaos works, start by loading my julia implementation of the Mathematica function nestlist():
            include("Development/Computation/Utilities.jl")
            using .Utilities

        Take a look at the implementation of nestlist(), and then experiment with it. For example,
        what is the result of the following method call?
            nestlist(x->2x,3,5)
        """,
        "",
        x -> x == [3,6,12,24,48,96]
    ),
    Activity(
        """
        nestlist() applies a function f repeatedly to the initial value x0, creating a list of the
        values that it generates in this way. This might be useful if we're modelling some specific
        population growth rule over time. Take for example the discrete logistic situation ...

        Imagine a population of wasps living on an island with renewable but limited resources:
            -   They can saturate the island's resource capacity (population x = 1).
            -   They can die out (x = 0).
            -   The population can have any size in the range 0 ≤ x ≤ 1.
            -   If the population gets too big (i.e., x close to 1), wasps will starve.
            -   If the population gets very small (x close to 0), wasps will thrive.
            -   All wasps die each winter, so their seasonal population has a new value each year:
                    [x0,x1,x2,...,xn].
        """,
        "",
        x -> true
    ),
    Activity(
        """
        These assumptions suggest that there exists some growth function L() that maps the wasp
        population size in one year onto the population size in the following year. That is:
            x[n+1] = L(x[n]) , or written differently: L : x[n] -> x[n+1]

        One commonly used growth function is the Discrete Logistic function. In the julia console,
        define the discrete logistic function L for the specific growth rate r = 2:
            r = 2
            L(p) = r * p * (1-p)

        Experiment with this function, and make sure you understand how growth and death processes
        explain the values of L(0.1), L(0.2), L(0.8) and L(0.9). What is the value of L(0.5)?
        """,
        "",
        x -> x==0.5
    ),
    Activity(
        """
        As you see, when r=2, the logistic function causes small populations (p<0.5) to grow, and
        large populations (p>0.5) shrink. We call p=0.5 a Fixed Point of this growth function,
        because when the population equals 0.5, it neither grows nor shrinks from this value.

        Verify these statements by using nestlist() to generate a sequence of 10 population values
        starting from the initial value 0.01:
            nestlist(L,0.01,10)

        Towards which value does this sequence converge?
        """,
        "",
        x -> x==0.5
    ),
    Activity(
        """
        We can also visualise such sequences:
            using GLMakie
            lines(nestlist(L,0.001,15))

        Towards which value does this sequence converge?
        """,
        "",
        x -> x==0.5
    ),
    Activity(
        """
        We would really like to start investigating how these graphs change as we modify the value
        of the specific growth rate r. However, it is a little confusing if we have to constantly
        use assignment statements to redefine r each time we change its value. For this reason, we
        will instead define L to be a Functional - that is, L's return value is a FUNCTION whose
        definition depends on the current value of r. Do this now - define L(r) to return a
        discrete logistic function that is dependent on the current specific growth-rate r of the
        wasp population:
            L(r) = (p -> r * p * (1-p))

        Now verify that L(2) is a discrete logistic function with all the properties you found
        above, for example, towards which value does this sequence converge?
            lines(nestlist(L(2),0.001,15))
        """,
        "",
        x -> x==0.5
    ),
    Activity(
        """
        Now we've set up a test-bed for our experiments, use your functional L to calculate the
        wasp population two years after an intial population of x0 = 0.3, assuming that r = 0.5:
        """,
        "nestlist(L(0.5),0.3,2)[end]",
        x -> (0.04698 < x < 0.04699)
    ),
    Activity(
        """
        Use nestlist() to create a list of 5 simulation steps of the wasp population, starting from
        an initial value of 0.3 and using specific growth rate r = 0.5. You will see that the
        population x is converging towards a particular limiting value - what is that limit value?
        """,
        "nestlist(L(0.5),0.3,5)",
        x -> x==0
    ),
    Activity(
        """
        Now plot a graph, using nestlist() to create a list of 20 simulation steps of the wasp
        population with x0=0.3 and r=0.9. What is the limit point of this sequence?
        """,
        "lines(nestlist(L(0.9),0.3,20))",
        x -> x==0
    ),
    Activity(
        """
        OK, everything seems to be working ok, so let's investigate the onset of CHAOS! We will
        slowly increase the value of the specific growth-rate r to discover how this affects the
        developmental trajectory of the wasp population. Use the initial value x0=0.3 for all of
        the folloiwng experiments until I tell you otherwise...
        
        Just to make our language clear: a LIMIT POINT of the wasp population's motion is any
        value of the population that stays the same from one generation to the next:
            L(r)(x) == x.
        
        What was the limit point of the trajectory L(0.9)?
        """,
        "",
        x -> x==0
    ),
    Activity(
        """
        What is the approximate value of the limit point of the trajectory L(1.1)?
        """,
        "",
        x -> 0.07<x<0.1
    ),
    Activity(
        """
        What is the EXACT value of the limit point of the trajectory L(1.5)?
        """,
        "You can work it out for yourself by solving the equation L(r)(x) == x, or: r x (1-x) == x",
        x -> x == 1//3
    ),
    Activity(
        """
        Use the technique from the hint in the previous activity to calculate the limit point of
        the trajectory L(2), then check this value using your simulator:
        """,
        "",
        x -> x==0.5
    ),
    Activity(
        """
        Now investigate the trajectory L(2.1). In which direction does the population change from
        x[6] to x[7]: positive (+) or negative (-)?
        """,
        "",
        x -> (x == -)
    ),
    Activity(
        """
        This is interesting 00! Up to now, the wasps' trajectory has been monotone: the population
        has only either shrunk or grown. But now it grows above the fixpoint value, then drops back
        down again! Let's investigate this further: find the limit point of the trajectory L(2.5)
        both by calculating and by simulating:
        """,
        "",
        x -> x==0.6
    ),
    Activity(
        """
        Notice that now we have an oscillating motion that dies away as x comes to rest at the
        limit point. Try out various values of r between 2.5 and 2.95. Does the oscillation
        still die away?
        """,
        "",
        x -> occursin("y",lowercase(x))
    ),
    Activity(
        """
        Now find the limiting motion of the population for L(3). Does the oscillation die away?
        """,
        "",
        x -> occursin("n",lowercase(x))
    ),
    Activity(
        """
        It now no longer makes sense to speak of a limit VALUE, since the trajectory oscillates
        forever around the value 2/3. Instead, we speak of a limit CYCLE: the motion L(3) displays
        a limit cycle around the value 2/3. "cycle" means the value oscillates forever, and
        "limit" means that it will converge to this cycle, no matter where we start the motion.
        Check this for yourself by changing the value of x0. Does the motion always converge on
        a cycle around 2/3?
        """,
        "",
        x -> occursin("y",lowercase(x))
    ),
    Activity(
        """
        Now comes some terminilogy that will seem strange to you at first, but which will make
        sense as we proceed. Notice that within each period of the limit cycle, the motion jumps up
        one step, then back down one step to the original value: the period of the limit cycle
        contains a single complete oscillation. We therefore call the motion L(3) a
            "Period-1 limit-cycle"
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Let's explore further. Look at the limit-cycle of the motion L(3.2) (You may want to extend
        the duration to 50). How many oscillations are in each period of this limit cycle?
        """,
        "The number of periods should not (yet) have changed",
        x -> x==1
    ),
    Activity(
        """
        What is the period-length of the limit-cycle of the motion L(3.45)? That is, how many
        complete oscillations does the population perform before the motion repeats itself?
        """,
        "Count very carefully: This should be a period-2 limit-cycle",
        x -> x==2
    ),
    Activity(
        """
        What is the period-length of the limit-cycle of the motion L(3.55)? By now, things will
        be moving quite quickly and the wasp population will need a while to stabilise towards the
        limit-cycle. You may like to save time by using a line like this:
            lines(nestlist(L(3.55),0.5,5000)[end-40:end])
        """,
        "Look very carefully!",
        x -> x==4
    ),
    Activity(
        """
        What is the period-length of the limit-cycle of the motion L(3.567)?
        """,
        "Count ve-ery carefully - remembering to inspect the smaller oscillations as well!",
        x -> x==8
    ),
    Activity(
        """
        What is the period-length of the limit-cycle of the motion L(3.5695)? You will find this
        one very difficult to count, but it is actually a period-16 limit-cycle. If you can't
        distinguish the oscillations, don't worry - just go on to the next activity.
        """,
        "",
        x -> x==16
    ),
    Activity(
        """
        We have seen that as r increases, Period-Doubling occurs. That is, the period-length
        doubles at each step-change in r, so the motion takes longer and longer before it repeats.
        Now check out the motion Λ(3.7). How long does it take before this motion repeats itself?
        Or in other words: What is the period-length of this limit-cycle?
        """,
        "Find out how to write \"Infinity\" in julia :)",
        x -> x==Inf
    ),
    Activity(
        """
        We have come a long way. We have learned is that some naturally occurring systems can
        exhibit a type of motion in which they require an infinite amount of time to repeat. This
        means we can never predict this motion in advance, but must always perform ALL of the
        calculation steps that lead up to it. We call such motions CHAOTIC.

        Notice that Chaos has nothing to do with randomness. We can always calculate the population
        of Vespula Island for any year, but ONLY by actually simulating it. There are apparently
        things that mathematics cannot predict in advance, but must calculate step by step.

        Actually, the situation is even worse than this. Use the following command to inspect the
        behaviour of L(3.7) for the different starting conditions x0 ∈ [0.5,0.50001,4.99999]
            lines(nestlist(L(3.7),0.5,5000)[end-40:end])

        Are these three graphs at all similar to each other?
        """,
        "",
        x -> occursin("n",lowercase(x))
    ),
    Activity(
        """
        As you see, chaotic motion means that even very tiny changes in the initial conditions
        of a chaotic system lead to completely different behaviour. So even if we measured the
        current wasp population, we could never be sure that we had done it sufficiently accurately
        to be ABSOLUTELY sure that we are accurately predicting the development of the system!

        So. What has all this to do with your project? Henri Poincaré was the first to notice
        deterministic chaos in 1908. He showed that the gravitational motion of three orbiting
        bodies cannot be solved exactly. Weather, dripping taps and driven pendula have a similar
        problem: We cannot predict the story of their future motion without simulation, which as
        you know is never precise! As an introduction to chaos in the three-body problem, please
        view the following video-clip now, and then proceed to the next activity:
            https://www.youtube.com/watch?v=LwkvO3t1b30
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now we will see how to build up a complex scientific program starting from a set of
        requirements. Use VSC to take a look at version 0 of my NBodies module:
            setup("NBodies")
            include("Development/NBodies/NBodies0.jl")

        The aim of the NBodies module is to simulate Poincarés chaotic 3-body motion. If you look
        at the unittest() function, you will see that my basic use-case creates an instance of the
        type NBody, pushes two bodies into this model, then requests a simulation and graphical
        animation of the model.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice that simulate() and animate() are at present just dummy functions that do nothing
        other than report back values. This use of dummy functions is EXTREMELY important in
        software development - it enables me to start designing my module from the external
        requirements, then to develop step-by-step the deeper mechanisms of the software. First we
        set up the use-case, then we slowly fill in the program details, making sure that each
        stage of development is fully correct and robust before we go on to the next.
            
        Study version 0 of NBodies and tell me a line number where the code defines that this is a
        TWO-dimensional simulation.
        """,
        "Where does the code first specifiy that the position is a 2-dimensional vector?",
        x -> x in [109,110]
    ),
    Activity(
        """
        Software development is always driven by the needs of its CLIENT program - in our case,
        this is the function NBodies.unittest(). When you design unittest() in your own projects,
        think carefully about what kinds of behaviour you as a user require of the datatype NBody,
        then incorporate that requirement into unittest(), then start implementing that
        functionality in your module design. For example ...

        The client program unittest() in version 1 of NBodies (NBodies1.jl) is identical with the
        client program of version 0. The only things we have changed in the file are to generate
        dummy (sin/cos) trajectory data in simulate() and then display this data in animate(). This
        enables us to develop the graphical interface of the project first, which will later help
        us to visualise the result of our changes to the project. All we are doing in version 1 is
        to set up the link between the unittest() use-case function and GLMakie.

        Look at the dummy code in simulate() and animate() in version 1. What shape of curve do
        you expect to be generated by the dummy data in simulate()?
        """,
        "If you have difficulty, run the program, then explain to a friend how it generates the output",
        x -> occursin("llips",lowercase(x)) || occursin("oval",lowercase(x)) || occursin("circle",lowercase(x))
    ),
    Activity(
        """
        Now look at version 2 of NBodies. Here we start to implement Euler's method for integrating
        differential equations by introducing a very simple force acting on the masses, and
        then visualising the path of the integrated motion. Compile and run NBodies2.jl to see
        the results.

        In which line of NBodies2.jl do we define the force acting on the bodies?
        """,
        "Try running the program, then explain to a partner how it generates the output curve",
        x -> x == 105
    ),
    Activity(
        """
        In NBodies3.jl, we develop animation code for the simplified motion that we defined in
        version 2. Try out a few experiments at the julia prompt to make sure you fully understand
        how we are using the julia `map` command in lines l06, 107, 120 and 121.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In NBodies4.jl, we introduce the full interactional dynamics of the two bodies in the
        method simulate(). You need to make sure you understand the matrix programming techniques
        we are using - they are not easy! The core of the implementation is the matrix-based code
        in the method forceOnMasses(), which calculates for each body the (vector) sum of all
        gravitational forces caused by the other bodies. You will need to analyse this code and use
        Help and internet search to look up EVERYTHING you do not yet understand in
        forceOnMasses(). In the coming few activities we will learn how to do this ...

        First remember: Matrices work very naturally in julia, so if a=[1 2;3 5] and b=[2 3;4 5],
        then a*b, b*a and a.*b will all deliver very different results. Test this idea now at the
        julia prompt, then tell me the value of a*b-a.*b .
        """,
        "",
        x -> x == [8 7;14 9]
    ),
    Activity(
        """
        The secret of matrix programming is this: Whenever you think you need a for-loop to
        manipulate some values, try instead building them together into a matrix that does the job
        for you. As an example of how to do this, try out the following activity:
            
        Define and test an anonymous version of the factorial function that requires no
        recursion or iteration, but instead uses the prod() function.
        """,
        "",
        x -> occursin("->prod(1:",replace(x," "=>""))
    ),
    Activity(
        """
        In the method force_on_masses(), I make use of matrix programming to boost the performance
        of calculating all the forces between the different bodies. Remember that between N bodies
        there will be N^2 interactions. To reduce this N^2 complexity, in lines 104-5 I replace
        nested for-loops by setting up the matrix of relative positions x[i]-x[j] between all pairs
        of bodies i and j. Notice that this construction starts in line 103 with the input argument
        `locations`, which is a Vector containing all Vector locations of the N bodies.
        
        Let's start investigating how this calculation works by defining a simple, toy example of
        `locations` in the julia REPL - something like this:
            locations = [[1,2],[3,4]]

        Next, in the REPL, execute each of the following codelines 103 to 105 step by step. After
        each step, look carefully at the result, and discuss it with your partners:
            body_locations = repeat(locations,1,length(locations))
            transposed = permutedims(body_locations)
            rel_pos = body_locations - transposed

        When you have finished, work out in your head the result of `repeat([1,2],2,3)`.
        """,
        "",
        x -> x==[1 1 1;2 2 2;1 1 1;2 2 2]
    ),
    Activity(
        """
        Now we understand approximately what is being done in the force_on_masses() method, we will
        use the VSC debugger to investigate in more detail how this method uses `rel_pos` to
        calculate the gravitational forces acting between different bodies in the system. First,
        set a breakpoint at line 103 of NBodies4.jl by clicking just to the left of the line number
        103 in VSC, so that a small red dot appears.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Next, insert within the global scope of the NBodies module - just before the final `end`
        in line 164 - the call:
            unittest()

        This ensures that when NBodies is loaded, the method unittest() is automatically called.
        You will remove this line again when we've finished debugging, but for the moment it is
        useful for debugging. Start the debugger by positioning your text cursor within NBodies5.jl
        and then pressing the "Run and Debug" item on the left of the VSC screen. This runs the
        code in VSC until it comes to your breakpoint in line 103.

        Now use the VSC debugger to step through force_on_masses(), studying the contents of the
        local variables as the method executes. For example, which local variable stores all the
        r^(-3) factors used to calculate the gravitational forces between bodies?
        """,
        "",
        x -> occursin("inverse_cube",lowercase(x))
    ),
    Activity(
        """
        When you have finished using the debugger, close the execution window, click again on the
        Explorer icon on the left of the VSC screen, and remove the module-level line that we
        inserted to call unittest() for debugging. Save your corrected version of NBodies4.jl.

        Now we have understood how the code in NBodies4.jl works, notice that when we run it, we
        have a runtime problem. Because of inaccuracies of the simulator, the orbits of the two
        bodies are not closed ellipses, but instead the bodies spiral outwards. The next version,
        NBodies5.jl, will solve this problem by replacing Euler integration by Runge-Kutta-2
        integration in simulate().

        Study now the method runge_kutta_2() in NBodies5.jl to see how the integration is
        performed by using two Euler steps. Run unittest() to see that for yourself that the orbits
        are now much more precise.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Finally, check out the new use-case method demo() in NBodies5.jl, which tests our simulator
        using THREE bodies. Notice how it does not take long for the system to throw out the small
        planet and so reduce itself to a binary star system.

        Congratulate yourself on completing this lab by modifying NBodies.demo() to create many
        bodies (I've tried it with up to 30), all concentrated within a unit square around the
        spatial origin, and all with very low speed and random masses. Convince yourself that it is
        EXTREMELY unlikely that there could ever exist a system in the universe that contains more
        than 2 stars orbiting each other.
        """,
        "",
        x -> true
    ),
]