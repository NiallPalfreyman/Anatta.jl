#========================================================================================#
#	Laboratory 602
#
# Modelling collective behaviour in an artificial ecosystem.
#
# Author: Niall Palfreyman, 5/1/2025
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 602: What is Collective behaviour?

        In the previous lab, we saw that the collective behaviour of a large community of agents in
        Schelling's model can be surprising. By this, we mean that it can be difficult to predict
        the community's behaviour based on the actions of its individual agents. Two important
        issues here are Embodiment and Complexity:
        -   Embodied behaviour arises from the collective actions of individual, interacting agents;
        -   Complex behaviour is lawful, yet non-computable.

        One central aim of this Subject is to understand how embodiment generates complexity, but
        in this lab, we focus particularly on embodiment:
        -   How do I build an embodied system?
        -   What makes the collective behaviour of an embodied systems so special?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        To build an embodied system, we always start from a Research Question and a Reference Mode.
        The Research Question asks how some interesting collective behaviour (e.g., Schelling's
        community-level segregation) arises out of individual agent interactions (e.g., Schelling's
        individual preference). The Reference Mode is a simpler behaviour displayed by real systems,
        and which our model must display in order to qualify as an answer to the research question.
        
        For example, in this lab, we will build our own ABM according to this specification:
        -   Research question: Can trophic ecosystems generate sustainably periodic behaviour?
        -   Reference mode: The ecosystem must display realistically sustainable base behaviour!

        To answer the research question, our module Ecosystem will model turtles swimming around,
        gaining energy by finding and eating algae. If turtles gain enough energy, they reproduce;
        if their energy falls to zero, they die. Algae regrow with a certain probability. As a
        reference mode, turtles and algae must display realistically sustainable long-term survival.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In the Generative library you will find a file Stub.jl that contains a stub module called
        Ecosystem. This module is a template for the Ecosystem model that you will build in this lab,
        but also for many other models that you might build. The module contains a number of
        placeholders marked by the comment # To-do: ... which you will adapt to your model as you
        work through this lab.

        Copy the file Stub.jl to a new file Ecosystem.jl in the same directory, and open it in VSC.
        Can you guess which module I copied and adapted to create this stub module?
        """,
        "",
        x -> occursin("schelling",lowercase(x))
    ),
    Activity(
        """
        I urge you strongly to start all your new projects in this way: by copying a stub module
        that already contains the basic structure of the module you want to create. This will save
        you a lot of time and effort, and also help you to avoid making mistakes. It is a good
        habit to get into, and one that will serve you well in the future.

        Compile your new Ecosystem module now, then run the demo() function to see what the stub
        model looks like. You will see that the model is not yet complete, but that it already
        contains a number of useful features that we can build on. It displays both agent- and
        model-level data, and allows you to explore the model interactively. If you repeatedly
        press the Step button, you will see the single agent moving across the model world.

        Observe carefully what happens when the agent reaches an edge of the world. Look up the
        method move_agent!() on the Agents website, then tell me which property of the model
        causes the agent to behave this way at the edges.
        """,
        "",
        x -> occursin("periodic",lowercase(x))
    ),
    Activity(
        """
        We will now extend this simple Ecosystem stub to answer our research question and also to
        learn a bit more about creating and using Agents to study embodied systems and collective
        behaviour. First, we'll define the Turtle agents in our model that swim around and eat
        algae. Their motion is continuous, rather than the grid-based motion of Schelling's agents,
        so we use the alternative type ContinuousAgent.
        
        Whereas GridAgents only automatically store their position (pos), ContinuousAgents also
        automatically store their velocity (vel), which tells them in which direction they should
        move. vel also specifies a Facing Direction, which will be useful when we want agents to
        interact with each other.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Next, we need to initialise the Ecosystem model in the ecosystem() method. Initialisation
        sets up a world of Turtles moving around in a continuous space, eating algae and
        reproducing. Find the To-do activity "Initialise the model properties" and insert the
        following entries into the properties dictionary:
            :dt         => 0.1,     # Time-step interval for the model
            :n_turtles  => 5,       # Initial number of turtles
            :v0         => 5,       # Maximum initial speed of a turtle
            :E0         => 100.0,   # Maximum initial energy of a turtle
            :Δliving    => 1.0,     # Energy cost of living
            :Δeating    => 7.0      # Energy benefit of eating one alga
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We can leave the definition of ecosys exactly as it is, but we must set up the initial
        population of Turtles. Let's be a little more creative here: instead of moving all the
        Turtles in the same direction, let's give give them a random direction to start with.
        This will make the model more interesting and realistic. First, under the To-do activity
        "Initialise the agents", change the number of turtles to the model initialisation value 5:
            for _ in 1:ecosys.n_turtles
                vel = ecosys.v0 * [1,1]
                energy = ecosys.E0 
                add_agent!( ecosys; vel, energy)
            end

        Now compile and run the Ecosystem model using demo(), and notice that you now have 5
        Turtles. However, at present they all move in the same direction and with the same
        maximum initial speed ecosys.v0. With what must we multiply the value v0 in order to
        randomise the Turtles' speed? Do this now, then confirm that the Turtles now move at
        various different speeds.
        """,
        "",
        x -> occursin("rand",lowercase(x))
    ),
    Activity(
        """
        Right, now let's fix the problem of the Turtles' direction of travel! Agents contain a
        Tuple named vel representing their velocity, that is, their speed and direction of travel.
        It is often also convenient to think of this as the direction in which an agent faces.

        If we want our agents to move with a given speed, say v0, in a random direction, we need to
        multiply v0 by a randomly directed unit vector. The easiest way to do build such a unit
        vector is to calculate cosine and sine components of a random angle θ in the range [0,2π):
            θ   = 2π*rand()
            vel = (cos(θ),sin(θ))

        Implement this using the following code. Do the Turtles move in different directions?
            vel = ecosys.vo * rand() * (θ->[cos(θ),sin(θ)])(2π*rand())
        """,
        "",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Now that's starting to look more interesting! To make it even more interesting, on each
        step, we will make 30% of the Turtles rotate slightly (that is, they change their Facing
        direction by a small angle up to 12°, or pi/15, left or right). The following calculation
        yields just such a small random angle:
            Δ = (2rand()-1)*pi/15

        Check that this is mathematically correct; for example, what would be the value of Δ if the
        method call rand() returned its minimum possible value of 0.0?
        """,
        "",
        x -> abs(x+pi/15) < 1e-2
    ),
    Activity(
        """
        Once we have calculated the small angle Δ, we can use it to rotate the Turtle's velocity.
        We do this by multiplying the velocity vector by the following 2x2 rotation matrix:
            R = [cos(Δ) -sin(Δ)
                 sin(Δ)  cos(Δ)]

        To see how this rotation works, set Δ=pi/6 in the REPL, insert this into the definition of
        R, and then use R to pre-multiply each of the two unit vectors [1,0] and [0,1]:
            R * [1,0], R * [0,1]

        You should see that this rotates each unit vector through an angle Δ. On the other hand,
        inserting -Δ into R rotates the vectors in the opposite direction. Is this correct?
        """,
        "",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Now let's insert our rotation code into the method agent_step!(), in which each agent
        decides how to act on each step of the simulation. Insert the following code into the
        Ecosystem model under the To-do activity Move, then check that the Turtles now rotate
        slightly before moving forward:
            cs,sn = (x->(cos(x),sin(x)))((2rand()-1)*pi/15)
            me.vel = [cs -sn;sn cs]*collect(me.vel)
            move_agent!( me, model, model.dt)

        Question: We said earlier that me.vel is a Tuple, yet here we assign a Vector to it.
        Which mechanism of the julia language makes it possible for us to do this?
        """,
        "You'll need to look in the manual to find the answer!",
        x -> occursin("conver",lowercase(x)) || occursin("promot",lowercase(x))
    ),
    Activity(
        """
        Wonderful! Our Turtles can now move around very realistically - now we will make them
        interact with their environment. First, we make them mortal: each Turtle loses a unit of
        energy on each step. If a Turtle's energy falls to zero, it dies. Insert the following
        code into the agent_step!() method under the To-do activity Set state:
            me.energy -= 1
            if me.energy < 0
                remove_agent!( me, model)
                return
            end

        Now run the model and check that the Turtles die when their energy falls to zero. How many
        steps does it take for them all to die?
        """,
        "",
        x -> 19 < x < 21
    ),
    Activity(
        """
        This situation is unrealistic, because it contains two Artefacts - behaviours of our model
        that are not present in the real world, but are caused by the way we implemented the model.
        First, Turtles lose energy at a rate of 1 unit per time-step interval dt, which is currently
        set to 0.1. So whenever we change the value of dt, the Turtles die at a different rate! To
        fix this, we will calculate the correct energy loss per time step. Change the first line of
        code that you just inserted into agent_step!() to this new line:
            me.energy -= model.Δliving * model.dt
        
        The second artefact is that our Turtles all disappear is a single collective Death, whereas
        in real life, each individual would die at its own individual time. This artefact arises
        from the fact that we initialised all Turtles to the same initial energy level ecosys.E0.
        In the To-do activity "Initialse the agents", change the Turtles' initial energy to
            energy = rand(1:ecosys.E0)

        Now run the model again and check that the Turtles now die at different times.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now we will check our reference mode: the model must display Realistically sustainable
        base behaviour. Clearly, our Ecosystem model is not yet sustainable, because the Turtles
        all die out. However, even dying out is a behaviour that we can check against our reference
        mode. Study the graphs now, and notice that the number of Turtles falls linearly over time
        (i.e., constant numbers of Turtles die in constant intervals of time). What distribution of
        initial energy levels would make the Turtles die out in this way?
        """,
        "",
        x -> occursin("uniform",lowercase(x))
    ),
    Activity(
        """
        This seems a realistic distribution of initial energy levels in a typical population, which
        is why we chose it. However, we would like the Turtles to survive longer, so we will now
        give the Turtles algae to eat. We will represent the algae as a background field in the
        model, and the Turtles will eat the algae as they move around. The algae will regrow with a
        certain probability, so that the Turtles can survive indefinitely.

        First, we shall define a random distribution of algae in the model. Under the To-do
        activity "Initialise the model properties", add this entry to the properties dictionary:
            :algae      => rand(Bool,extent),

        This creates a grid of algae that is the same size as the model world. We also want to
        see this distribution in our output, so we use the algae to define a Heatmap that maps the
        algaei to the colour lime. Insert this code into the plotkwargs dictionary under the To-do
        activity "Set up plotting parameters", then run the model and enjoy the pretty colours:
            heatarray       = (model->model.algae),
            heatkwargs      = (colormap=[:black,:lime],colorrange=(0,1)),
            add_colorbar    = false,
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now we'll define a method eat!() that allows a Turtle to eat algae at its current position.
        The Turtle receives a feeding-benefit Δeating towards its own energy, and the algae are
        removed from the current location. Insert the following method into the Ecosystem model,
        remembering to position it appropriately and provide a docstring:
            function eat!( turtle, model)
                indices = get_spatial_index( turtle.pos, model.algae, model)
                if model.algae[indices]
                    turtle.energy += model.Δeating
                    model.algae[indices] = false
                end
            end

        Insert a call to eat!() under the To-do activity Act in agent_step!():
            eat!( me, model)

        When you test your new code, how does the total energy of the Turtles behave in the long-
        term? Does it increase, decrease, or stay the same?
        """,
        "",
        x -> occursin("decreas",lowercase(x))
    ),
    Activity(
        """
        Algae are a food resource for the Turtles, but to sustain the Turtles indefinitely, they
        must regrow at some probabilistic rate. Insert the following method into the Ecosystem
        model, positioning and docstringing it appropriately:
            function model_step!( model)
                empty_locs = .!model.algae
                model.algae[empty_locs] .= (rand(count(empty_locs)).<model.prob_regrowth)
            end

        Integrate this method into our model. Define the regrowth probability by adding this entry
        to the properties dictionary under the To-do activity "Initialise the model properties":
            :prob_regrowth  => 0.01,

        Now inform the Agents package of your new model_step!() method by inserting the argument
        "model_step!," after the agent_step! argument in your call to the StandardABM constructor.

        What happens to the total energy of the Turtles in the long-term now? Does it increase,
        decrease, or stay the same?
        """,
        "",
        x -> occursin("increas",lowercase(x))
    ),
    Activity(
        """
        As you see, the Turtles' energy now gets very large, because the algae regrow too quickly.
        We can fix this by reducing the probability of regrowth. We will do this dynamically by
        adding a slider bar to the model that allows us to change the regrowth probability.
        prob_regrowth is already a model property, so we only need to add it to the params
        dictionary in the demo() function. In the params dictionary under the To-do activity
        "Specify model exploration parameters", delete the existing entries for v0 and E0, and
        replace them by the following entry:
            :prob_regrowth  => 0:0.0001:0.01,
        
        Now run the model again and vary the value of prob_regrowth. How low must you set this
        value to stop the Turtles' energy from increasing indefinitely?
        """,
        "prob_regrowth=0 prevents algae from regrowing; prob_regrowth=1 will probably explode!",
        x -> x==0
    ),
    Activity(
        """
        As you see, we need to set prob_regrowth Extremely small to prevent the Turtles from
        accumulating infinite energy. However, remember that there are still only 5 Turtles. In a
        real ecosystem, the number of Turtles increases through reproduction, and these new Turtles
        reduce the number of algae (this is the collective behaviour we want to investigate). To
        achieve sustainable collective behaviour, Turtles must reproduce when they have enough
        energy. Insert and document the following method in the Ecosystem model:
            function reproduce!( parent::Turtle, model)
                if parent.energy > model.E0 && rand() < 0.01
                    parent.energy -= model.E0
                    add_agent!( parent.pos, model, parent.vel, model.E0)
                end
            end

        Insert a call to reproduce!() under the To-do activity Act in agent_step!(). Now run the
        model: is this behaviour sustainable?
        """,
        "You need to check that the Turtles neither die out nor grow indefinitely.",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Hurray! As you see, our model now fulfills our reference mode by exhibitin sustainable
        behaviour: the Turtles neither die out nor grow indefinitely. Before proceeding, let's
        make a few cosmetic changes. The circles representing the turtles don't show us in which
        direction the turtles are facing (vel), so it would be nice to make this clear in their
        representation. We do this by making the following changes within the Ecosystem module:
            - include() the file AgentTools.jl from the Generative folder;
            - use the .AgentTools module;
            - Under the To-do activity "Specify plotting keyword arguments" in demo(), specify
                agent_marker=wedge in the plotkwargs Tuple;
            - Recompile and run Ecosystem.jl, and notice how the Turtles turn.

        Look up the wedge() method in AgentTools, which specifies a rotation matrix for turning a
        Turtle through an arbitraty angle θ. Which matrix turns the Turtle left through 90°?
        """,
        "",
        x -> sum(abs.(x[:]-[0,1,-1,0])) < 1e-2
    ),
    Activity(
        """
        You may like to experiment with different colours for the Turtles and the algae. The
        AgentTools module contains a function multicoloured() that returns a different colour for
        each agent, depending on its id. You can use this function to specify the agent_color in
        the plotkwargs Tuple, or you might enter "Greens" from this full list of colorschemes:
            https://juliagraphics.github.io/Colors.jl/stable/colormapsandcolorscales/
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Which slider bar enables you to reduce the speed of the simulation?
        """,
        "",
        x -> occursin("sleep",lowercase(x))
    ),
    Activity(
        """
        Now that we fulfill the reference mode, we can use the model to experiment. We will install
        our own slider bars for the model parameters that we wish to experiment with. Under the
        To-do activity "Specify model exploration parameters" in the demo() method, make the
        following changes, then run the method again to make sure your new sliders are working
        correctly. It is important that your Dict is named 'params', since this is the correct name
        of the abmexploration() keyword argument:
            params = Dict(
                :prob_regrowth	=> 0:0.0001:0.01,
                :E0	            => 10.0:200.0,
                :Δeating        => 0:0.1:10.0,
                :Δliving        => 0:0.1:10.0,
            )
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We wish to explore time-series statistics for the ongoing numbers of turtles and algae.
        Under the To-do activity "Specify plotting keyword arguments" in the demo() method, add the
        following entries to the plotkwargs Tuple, then run the model again to see the new graphs:
            adata=[(a->isa(a,Turtle),count)], alabels=["Turtles"],
            mdata=[(m->sum(m.algae))], mlabels=["Algae"],
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We have now built an embodied system; that is, its behaviour is certainly collective, since
        it arises from the interactions of many individual agents. This fact may not seem very
        exciting to you, but it is actually basic to our entire understanding of how life works.
        
        The 'decision' to converge to some particular behaviour is not made by any individual
        Turtle, nor even by the population of Turtles, but by the entire Ecosystem of Turtles+Algae.
        Once we establish that a behaviour is collective, the big question is then whether that
        behaviour is complex, or merely computable.
        
        We will leave it until another lab to discover whether this behaviour is Non-Computable
        from its individual components. In that case, we would be able to say that our Ecosystem
        autonomously Chooses, rather than merely decides, to behave in some particular way.

        For now, it is now your task to demonstrate that our Ecosystem is capable of converging to
        sustainably periodic collective behaviour. Experiment with the model's sliders to find a
        set of parameter values that generates such intrinsically collective behaviour.
        """,
        "",
        x -> true
    ),
]