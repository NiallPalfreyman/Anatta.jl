#========================================================================================#
#	Laboratory 600
#
# Welcome to course 600: An Introduction to Enactive Dynamics and Generative Science.
#
# Author:  Niall Palfreyman, 1/1/2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 600:
            Enactive dynamics - Knowledge is a property of Collectives, not of individuals!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In this Subject, I present an important argument about how we acquire knowledge. In
        particular, these concepts describe how Biology seeks to understand living systems ...
        - Embodiment: Each living organism is embodied as a collective of relational structures
            (e.g., genes, proteins) and dynamical processes (e.g., diffusion, osmosis).

        - Autonomy: Organisms maintain their stable systemic identity against the destabilising
            influence of external dynamical processes and internal structural operations.

        - Computability: Autonomous systems Compute, using operations on their internal structure.

        - Complexity: Autonomous systems Act on their environment, using Non-Computable processes.

        - Enactive Dynamics: Organisms implement complexity using Downward Selection. That is,
            their structure Computes a dynamical response to external destabilising processes, and
            this response non-computably Selects structural operations that avoid internal
            destabilisation.

        THEREFORE: Organisms' actions are non-computable, so biological understanding CANNOT involve
        computing/deducing them. Rather, Biology employs Generative Science (GS). GS understands
        organisms by Generating their behaviour from the Enactive Dynamics of Agent-Based collectives.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, so having sketched the aims of this Subject, let's take it slowly, piece by piece ...

        In object-oriented software development, we think of processes as belonging to software
        agents - after all, it is YOU who performs the processes of breathing and speaking, isn't
        it? So it makes sense to think of these processes as belonging to you.

        However, a major emphasis of the julia language is that PROCESSES are the primary movers of
        a system, while agents are only the localised nodes that store (or Stock) the properties
        created and manipulated by these processes. We therefore think of an Agent as a struct - a
        collection of local properties that can influence, or CONDITION, the processes, which in
        turn are able to change those same properties at that agent's location.

        Let's use this information: setup() the Generative library and open Schelling.jl in VSC.
        """,
        "Enter setup(\"Generative\") within your Anatta home directory, then open Schelling.jl",
        x -> isfile("Development/Generative/Schelling.jl")
    ),
    Activity(
        """
        In 1969, Thomas Schelling wanted to understand why city-planners' attempts to create
        ethnically mixed neighbourhoods in American cities always tended to develop over time into
        single-ethnicity neighbourhoods. In an attempt to understand this spontaneous segregation,
        Schelling constructed an Agent-Based Model (ABM) to generate its dynamics. The file
        Schelling.jl contains the basic form of Schelling's Segregation Model. Scroll through
        this file now and notice the following basic elements of any ABM:
        -   The Schelling module uses the Agents package
        -   It decleares an agent type Person, derived from the abstract type GridAgent{2}
        -   Person agents inherit the fields id::Int and pos::Tuple{2} from GridAgent{2}
        -   We define Persons to possess the additional fields comfort::Bool (how comfortable the
            Person feels) and tribe::Int (to which tribe the Person belongs)
        -   The method schelling() initialises a Schelling world in which Persons live
        -   The method agent_step!() defines how Persons act within their world
        -   The method demo() organises, runs and presents the results of the ABM

        Compile and load the module Schelling, then use the methods fieldnames() and fieldtypes()
        to reply() me the julia type of a Person's position.
        """,
        "You'll need to specify the type fully: Schelling.Person. The name of the field is `pos`",
        x -> x <: Tuple
    ),
    Activity(
        """
        Use comprehension to create a vector `agents` of six Persons with id's from 0:5, pos=(0,0),
        comfort=false and a random tribe between 1 and 2.
        """,
        "agents = [Schelling.Person(i,(0,0),false,rand(1:2)) for i in 0:5]",
        x -> Main.agents[5].id == 4
    ),
    Activity(
        """
        Execute the following code at the julia prompt:
            agents[3].pos = (3,4)

        Check the resulting effect on your agents Vector, then give me the expression agents[3]:
        """,
        "This code should have changed the position of the Person with id=2 to (3,4)",
        x -> x isa Main.Schelling.Person && x.id == 2 && x.pos == (3,4)
    ),
    Activity(
        """
        Now we know how to create agents using a constructor, but there is a problem with creating
        agents this way. In an ABM, agents are not just free-floating nodes: they sit within a
        space that defines whether they are close enough to interact with each other. This means we
        must always create agents with a unique id, a valid position within the space, plus various
        other constraints that agents must fulfill. All this book-keeping is reeeally boring, so we
        usually just hand over the job of agent-construction to the functions add_agent!() (place
        the new agent anywhere) and add_agent_single!() (place only one agent per grid position).
        
        So let's start again, and do things properly in the Schelling model. First, locate the
        initialisation method schelling() in Schelling.jl. The method first creates an empty Dict
        of properties that we will later use to define the model; next, it creates a Schelling
        model and returns it. To study this model, enter at the julia prompt:
            abm = Schelling.schelling()
        """,
        "",
        x -> Main.abm isa Any
    ),
    Activity(
        """
        If you display the object abm at the julia prompt, you see that it currently contains no
        agents. Enter:
            Schelling.add_agent!(abm; tribe=1)

        You immediately see that a Person agent has been created belonging to the tribe 1 and with
        the default value comfort=false. If you now display abm again, you see that it does indeed
        contain 1 Person. We can add more Persons, but in the Schelling model we want to be sure
        that each grid-point contains only one Person, so we prefer to use add_agent_single!(). Do
        this now and confirm that the new Person is at a new position, and that abm now contains
        2 agents.

        Use fieldnames() and fieldtypes() to investigate the fields of abm, then reply() me the
        width of the abm space.
        """,
        "fieldnames() requires a type; you can obtain this by entering fieldnames(typeof(abm))",
        x -> x==60
    ),
    Activity(
        """
        Now that we know how to add agents to our model, we'll do it properly within the
        initialisation method schelling(). Within this method, find the Learning activity for
        setting n_agents to 80% of the number of grid points. Change this code so that n_agents
        will contain the correct number for any worldsize. What is this number for the current
        worldsize?
        """,
        "You may like to use the julia function prod()",
        x -> x==2880
    ),
    Activity(
        """
        Recompile and run the method Schelling.demo(), and study the resulting dataframe. You
        should see the correct number of agents in the right-hand column. However, this column
        displays the number of agents who are comfortable, so at present, all of the agents are
        apparently comfortable. This is because they currently all belong to the same tribe (0).
        We must change this.

        Find the Learning activity for placing Persons of random tribe, and change the appropriate
        argument of add_agent_single!() to alternately assign half of the agents to tribe 0 and
        half to tribe 1. Compile Schelling.jl, run the method Schelling.demo(), and reply() me the
        number in the sum_comfort column of the resulting output table - it should normally lie
        within the range 30-80.
        """,
        "",
        x -> 30 < x < 80
    ),
    Activity(
        """
        Let's find out what is happening in our model. The world consists of 60*60 grid points, of
        which we fill 80% with Person agents - that makes a total of 0.8*60*60 = 2880 agents. If
        you look at the Schelling.demo() method, you see that the second line specifies the data
        we wish to collect from our simulation run:
            adata = [(:comfort, sum)]

        That is, the final column of our output table measures the sum of all comfort values of all
        agents in the world. After initialisation, all agents have the default value comfort=false,
        so the sum of all comfort values at time t=0 in our output table is zero (0). All agents
        are feeling uncomfortable, but only because we initialised them that way.

        Continuing, our table tells us that from time t=1 onwards, about 50 agents are feeling
        comfortable: their comfort value is true (1). What causes this to happen? The run!() call in
        the third line of demo() causes our model to take 9 steps into the future. Locate the
        agent_step!() method; this method tells each agent what to do on each step. reply() me the
        name of the argument representing the Person that is performing the current agent_step!().
        """,
        "",
        x -> x=="me"
    ),
    Activity(
        """
        Remember: the method agent_step!() describes what Every agent does on Every simulation step,
        so this method gets called 2880 times within each simulation step! What exactly does it do?

        The first loop of agent_step!() looks at the 8 agents in its 3*3 neighbourhood and counts
        how many of them belong to the same tribe as `me`. The proportion of those neighbours that
        belong to the same tribe as `me` is then calculated and stored in proportion_mytribe. If
        this proportion is greater than or equal to 1.0, the final assignment specifies that `me`
        feels comfortable.
        
        To understand the sum_comfort value between 30 and 80 in our output table, let's think about
        the value of proportion_mytribe for a typical agent. This value will equal 1.0 Only if all
        of me's neighbours belong to the same tribe, and in addition, NO members of the other tribe
        may sit in this neighbourhood. The probability of an agent of the same tribe being on any
        particular grid point is 0.8/2=0.4, and the probability of one of the other 7 points in a
        neighbourhood being empty is 1-0.8=0.2. So what is the probability that an agent has one
        member of her own tribe on a particular neighbouring grid point and the rest are empty?
        """,
        "The conjunction of independent probabilities is their product!",
        x -> 1e-6 < x < 1e-5
    ),
    Activity(
        """
        Since it doesn't matter which of the 8 neighbouring grid points contains the tribe member,
        the probability that Any one neighbouring point contains this member is 8 times your
        answer, which is about 4.1e-5. This means that on average, the number of agents with
        precisely one neighbour of the same tribe is 2880*4.1e-5=0.118.

        However, this is not the only way an agent can achieve proportion_mytribe=1.0 and so feel
        comfortable. Another possibility is that the agent has precisely 2 neighbours of the same
        tribe - or 3 or 4 or ... If we add up all these possibilities for all 2880 agents, we find
        that the average number of agents that will feel comfortable is about 50, which is close to
        the repeated value in the final column sum_comfort of your simulation output!

        This is the basic idea behind Schelling's Segregation model: agents feel comfortable when a
        certain preferred minimum proportion of their neighbours belong to the same tribe as
        themselves. Of course, our agents are currently Very conservative! They feel comfortable
        only if All of their neighbours belong to their own tribe, so it is not surprising that so
        few feel comfortable. Before we continue, reply() me Your personal preference: How low
        would the proportion of culturally/ethnically similar families in your neighbourhood need to
        be, before you started feeling uncomfortable? Keep a note of this proportion for later use!
        """,
        "Be honest: Very few people want to live in a completely unfamiliar culture!",
        x -> 0.0 <= x <= 1.0
    ),
    Activity(
        """
        At present, our agents feel uncomfortable, but do nothing to change this - that is why the
        sum_comfort values stay constant throughout our simulation. Generative Science shows us how
        to develop our model further by generating collective behaviour from agent interactions:
        1.  We start from a Research Question about the causes of some collective behaviour;
        2.  Our existing theories suggest a Research Hypothesis (HR) about how simple, local agent
            interactions might generate that collective behaviour;
        3.  We develop our HR into an Alternative Hypothesis (H1) that describes how we think
            Changes in agent interaction should influence Changes in collective behaviour;
        4.  We formulate a Null Hypothesis (H0) that Denies the influence proposed by H1;
        5.  We construct and perform an experiment to Disprove H0;
        6.  If the experiment successfully disproves H0, this justifies our belief in H1 and HR.

        What is the collective behaviour that we wish to understand in the Schelling ABM?
        """,
        "Which social behaviour did Thomas Schelling want to understand?",
        x -> occursin("segregat",lowercase(x))
    ),
    Activity(
        """
        GS plans out the schedule of Schelling's ABM work:
        1.  His research question: To what extent does cultural discomfort drive segregation?
        2.  HR: Agents generate segregation by relocating to reduce cultural discomfort;
        3.  H1: If HR is correct (that is, if discomfort-reduction causes segregation), then
            Decreasing agents' level of comfort should Increase their level of segregation.
        4.  H0: Decreasing agents' comfort level makes segregation decrease or stay constant.
        5.  Our model must allow agents to relocate on the basis of their preference for tribally
            similar neighbours, and we must be able to vary this individual preference and
            measure the corresponding level of segregation in the community.

        Item 2 specifies that agents can relocate on the basis of discomfort. Which field of Person
        will be the precondition for this relocation?
        """,
        "",
        x -> occursin("comfort",lowercase(string(x)))
    ),
    Activity(
        """
        Find the Learning activity in Schelling.agent_step!() where agents decide whether to
        relocate by jumping to a random empty grid location. Enable agents to jump if they are
        uncomfortable, by inserting a suitable if-clause containing the following function call:
            move_agent_single!( me, model)

        Before you recompile and re-run the demo() method, think for a moment: Do you expect that
        your code change will cause the sum_comfort values to increase over time?

        Now recompile and re-run the demo() method. Do your sum_comfort values increase over time?
        """,
        "",
        x -> occursin("no",lowercase(string(x)))
    ),
    Activity(
        """
        You can see that your relocation code is executing successfully, because the values of
        sum_comfort now change over time. However, they are not yet growing bigger - why not?!

        In agent_step!(), how many neighbours of the opposite tribe is the Person me prepared to
        accept, while still feeling comfortable?
        """,
        "",
        x -> x==0 || occursin("none",lowercase(string(x))) || occursin("zero",lowercase(string(x)))
    ),
    Activity(
        """
        Our GS-analysis showed that we need to be able to vary the preference level below which
        agents feel uncomfortable. At present, our agents require All their neighbours to be of the
        same tribe. If you study the code, you will see that demo() and schelling() both allow
        users of our simulation to set the value of preference - it's just that we do not yet pass
        this value through to agent_step!(). To achieve this, we must insert preference into
        our Schelling model as a Model Property...

        In schelling(), find the learning activity "define preference as a model property", and
        insert the following pair into properties::Dict:
            :preference => preference

        This defines :preference as a field in our model that stores the numerical value in the
        the argument preference of schelling(). Next, in the learning activity "decide how to
        react", replace the value 1.0 by the field model.preference. Now recompile and run
        demo(). Has anything changed in your output?
        """,
        "Don't worry if nothing has changed - I'm just checking!",
        x -> occursin("no",lowercase(string(x)))
    ),
    Activity(
        """
        Congratulations - your code changes have left your output unchanged! Yay! This is one of
        those cases where it is a Good Thing that nothing changes - it shows that you are
        successfully passing the default value 1.0 from the user through to the agents. Now comes
        the ultimate test: Do the values of sum_comfort grow over time if you enter the following
        call at the julia prompt?
            Schelling.demo(0.5)
        """,
        "",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Raising the value of preference makes it harder for agents to satisfy their preferred
        number of similar neighbours by relocating, since they become less comfortable with having
        several neighbours of the opposite tribe. In our model, we see that agents are successfully
        raising their comfort level by jumping. However, we do not yet know whether this relocation
        is leading to community segregation. Our task in the next laboratory will be to find ways
        of visualising segregation and so testing our research hypothesis.

        See you in the next lab! :)
        """,
        "",
        x -> true
    ),
]
