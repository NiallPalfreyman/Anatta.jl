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

        In the previous lab, we saw in Schelling's model that the collective behaviour of a large
        community of agents can be surprising. By this, we mean that it can be difficult to predict
        the behaviour of the community, based on the actions of its individual agents. The two
        important issues here are Embodiment and Complexity:
        -   Embodied systems consist of individual, interacting agents acting collectively;
        -   Complex behaviour is lawful, yet non-computable.

        One central aim of this Subject is to understand the connection between embodiment and
        complexity, but in this lab, I want to focus particularly on embodiment:
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
        -   Reference mode: The ecosystem must display sustainable base behaviour!

        To answer the research question, our module Ecosystem will model turtles swimming around,
        gaining energy by finding and eating algae. If turtles gain enough energy, they reproduce;
        if their energy falls to zero, they die. Algae regrow with a certain probability. This
        system must display sustainable long-term survival of turtles and algae.
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
        contains a number of useful features that you can build on. It prints out both agent- and
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
        so we use the alternative type ContinuousAgent. Their stub functionality already includes
        speed, but they also need energy in order to live, so insert the following new attribute
        into the Turtle definition:
            energy::Float64						# My current energy

        Notice that the Turtle agent also knows in which direction to move; this information is
        stored in its vel property, which we will also need to specify when we later create new
        Turtles.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Next, we need define the ecosystem() method that initialises the Ecosystem model. This
        method will set up a world of Turtles moving around in a continuous space, eating algae and
        reproducing. Find the To-do comment "Define the ecosystem properties" and add the following
        entries to the properties dictionary:
            :dt             => 0.1,         # Time-step interval for the model
            :n_turtles      => 5,           # Initial number of turtles
            :max_speed      => max_speed,   # Turtles' maximum speed
            :E0             => 100.0,       # Maximum initial energy of a turtle
            :Δliving        => 1.0,         # Energy cost of living
            :Δeating        => 7.0          # Energy benefit of eating one alga
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We can leave the definition of ecosys exactly as it is, but we must set up the initial
        population of Turtles under the To-do comment "Initialise the agents". Let's be a little
        more creative here: instead of having all the Turtles moving in the same direction, let's
        give them a random direction to start with. This will make the model more interesting and
        realistic. Replace the current add_agent!() call with the following code:
            for _ in 1:ecosys.n_turtles
                vel = (1,1)
                speed = ecosys.max_speed
                energy = ecosys.E0 
                add_agent!( ecosys, vel, speed, energy)
            end

        Now compile and run the Ecosystem model using demo(), and notice that you now have 5
        Turtles. However, they currently all move in the same direction and with the same speed.
        With what must we multiply the value ecosys.max_speed in order to randomise the Turtles'
        speed? Do this now and confirm that the Turtles now move at various different speeds.
        """,
        "",
        x -> occursin("rand",lowercase(x))
    ),
    Activity(
        """
        Now let's fix the problem of the Turtles' velocity (i.e., direction of travel). ???
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        First, run the video clip a few times to get a feeling for what's happening. You can't see
        the algae yet, but you can verify that they are there by experimenting with the value of
        the model property prob_regrowth in the initialisation method ecosys(). Notice its effect
        on the turtle population.
        """,
        "prob_regrowth=0 prevents algae from regrowing; prob_regrowth=1 will probably explode!",
        x -> true
    ),
    Activity(
        """
        At the beginning of a run, you may notice that sometimes a string of turtles appears that
        are moving together in a line that then breaks up. Think carefully about how this might
        be happening, then tell me which method is causing it:
        """,
        "Investigate how new turtles are born",
        x -> occursin("repr",lowercase(x))
    ),
    Activity(
        """
        The circles representing the turtles don't show us which way the turtles are facing (vel),
        so it would be nice to change their representation accordingly. You can achieve this by
        doing the following:
            - include() the file AgentTools.jl from the DSM folder;
            - In demo(), specifiy agent marker `AgentTools.wedge`;
            - Specify also agent colour `:red` and agent size 10;
            - Recompile and run Ecosystem.jl.

        Which kwarg specifies the agent marker?
        """,
        "",
        x -> x=="am"
    ),
    Activity(
        """
        It would be helpful if we could see the algae and their reaction to the presence of
        turtles. In order to visualise them, we shall add them in as a "heatarray" (this is
        abmvideo's rather strange name for a background field). The values of the algae are
        already contained in the Ecosystem model property :algae, and we can easily include these
        values in the video by inserting into abmvideo() the following kwargs:
            heatarray=(model->model.algae), 						# Background map of algae
            heatkwargs=(colormap=[:black,:lime],colorrange=(0,1)),	# Algae's colours
            add_colorbar=false,										# No need for algae colour bar

        Do this now, then tell me the colour of the algae:
        """,
        "",
        x -> x==:lime
    ),
    Activity(
        """
        Before proceeding with this lab, you may first like to experiment with different colours
        for the heatmap. You can find a full list of colorschemes here: ???
            https://docs.juliaplots.org/latest/generated/colorschemes/
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice how the number of arguments in the call to abmvideo() is getting rather large
        and difficult to understand. In such situations it is useful to pull out the relevant
        keyword arguments into a separate variable - for example called plotkwargs = and then to
        insert this variable into the call to abmvideo() like this:
            abmvideo(
                "Ecosys.mp4", ecosys, agent_step!, model_step!;
                framerate = 50, frames = 2000,
                plotkwargs...
            )
    
        Do this now, and ensure that your simulation is still working correctly.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In order to understand our Ecosystem better, it would be nice to be able to work more
        interactively with it, changing parameters and immediately seeing the results. For this
        reason, we will now replace our call to abmvideo() by a call to abmexploration(). This
        method builds an exploratory playground around the Ecosystem model. Do this now:
            playground, = abmexploration( ecosys;
                agent_step!, model_step!,
                plotkwargs...
            )

        Then make sure that Ecosystem.demo() returns the Figure `playground`, so that you can
        view and use the resulting app. Which slider bar enables you to reduce the speed of the
        simulation?
        """,
        "",
        x -> occursin("sleep",lowercase(x))
    ),
    Activity(
        """
        Now we will install our own slider bars for the model parameters that we wish to experiment
        with. Make the following changes to Ecosystem.demo(), then run it again to make sure your
        new sliders are working correctly. Note that it is important that your variable is named
        'params', since that is the correct keyword for calling abmexploration():
            params = Dict(
                :n_turtles		=> 1:200,
                :turtle_speed	=> 0.1:0.1:3.0,
                :prob_regrowth	=> 0:0.0001:0.01,
                :initial_energy	=> 10.0:200.0,
                :Δenergy		=> 0:0.1:5.0,
            )
        
            playground, = abmexploration( ecosys;
                agent_step!, model_step!, params,
                plotkwargs...
            )
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Finally, I would like to investigate some time-series statistics in the output: I'd like to
        view the ongoing numbers of turtles and algae. To-do this, please insert the following two
        extra lines of arguments into plotkwargs and rerun your simulation:
            adata=[(a->isa(a,Turtle),count)], alabels=["Turtles"],
            mdata=[(m->sum(m.algae))], mlabels=["Algae"],
        """,
        "",
        x -> true
    ),
    Activity(
        """
        You should observe that for certain values of `prob_regrowth`, the numbers of turtles and
        algae converge reliably towards oscillations around a more-or-less constant value. Now,
        this may not yet seem very special to you, but it actually underlies our understanding of
        how life works. This 'decision' to converge is not made by any individual turtle, nor even
        by the population of turtles, but by the entire Ecosystem of turtles+algae. In system
        dynamics, we say that the system's "structure determines behaviour".

        There are two different kinds of system-level, structurally determined behaviour:
        "collective" and "emergent" behaviour. The oscillations of our Ecosystem are an example of
        collective behaviour: they are _determined_, but not _chosen_, by the system. "Collective"
        behaviour arises from the behaviour of many interacting individuals, but the system itself
        does not yet select between different possible individual behaviours. "Emergent" behaviour
        is less easy to define, but we will look more closely at it in the next lab. Emergence
        describes well the fact that we cannot predict YOUR behaviour based only on your individual
        component cells.

        We would like to test how reliable this collective oscillation of the Ecosystem model is, but
        at the moment it is difficult to test this because the Reset button of abmexploration()
        doesn't reinitialise the model. Try this out now: rerun the model several times and notice
        that the initial configuration of the agents is always the same...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The AgentTools function abmplayground() enforces complete initialisation of our ABM models,
        and we will mostly use abmplayground() in this course. It requires the initialiser function
        ecosystem() as an argument, but all other arguments are simply passed to abmexploration().

        In your Ecosystem model, replace the call to abmexploration() by a call to abmplayground().
        Leave all the arguments the same, but insert the name of the initialiser function
        "ecosystem" as a second argument between the model name "ecosys" and the semicolon
        indicating the start of the keyword arguments - like this:
            playground, = abmplayground( ecosys, ecosystem;
                agent_step!, model_step!, params,
                plotkwargs...
            )

        Now run the model again and confirm that the collectively determined oscillations occur
        reliably for all initial configurations of turtles in the Ecosystem ...
        """,
        "",
        x -> true
    ),
]