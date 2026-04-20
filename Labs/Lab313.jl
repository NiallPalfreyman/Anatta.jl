#========================================================================================#
#	Laboratory 313: Niche-construction and ant algorithms
#
# Author: Niall Palfreyman, March 2025.
#========================================================================================#
let
println( "Just loading the graphics package ...")
using CairoMakie
[
    Activity(
        """
        Hi - Welcome to Anatta Subject 313: How do we specify objectives to focus problem-solving?

        Our simulation SelectiveSearch in the previous lab was really NOT a multi-agent simulation.
        Rather, it was a single-agent GA that used multiple candidate solutions to solve a problem.
        In this lab, we will look at how to adapt a GA into a multi-agent simulation, then we will
        use this simulation to explore how objective functions arise, not from individual agents,
        but rather from their interactions with each other and with their environment.

        Our multi-agent adaptation of SelectiveSearch is called SelectiveExploration. This name
        reflects the fact that the agents in this simulation will not only swap genomes, but will
        also explore the world through different ways of interacting with it. Run the simulation
        and just notice the differences from SelectiveSearch. In particular, compare the number
        of generations each simulation takes to evolve the target string, and the length of time
        the two simulations take to do so. How do you think these differences occur?
        """
    ),
    Activity(
        """
        To be perfectly honest, I'm not entirely sure how precisely these differences arise, but we
        can guess, and we can investigate the programs in more detail. First, as a rough guess, I
        would say that both simulations require about the same amount of time to evolve the target
        string, but that SelectiveExploration does so in about 10 times as many generations as
        SelectiveSearch. Hence, each generation of SelectiveExploration is doing fewer computer
        operations. So let's compare the two methods that do most of the work:
            SelectiveSearch.model_step!() and SelectiveExploration.reproduce!().

        Over approximately how many agents does each of these methods loop?
        """,
        x -> 470 <= x <= 510
    ),
    Activity(
        """
        That's right: each method loops over the entire population of agents, which is about 500.
        Study the code of SelectiveSearch.model_step!() and reply me: What is the most time-costly
        operation performed whenever SelectiveSearch produces a new baby?
        """,
        x -> x==Main.deepcopy || occursin("deepcopy",x)
    ),
    Activity(
        """
        So the main time-costly operation in SelectiveSearch is the memory allocation of a new
        genome for each new baby. Now study the code of SelectiveExploration.reproduce!(). Instead
        of deepcopy(), this method uses vcat(), which doesn't allocate new memory, but rather
        creates a new view of the existing parent genomes. So which operation in reproduce!() is
        responsible for the memory-allocation time-cost of producing each new baby?
        """,
        x -> x==Main.SelectiveExploration.add_agent! || occursin("add_agent!",x)
    ),
    Activity(
        """
        Now, I can well imagine that the Agents package is performing memory allocation far more
        efficiently than my deepcopy() code in SelectiveSearch; however, I also suspect that there
        is more to this story than just the memory allocation. The way in which agents interact
        with their environment and with each other is likely to play a significant role in shaping
        the overall computational efficiency of the system. Each of the 500 agents in
        SelectiveExploration executes its own reproduce!() method, but only allocates a new baby
        under certain conditions. How many different conditions might abort the reproduction of a
        new baby in SelectiveExploration.reproduce!()?
        """,
        "Count how many if-conditions in reproduce!() might prevent reproduction of a new baby",
        x -> x==4
    ),
    Activity(
        """
        Complexity and performance considerations are often a useful way to study code: we now
        have a better understanding of how SelectiveExploration makes use of interactions between
        individual agents. Our next task is to understand how selection occurs through exploration.
        In SelectiveSearch, we used roulette selection to select parents for reproduction, but now
        we need to base this selection on individual agent interactions.

        The method SelectiveExploration.agent_step!() determines the behaviour of each agent at
        each time step. What is the first thing that each agent does on each step?
        """,
        "What is the first method invocation in agent_step!()?",
        x -> x==Main.SelectiveExploration.walk! || occursin("walk",x)
    ),
    Activity(
        """
        That's right: on each step, the agent takes a step in a random direction, losing energy
        as it does so. This randomises the interactions between agents, replacing the roulette
        wheel of SelectiveSearch, and we shall see that the loss of energy plays an important role
        in shaping the selection of agents for reproduction.
        
        What is the second thing that each agent does on each step?
        """,
        "",
        x -> x==Main.SelectiveExploration.explore! || occursin("explore",x)
    ),
    Activity(
        """
        The second thing each agent does is to explore its environment, looking for opportunities
        to gain energy. If it can gain energy in some way, it will live longer, and so be able to
        reproduce more often, thus passing on more of its genome to the next generation. In our
        case in SelectiveExploration, agents gain energy by interacting with a random nearby agent
        and comparing their objective values. If the agent has a better (i.e., lower) objective
        value than its neighbour, it gains a small package of energy, thus extending its lifespan.

        What is the numerical value of this energy package?
        """,
        "You will need to look at the model initialisation code in selective_exploration()",
        x -> x==0.9
    ),
    Activity(
        """
        As you can see in agent_step!(), agents whose energy has fallen below zero are removed, and
        only then do the remaining agents have an opportunity to reproduce. In this way, we implemnt
        the process of selection: I can have more babies if my objective value is lower than some
        random agent that I meet along the way.

        It is important to realise that in general, this objective value migh arise in many different
        ways. It might come from cooperation or competition with a neighbour, or because the agent
        manipulates the environment in some way. In SelectiveExploration.explore!(), the objective
        value is calculated from the dissonance between the agent's genome and the target quotation
        string. We already know basically how this is calculated in both its uni- and bi-modal forms,
        but explore!() also modifies the dissonance value in an additional way using the method
        spiky(). Whereabouts is the definition of this method?
        """,
        "The method definition is Not in the file SelectiveExploration.jl",
        x -> x==Main.SelectiveExploration.AgentTools || occursin("AgentTools",x)
    ),
    Activity(
        """
        Why have I used spiky() the objective calculation? Remember that we want to test the
        effectiveness of our evolutionary algorithm against the results of Hinton and Nowlan, who
        used a very "spiky" objective function that returns 0 for all pairs of strings except when
        the dissonance between them is zero, when the return value is 1. reply() me the result of
        the following call to spiky():
            spiky.(0:0.25:1,0.5)
        """,
        x -> x==[0.0,0.0,0.0,0.25,1.0]
    ),
    Activity(
        """
        Compile AgentTools.jl in VSC or in a Julia console. Define the range
            x = 0:0.01:1

        Now use a plotting package such as CairoMakie to plot the following curve:
            lines(x,spiky.(x,s))

        for values of s rising slowly from 0 to 1. What happens to the graph as s rises? Does the
        curve become steeper, flatter, or more step-like?
        """,
        x -> occursin("step",x)
    ),
    Activity(
        """
        You have discovered that, as spikiness rises from 0 to 1, spiky() transforms any function
        into a step-function whose return value is 0 for all values of x lower than the spikiness.
        In fact, spiky transforms any objective function into the more difficult kind of objective
        function used by Hinton and Nowlan in their experiment. SelectiveExploration is able to
        find the target quotation string within about 3e4 generations because our objective
        function gets gradually smaller as our candidate string approaches the target string,
        giving reliable feedback on how far away from the target we are.

        But objectives are not always so convenient. The 'difficulty' slider in SelectiveExploration
        is simply the spikiness that we apply to the dissonance in order to calculate the objective.
        Gradually increase the value of difficulty from 0 to 1 and find the difficulty value at
        which the agents are no longer able to discover the target string. What is this value?
        """,
        "I only need an approximate value",
        x -> 0.5<x<0.6
    ),
    Activity(
        """
        We have now discovered two ways in which evolutionary search can fail. In the previous lab,
        we found that selective search can get lost in Suboptima - local, secondary optima that
        distract the search from deeper, global optima. Now, in this lab, we find that as the
        objective function gets more spiky, it delivers less and less information about the fitness
        of the candidate strings that are far from the global optimum, until at a spikiness of 0.7,
        it becomes basically impossible to find the target string.

        We have created agents that collectively search for an optimum of some objective function,
        but this objective becomes very difficult to achieve as soon as it is very spiky and/or
        multimodal. We call such difficult objective functions "rugged", because their graph looks
        like the accompanying graphic: very jagged and rocky mountain landscapes, with many steep
        peaks and valleys. Suppose you went walking in the mountain range shown here. Then imagine
        how difficult it would be if I asked you to find the deepest valley in this mountain range
        in a mist that only allowed you to see about 10 metres in front of your face!
        """,
        :(lines(rand(30))),
    ),
    Activity(
        """
        This is precisely the problem of evolution: species must find ways of surviving (i.e.,
        finding safe valleys of survival) that may only be evolvable by first becoming less
        able to survive (i.e., crossing a mountain ridge). It is very difficult to optimise a
        rugged objective function, yet Hinton and Nowlan demonstrated that living systems can
        achieve practical solutions to rugged problems using Semiotic Adaptation.
        
        Semiosis is the biological process by which organisms construct Meaning from the events
        that they experience. So what is meaning? If you hear a footstep when walking in town one
        day, it will probably have little meaning for you. However, if you hear that same
        footstep behind you while walking home alone at night, it might have great meaning for
        you! Meaning is something you construct out of the sounds, feelings and sights that you
        experience. To have meaning for you, an event must influence you behaviour, and this
        behavioural influence is a habit that you have learned.
        
        We say that organism development is Plastic: the structure and behaviour of our body
        changes in long-term ways during our lifetime, and becomes permanent, or habitual. These
        habits are the meanings that we construct and learn.
        """,
    ),
    Activity(
        """
        Learning involves two processes: exploration and plasticity. When we learn to walk, we try
        out various different ways of moving our bodies, and in the process, we change our habits
        to make it more or less likely that we will move that way in the future. Now, these new
        habits can be either useful or unuseful for our survival. In both cases, developmental
        plasticity (that is, learning) is relevant for genetic selection. Because even if my genome
        doesn't give my body the ability to generate vitamin C, I can still either survive by
        learning the habit of eating fruit, or else die through failing to learn this habit.
        
        So, whereas the genome of each SelectiveExploration agent encodes a single candidate
        string, H&N's genome defines the exploration and plasticity of an agent's lifelong
        developmental journey to discover new possible candidate strings. Notice, however, that
        if the agent, through exploration, finds a more string-production habit, it cannot pass
        this on to its offspring, since the habit is not encoded in its genome. Rather, the agent
        must can pass on its ability to explore in ways that may rediscover that habit.
        
        The suggestion of H&N's work, therefore, is that agents who inherit not just one candidate
        solution, but rather a life-narrative of how to explore solutions efficiently, may be more
        successful in finding problem solutions. Implementing this is our next exciting step!
        """,
    ),
]

end