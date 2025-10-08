#========================================================================================#
#	Laboratory 309: Suboptimisation
#
# Author: Niall Palfreyman, March 2025.
#========================================================================================#
[	
    Activity(
        """
        Hi! Welcome to Anatta Subject 309: Suboptimisation.

        We have seen that agent-based systems are capable of making choices by acting collectively.
        Many important problems in biology and in industry involve making choices that are
        somehow useful: In which direction should I go hunting for food this morning? Which is the
        quickest route from Andover to Beirut? Which stocks should I sell today?

        It is common in computing to formulate such questions as Minimisation problems: Which
        direction minimises my chances of returning home empty-handed? Which route minimises my
        travel time? Which stocks minimise my risk of losing money? The advantage of minimisation
        problems is that they can be solved by a simple algorithm: Gradient Descent. The idea is
        that we want to minimise the value of some OBJECTIVE function like the probability that I
        find no food, or the time it takes to travel to Beirut, or the amount of money I lose on
        stocks. We can do this by taking a small step in the direction of the negative gradient of
        the objective function. In this lab, we investigate how to use a swarm of Scouts to search
        for this minimum value, and along the way, we also encounter a major difficulty of
        gradient descent: Suboptimisation.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The Suboptimisation model is a simple model of a swarm of Scouts that fly around the world
        seeking to minimise the value of an objective function. The objective function is either
        the easy problem of finding the lowest point of three valleys, or a more difficult function
        chosen from the famous DeJong test suite of objective functions.

        Starting from a random location, the Scouts take a small step in the direction of a nearby
        location that has a smaller objective value than at the Scout's own location. Run the
        Suboptimisation model with the parameter "difficult" set to FALSE; this works with the
        valleys() function. I have set the speed of the agents to very slow (0.1) so that you can
        clearly observe their motion. In which direction do Scouts move in order to find the minima
        of the valleys() objective function?
        """,
        "In which direction would you walk to find the lowest point of a valley in the mountains?",
        x -> occursin("down",lowercase(x))
    ),
    Activity(
        """
        This kind of search is called "gradient descent", because the Scouts follow the negative
        gradient of the objective function. Find the function that calculates this gradient and
        tell me what value of stepsize I am using to calculate the gradient:
        """,
        "The symbol for stepsize is h",
        x -> x==1.0
    ),
    Activity(
        """
        You can see that the search is quite slow at points where the gradient of the objective
        function is almost zero. Why? What field of the Scouts is determined by this gradient?
        """,
        "",
        x -> x=="vel"
    ),
    Activity(
        """
        You can accelerate this search by normalising the gradient vector. This means that the
        Scouts take a step of unit length in the direction of the gradient. Modify the code of the
        appropriate Scout method to do this, then test your code. Which useful function from the
        AgentTools library can you use to calculate the length of a vector?
        """,
        "Normalise a vector by dividing it by its own length",
        x -> occursin("norm",lowercase(x))
    ),
    Activity(
        """
        Before moving on, let's look at what exactly the methods valleys() and gradient() do. As
        you see in the graphical display, the valleys() function is a simple function with three
        minima, and in particular, a global minimum at the coordinates (40,60). Also, note that the
        extent of our Suboptimisation world is (80,80). Now look at the valleys() function ...

        You can see that in the first two lines, valleys() uses the repeat() and range() functions
        to create two matrices xs and ys. What is the size of these matrices?
        """,
        "You will need to look up the range(), repeat() and ' operator in the Julia documentation",
        x -> x==(80,80) || occursin("80",lowercase(x))
    ),
    Activity(
        """
        To see what the matrices xs and ys look like, let's create a small toy example. In the
        Julia REPL, set the extent of the world to (5,3), then copy the following lines from the
        valleys() method, substituting new (start,stop) values (-1,1) and (10,12) into the range()
        function:
            extent = (5,3)
            xs = repeat( range(-1,1,extent[1]), 1, extent[2])
            ys = repeat( range(10,12,extent[2])', extent[1], 1)

        What is the size of the matrices xs and ys?
        """,
        "",
        x -> x == (5,3) || occursin('5',lowercase(x)) && occursin('3',lowercase(x))
    ),
    Activity(
        """
        As always in functional programming, we can read the definition of xs from the inside out:
            range(-1,1,extent[1])      -> [-1.0;-0.5;0.0;0.5;1.0]
            repeat( ans, 1, extent[2]) -> [-1.0 -1.0 -1.0; -0.5 -0.5 -0.5; ...; 1.0 1.0 1.0]

        and on the other hand:
            range(10,12,extent[2])     -> [10.0;11.0;12.0]
            ans'                       -> [10.0 11.0 12.0]
            repeat( ans, extent[1], 1) -> [10.0 11.0 12.0; 10.0 11.0 12.0; ...; 10.0 11.0 12.0]

        Test these lines for yourself in the REPL. What is the value of the element in the 3rd row
        and 2nd column of the matrix ys?
        """,
        "",
        x -> x==11.0
    ),
    Activity(
        """
        So we see that valleys() two matrices xs and ys; xs contains all x-coordinates of the world
        arranged down the columns, and ys contains all y-coordinates arranged across the rows. Now
        let's find the value of our global minimum at (40,60). Use the REPL to calculate the values
        the corresponding elements of xs and ys at this point and reply() me these values as a tuple:
        """,
        "",
        x -> x isa Tuple && -0.037<x[1]<-0.038 && 1.48<x[2]<1.49
    ),
    Activity(
        """
        The (x,y) coordinates of the global minimum are approximately (-0.03797, 1.48101). What is
        the value of the valleys() function at this point? To calculate this, you can copy the
        first argument of the map() function in the valleys() method and substitute the values of
        x and y into the function. What is the value of the valleys() function at the global
        minimum?
        """,
        "",
        x -> abs(x+7.93623)<0.1
    ),
    Activity(
        """
        You can check your calculation of the previous activity by running the Suboptimisation
        model with add_colorbar=true. Does your value match the graphical representation of the
        global minimum?
        """,
        "If it doesn't, you can either recheck your calculation or move on to the next activity",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Now we understand the valleys() function, let's move on to the gradient() method. If you
        run the Suboptimisation model with valleys(), you can make three interesting observations:
        -   The Scouts move Down the slope of the valleys() function;
        -   They move faster where the slope is steeper;
        -   They move in curves, rather than straight lines.

        Regarding the first observation, if you look at the agent_step!() method, you see that it
        sets vel equal to the Negative of the valleys() gradient, so presumably the gradient()
        method calculates a vector that points Up the slope.

        Regarding the second observation, the gradient() method must calculate a vector that is
        longer whenever the slope is steeper.
        
        Finally, what is your opinion regarding the third observation? The Scouts move in curves
        because the gradient() method calculates a vector that contantly changes as shape of the
        valleys() changes. So, do you think the gradient of a field points always in the
        direction in which that field changes Most or Least rapidly?
        """,
        "",
        x -> occursin("most",lowercase(x))
    ),
    Activity(
        """
        OK, so at any point x in a field F, the gradient ∇F(x) of F at that point x is a vector
        pointing in the direction in which F changes most rapidly; also, the length of the gradient
        vector is equal to that rate of change of F. This is why the Scouts move in curves: they
        follow the direction of the gradient vector, which changes as they move.

        So how do we calculate the gradient vector? If you look at the gradient() method, you see
        it calculates the field F at four points neighbouring the current point (x,y):
            nbhdfield = [F([(x-h,y), F(x+h,y), F(x,y-h), F(x,y+h)]

        It then calculates the gradient as the difference between neighbouring F values in the x
        and y directions, divided by 2h:
            ∂F/∂x ≈ (F(x+h,y) - F(x-h,y)) / 2h
            ∂F/∂y ≈ (F(x,y+h) - F(x,y-h)) / 2h
        """,
        "",
        x -> true
    ),
    Activity(
        """
        This calculation method is called the Finite Difference method. It is a simple and robust
        way of calculating an approximation to the gradient of a field F at a point (x,y). What we
        have learned from this is the definition of the gradient ∇F of a field F at a point x:
            ∇F(x) ≡ [∂F/∂x, ∂F/∂y] ≈ [(F(x+h,y) - F(x-h,y)) / 2h, (F(x,y+h) - F(x,y-h)) / 2h]
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now let's turn to the issue of suboptimisation. Run the Suboptimisation model again,
        and notice that the Scouts stream downhill and do a great job as a swarm of finding all of
        the valleys. However, they cannot do any more than that:
            They cannot find out which is the Deepest valley!
        
        In general the Suboptimisation problem is that Scouts are only capable of locating Local
        optima - called Suboptima - but have great difficulty finding out which of these is the
        Global Optimum.

        Now, this might not seem like a great problem to you: Surely the Scouts have already
        narrowed down the search sufficiently for us to simply check through the three valleys and
        find the lowest. But now switch the parameter "difficult" to TRUE and let the Scouts
        search for a minimum value. The problem now is that the De Jong 2 function contains so
        many local ?____________? that the Scouts find too many suboptimal solutions.
        """,
        "",
        x -> any(occursin.(["minim","valley","optim"],lowercase(x)))
    ),
    Activity(
        """
        What you have just seen is THE biggest problem of computing today: We can easily program a
        computer to find optimal solutions, but how do we find the GLOBAL optimum? Typically, the
        problem of finding global optima is NP-complete. That is, solving this problem will take
        exponential amounts of time and resources. We will study this issue closer in the next
        few labs.

        Preparatory question: What mechanism does evolution use to get out of suboptimal solutions
        to the problem of species survival?
        """,
        "",
        x -> occursin("mutat",lowercase(x))
    ),
]