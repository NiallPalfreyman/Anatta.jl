#========================================================================================#
#	Laboratory 200
#
# Welcome to course 200: An Introduction to Physics!
#
# Author: Niall Palfreyman, 24/04/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 200:
            System dynamics - Dynamical stories can fill logical gaps
        
        In Subject 100, we learned about Kurt Gödel's Incompleteness Theorems. These theorems form
        the foundation of 21st-century mathematics; they show that EVERY structural system is
        necessarily incomplete. In other words, whenever we construct some structure, we build it
        by using structural relations to link together a countable number of concepts. This number
        may be infinite, but it is necessarily only COUNTABLY infinite. This makes it impossible
        for our structure to describe any situations that possess an UNcountable number of states.

        Examples of such uncountable states are irrational or transcendental numbers such as √2 or
        π, when a tap will next drip, living processes or even simply timing the boiling of an egg!
        All these uncountable systems have an interesting aspect in common: they all involve the
        unfolding over time of a dynamical Story. And stories are what Subject 200 is all about! :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        What do I mean by the unfolding of a dynamical story? Well, suppose you and your partner
        both walk at precisely the same speed, but whereas your partner walks around the edge of a
        perfectly circular park, you take a straight path directly through the middle of the park.
        What is the ratio of their walking time to yours?
        """,
        "They walk round the circumference of the circle; you walk straight along its diameter",
        x -> abs(x-pi/2) < 0.1
    ),
    Activity(
        """
        As you see, in this particular case, the transcendental number π/2 arises by comparing what
        happens in a time-developing story of two participants. All non-countable phenomena arise in
        this dynamical way, for example: How do we time the boiling of an egg? We allow the elastic
        or electric dynamical processes of a clock's spring or capacitor to follow their own story
        until the clock's hands point to specific numbers on its face. In general:
        -   Structural Procedures calculate accurate answers to Countable questions;
        -   Narrative (i.e., story) Processes develop accurate outcomes of Non-Countable situations.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        This seems like very good news indeed: narrative processes can fill in the logical gaps
        left by logical structures. This is, indeed, exactly how science works - we use physical
        experiments to fill in the gaps in our theories. However, we must also remember that in
        order to discover the outcome of a narrative process, we need to MEASURE something, which
        turns a non-countable value into a countable measurement. So perhaps it would be more
        accurate to express the advantages of narrative processes like this:
        -   By modelling narrative processes structurally (i.e., on a computer), we can calculate
            ARBITRARILY accurate answers to non-countable questions.
            
        We call this way of answering questions SIMULATION.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Let's see how simulation works in a very simple case. Imagine Leicester City Council has
        just counted the number of rabbits in Watermead Country Park as being 1000. The council
        wants to know how this rabbit population will impact their city development plans over the
        coming 8 years, and commissions us to forecast how it will develop over this period.
        
        Now, the development of any living population depends on many factors such as fertility,
        mortality, predation, migration and so on. To simplify our model, we will reduce all these
        factors down to two: births and (natural) deaths.

        To explain this model to the City Council, we draw the Stock-and-Flow diagram shown in
        Script200 in your Scripts directory. Take a look at this diagram now, and reply() me the
        name of the Stock shown as a rectangle in the middle of the diagram:
        """,
        "The rectangle contains two names: the mathematical and the text name. Either will do :)",
        x -> x == "u" || x == "Rabbits"
    ),
    Activity(
        """
        The rectangular stocks in this diagram represent the State Variables u[1], u[2], u[3], ...
        of the system we are modelling. In our case, we have only one state variable, u, so I
        have left away the vector indices.

        Think of a stock as a tank which water flows into and out of. The flow "births" represents
        water flowing into the tank, and the flow "deaths" represents water flowing out of the
        tank. The greater the flow, the faster it changes the level of water in the tank.

        We say that flows "cause" changes in the level of stocks. This means that a flow does not
        determine the actual value of the stock, but instead, it determines the CHANGE in value of
        the stock. What is the mathematical name for the flow "births"?
        """,
        "",
        x -> x=='b' || x=="b"
    ),
    Activity(
        """
        OK, so flows cause changes in stocks. In fact, quite generally:
            EVERY flow is a term in the differential equations that describe the system's dynamics!

        If you look lower at the single dynamical flow equation for the Rabbits system, you can
        see that the rate of change of u (du/dt) is given by a positive term for the inflow births
        and a negative term for the outflow deaths. We call this the Input-Output Principle:
            du/dt = Sum of all inflows - (Sum of all outflows)

        In other words, the rate of change of a state variable u is given by the sum of the various
        positive and negative causal influences on u. It is often useful to implement the
        structural relations specifying these causal flow values as additonal methods. For example,
        we might implement a method deaths() to calculate the total death-rate of the rabbits. This
        method would need to divide the current number of rabbits (u) by which parameter?
        """,
        "How long does each rabbit live?",
        x -> x=='L' || x=="L"
    ),
    Activity(
        """
        We have seen that to define a dynamical model, we need stocks, flows and methods, but in
        the end, our calculations must depend upon actual measured values that we call PARAMETERS.
        The lifespan L of a typical rabbit is fairly easy: rabbits live about 4 years, which is
        48 months. But what about the specific, or per-capita, birthrate (r) of rabbits?
        
        To calculate this, we need to investigate a little deeper. The specific birthrate is the
        number of children that a typical rabbit produces in a typical month. On average, a single
        mating pair of rabbits will produce during their entire life about 4 kits (or babies) that
        actually survive in the wild. How many kits is this per rabbit per month?
        """,
        "Remember that we need the number of kits per individual rabbit",
        x -> abs(x-0.0417) < 0.001
    ),
    Activity(
        """
        We have now collected all the information we need to build and run a dynamical model of
        the Watermead Country Park rabbit population. Before we build our model, it is VERY
        important that we first construct a Reference Mode for the model. That is: How SHOULD our
        model behave? Are there special circumstances where we already know what kind of behaviour
        to expect from the model? If so, we can use this knowledge to verify our model's accuracy.

        For example: What kind of BOT curve would we expect from the model if there were no births,
        but only deaths?
        """,
        "What is the mathematical term for this behaviour?",
        x -> occursin("exp",lowercase(x)) && occursin("decay",lowercase(x))
    ),
    Activity(
        """
        Here is another easy reference mode: What kind of BOT curve would we expect from our model
        if there were no deaths, but only births?
        """,
        "What is the mathematical term for this behaviour?",
        x -> occursin("exp",lowercase(x)) && occursin("grow",lowercase(x))
    ),
    Activity(
        """
        Now we can start building our dynamical model of the Watermead Country Park rabbit
        population. We will then use these two reference modes of exponential growth and decay to
        test whether the model is behaving as it should.
        
        I have set up a template for the Rabbits model in the file SD/Rabbits.jl. To work with this
        file, you first need to setup() the SD folder in your Anatta home Development directory.

        When you have done this, study carefully the structure of the Rabbits module. Notice that
        it contains a list of initial values of the stocks. Of course, in our simple model we have
        only one stock - the number of rabbits - but in general, our models may contain many stocks
        that together form a vector u of their individual values. Notice as well that we define a
        dynamical rule flow!() that our model will use to update the values of this state vector u.

        Notice in particular, that the dynamical rule must ALWAYS return which value?
        """,
        "What value does my dynamical rule return?",
        x -> x===nothing
    ),
    Activity(
        """
        Now fill in all values that we have defined for our dynamical model, and then reply() me
        the number of rabbits in Watermead Country Park after 8 years:
        """,
        "",
        x -> 7000 < x < 8000
    ),
    Activity(
        """
        OK, now this number seems a little large for Watermead Park to sustain. We ought to check
        our model using the reference modes. Test the decay reference mode now. That is: does the
        population fall to zero if we set births to zero?
        """,
        "You may need to increase the duration of the simulation to check this",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Is this decay exponential? You can test this by plotting an additional line in the same
        axes, representing the quanity log(u). If the decay of u is exponential, then the graph of
        log(u) should have which shape?
        """,
        "What is log(exp(-t))?",
        x -> occursin("straight",lowercase(x))
    ),
    Activity(
        """
        The behaviour of our model seems to match our expectations, but with this very simple
        exponential model, we have the advantage that we can test the numerical output of the
        model against the exact solution shown at the end of Script200. Do this now, and find a way
        of correcting any discrepancies you may find between the exact and the numerical solutions.
        """,
        "What can we do to make DyanimicalSystem's numerical integration more accurate?",
        x -> true
    ),
]