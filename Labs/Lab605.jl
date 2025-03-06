#========================================================================================#
#	Laboratory 605
#
# Fields
#
# Author: Niall Palfreyman, March, 2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 605:
            Fields - The environmental selection rules on agents' behaviours.

        Autonomous, living systems are not only embodied as collectives of agents, but are also
        embedded in an environment that influences them and which they themselves influence. In
        this lab, we explore the nonlocal fields that organise the behaviours of agents. These
        fields are entites in their own right, possessing their own nonloocal dynamics such as
        excitation, diffusion and evaporation. We shall see how such fields provide the topological
        structure that organises the biological development of organisms and behaviour.

        To get a feel for how fields function, load the module Fields and run the method
        Fields.demo(); however, please DO NOT yet press the Run button! :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The Fields model simulates the behaviour of SlimeMould cells wandering through their
        environment. When SlimeMould cells are in a state of starvation, they secrete into their
        environment cAMP (cyclic Adenosine MonoPhosphate), which is displayed in the model as a
        trail left behind as the cell moves. Run the simulation now until the cAMP trail starts to
        display yellow regions, then pause the simulation. Do the yellow regions represent high or
        low concentrations of cAMP?
        """,
        "Notice how the yellow regions form out of the cAMP trail. What does this suggest?",
        x -> occursin("high",lowercase(x))
    ),
    Activity(
        """
        Yellow regions represent 'hotspots' where many passing cells have over time collectively
        deposited a large amount of cAMP. Hotspots therefore show where SlimeMould cells have
        recently spent a lot of time. But there is a problem. Set the dt parameter to 10, press
        Update and then Run. Do the hotspots still show you where cells have recently passed?
        """,
        "Can you still see where the first hotspot formed?",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Clearly, the cAMP concentrations are rising steadily, and this hides the information that
        they have to offer. You can view this information by removing the comment marker at the
        beginning of the mdata specification in Fields.demo(). This will display the rising cAMP
        concentration over time. Load and run the simulation again with a high value of dt. What
        is the mean concentration of cAMP when the world is completely yellow?
        """,
        "Make sure Every element of the world is yellow before you take the reading",
        x -> x>20
    ),
    Activity(
        """
        It certainly doesn't look like the mean concentration of cAMP will stop growing any time
        soon! What is the mathematical name for this kind of growth over time?
        """,
        "Notice that the growth rate is constant",
        x -> occursin("linear",lowercase(x))
    ),
    Activity(
        """
        This linear growth is a problem because eventually it becomes so large that it swamps the
        information that the cAMP field has to offer. Fortunately, unlimited growth is something
        that never really happens in the biological. In particular, chemical substances tend to
        evaporate over time. In the Fields model, cAMP evaporates by a constant fraction on each
        time step. Set the αcAMP parameter to 0.001, press Update and then Run. What is the maximum
        value of the mean cAMP concentration now?
        """,
        "You need to wait for the cAMP field to stabilise, so a high dt value is again useful",
        x -> x==2.0
    ),
    Activity(
        """
        The cAMP field now stabilises at a maximum value when the deposition of cAMP by SlimeMould
        cells is balanced by cAMP evaporation. This maximum value is the result of a dynamic
        equilibrium between the two processes. What is the mathematical name for this kind of
        equilibrium?
        """,
        "Notice how the cAMP field reliably moves towards this equilibrium",
        x -> occursin("stable",lowercase(x))
    ),
    Activity(
        """
        Which method of the Fields module implements the evaporation of cAMP with rate αcAMP?
        """,
        "",
        x -> occursin("model_step",lowercase(x))
    ),
    Activity(
        """
        Comment out the mdata specification in Fields.demo() to switch off the display of the mean
        cAMP concentration, and reduce the αcAMP parameter to 0.0006, press Reset and then Run.
        This reduced evaporation rate means that the cAMP field now stabilises at a higher or
        lower maximum value?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice also that the cAMP field now forms isolated hotspots containing information about
        regions recently visited by SlimeMould cells. We can imagine that this infomration might
        be useful for the cells, but at the moment it is very localised. To make this information
        more widely accessible, we must allow the cAMP field to diffuse through the world. Raise
        the diffusion rate ΛcAMP to 0.01, press Update and then Run. Notice that the mean level
        of cAMP does not change, but the hotspots are now spread out into regions that inform
        cells that there is a hotspot nearby. Which method in AgentTools.jl implements the
        diffusion of values in a field like cAMP?
        """,
        "Look in the module AgentTools",
        x -> occursin("diffuse4",lowercase(x))
    ),
    Activity(
        """
        Let's take a moment now to study how the method diffuse4() works. We know that diffusion
        is a process that spreads out a quantity from regions of high concentration to regions of
        low concentration. In the Fields model, the diffusion rate ΛcAMP determines how fast this
        spreading occurs. The method diffuse4() takes as input a field F and a diffusion rate Λ,
        and returns a new field that is the result of spreading out the quantity of F at each point
        in space. To see this in action, load AgentTools into the Julia REPL and create the
        following two matrices:
            F = [0 0 0;0 1 0;0 0 0]
            F1 = diffuse4(F,0.2)

        How much field quantity is removed from the central cell when we transform F into F1?
        """,
        "F[2,2] - F1[2,2]",
        x -> x==0.2
    ),
    Activity(
        """
        Where has this field quantity gone to? Add up the field quantities in the other cells of F1
        and compare this sum to the field quantity that was removed from the central cell. Has any
        field quantity vanished during the diffusion process?
        """,
        "",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Now perform the second diffusion step:
            F2 = diffuse4(F1,0.2)

        The diffusion process removed 0.2 from the central cell of F and spread it out into the
        neighbouring cells in F1. Now the second step of the diffusion process removes 0.2 of the
        0.8 remaining in the central cell of F1, and spreads it out into the neighbouring cells in
        F2. What is the value 0.2*0.8 of the spread amount?
        """,
        "",
        x -> x==0.16
    ),
    Activity(
        """
        If diffusion removes 0.16 from the 0.8 in the central cell of F1, there should be 0.64 left
        in the central cell of F2. Look at the actual quantity left in the central cell of F2 - is
        this more or less than our calculated value of 0.64?
        """,
        "",
        x -> occursin("more",lowercase(x))
    ),
    Activity(
        """
        The diffusion process leaves 0.01 too much field quantity in the central cell of F2. Where
        has this extra amount come from?
        
        The extra amount comes from the four neighbouring cells of F1. During diffusion, each of
        these neighbours also contributes 0.2*0.05 = 0.01 of its field quantity to each of Its 4
        neighbours - one of which is of course the central cell! So each of the four neighbours in
        F1 contributes 0.01/4 = 0.0025 to the central cell of F2. And since the central cell has
        exactly four neighbours, this adds up to the extra amount of field quantity 0.01 that we
        found in the central cell of F2. So this is the essence of how diffusion works:

            Every cell distributes a fraction of its field quantity to all of its 4 neighbours, and
            also itself receives that same fraction of the field quantity of each of its 4
            neighbours. What name do we give to this fraction?
        """,
        "",
        x -> occursin("diffraction",lowercase(x)) && occursin("rate",lowercase(x)) ||
                occursin('Λ',lowercase(x)) || occursin("lambda",lowercase(x))
    ),
    Activity(
        """
        Now we understand how diffusion works, let's look at how it is implemented in the method
        AgentTools.diffuse4(). Look at this code of this method and notice that it calls the method
        circshift() four times. To get a feel for what is happening, we'll reduce the number of
        spatial dimensions to one. Create the following row vector:
            F = [0 0 1 0 0]

        and consider what diffusion does with the neighbour element F[2]. Again using a diffraction
        rate of Λ, what will be the new value of F[2] after diffusion?
        """,
        "Remember that 0.2 of the field in the central cell F[3] is spread out to its two " *
            "neighbouring cells",
        x -> x==0.1
    ),
    Activity(
        """
        So after diffusion, the new value of F[2] and F[4] is 0.1, and the new value of F[3] is
        0.8. What will the new value of F[1] and F[5]?
        """,
        "Do these cells receive any field quantity from neighbouring cells?",
        x -> x==0
    ),
    Activity(
        """
        Each cell in F receives a fraction Λ/2=0.1 of the field quantity of its two neighbours, but
        also loses a fraction Λ=0.2 of its own field quantity to its two neighbours. So the change
        in the value of the cell F[i] is:
            (Λ/2)*F[i-1] + (Λ/2)*F[i+1] - Λ*F[i] == 0.5Λ*(F[i-1] + F[i+1] - 2F[i])

        Now study the result of each of the following two lines of code in the Julia REPL:
            circshift( F, (0,1))
            circshift( F, (0,-1))

        In which direction does the shift specifier (0,1) move the elements of F?
        """,
        "",
        x -> occursin("right",lowercase(x))
    ),
    Activity(
        """
        Now focus on one of the cells in the middle of the row vector F, say F[3], and explore
        how the field quantity in that cell changes under the following operation:
            0.5Λ*(circshift(F,(0,-1)) + circshift(F,(0,1)) - 2F)

        You can see that this is precisely the formula used in the method AgentTools.diffuse4() to
        implement diffusion - except that there we use the factor 0.25Λ instead of 0.5Λ, since
        diffuse4() implements diffusion in 2 dimensions, whereas our row vector F is only
        1-dimensional.

        Just one issues remains: What is the effect of circshift on values at the edges of the
        field? Construct a simple 5-element test vector F of your own to explore this question,
        then tell me which elements of F contribute field quantity to the cell F[1], using this
        circshift() implementation of diffusion.
        """,
        "",
        x -> occursin('2',x) && occursin('5',x) && !occursin('3',x) && !occursin('4',x)
    ),
    Activity(
        """
        Now that we understand how evaporation and diffusion contribute to the dynamics of the
        cAMP field, can you find rates of evaporation and diffusion that generate a display like
        comets whose tails are well-defined and stable, but only show the most recent path of the
        SlimeMould cells? Which parameter is non-zero for this effect: the evaporation rate or the
        diffusion rate?
        """,
        "",
        x -> occursin("evap",lowercase(x))
    ),
    Activity(
        """
        Can you find diffusion and evaporation rates that generate a maximally even and stable mean
        density of 2.0 for cAMP across the entire world? Tell me the corresponding values of the
        evaporation and diffusion rates as an ordered pair (αcAMP,ΛcAMP).
        """,
        "",
        x -> x==(0.001,0.1)
    ),
    Activity(
        """
        Now we come to the most exciting part for biological modellers: the interaction between
        agents and fields. In the Fields model, the SlimeMould cells deposit cAMP at their current
        position, and then move to a new position. The cAMP field then diffuses and evaporates
        over time. This means that the cAMP field is a dynamic entity that is constantly changing,
        and which affords environmental information to the SlimeMould cells.
        
        Think about how slime-mould cells might use this information to guide their movements: they
        might move either towards, or away from, regions of high cAMP concentration. This feedback
        loop between slime-mould agents and the cAMP field that they themselves create, is called
        Niche-Construction.

        Niche-Construction is a powerful mechanism in the self-organisation of biological systems.
        If we built an ABM of such a niche-constructing system, what structures might emerge from
        the interaction between agents and fields that we could use as a reference mode for testing
        our model's behaviour?
        """,
        "What cAMP concentration pattern would you expect to emerge out of agents' general " *
            "movement Towards regions of high cAMP concentration?",
        x -> true
    ),
    Activity(
        """
        Develop your own niche-construction model to find out how agents and fields interact in
        each of the two cases where agents move towards or away from high cAMP concentrations.
        Remember: Simplicity and modularity are crucial features of any successful ABM; make sure
        your model is as simple and modular as possible. All you really need to do is modify the
        method Fields.agent_step!() method so that SlimeMould cells move along or against the
        gradient (AgentTools.gradient()) of the field model.cAMP.
        
        When you have built and tested your model, try to build up a feel for the effect of the
        parameters αcAMP, ΛcAMP, and the agents' movement speed on the emergent structures. What
        happens when you increase the agents' movement speed? What happens when you increase the
        evaporation rate αcAMP? What happens when you increase the diffusion rate ΛcAMP?

        Good luck! :)
        """,
        "",
        x -> true
    ),
]