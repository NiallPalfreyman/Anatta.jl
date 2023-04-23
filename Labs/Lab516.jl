#========================================================================================#
#	Laboratory 516
#
# Cooperative problem-solving
#
# Author: Niall Palfreyman (April 2023).
#========================================================================================#
[
    Activity(
        """
        Welcome to Lab 516: Recruiting groups for cooperative problem-solving

        Over the past 60 years there has been an important debate in evolutionary biology: are
        genes the only central structures of inheritance? Remember that ant colonies construct
        the flows in their environment in order to solve problems, and we have seen that these
        flows can lock into stable structures like Turing patterns or termite mounds that are
        passed on and used by the entire colony over generations. Is this not a kind of "group
        inheritance"?

        Come to think of it, isn't your body a kind of inheritance structure that is passed on
        through generations of an entire colony of cells and used to support their survival?

        In this lab, we shall look only briefly at this question, since it is such a complex issue,
        but it is of great importance to the question of how organisms solve problems. Just stop
        and think about it for a moment: How many examples of structures and resources can you
        think of, that are constructed and used by a GROUP of organisms?
        """,
        "You needn't answer this question - just discuss it with others it for a while",
        x -> true
    ),
    Activity(
        """
        Problems do not exist in the physical world: they are created by organisms. Problems
        arise when an organism is faced with the issue of survival: Which decision will help me
        survive better in this particular environment? So problem-solving is automatically tied
        to selection, and so group problem-solving is automatically tied to "group selection".

        When does it make sense to speak of a 'group' of individuals solving a problem, surviving
        as a group and so being selected as a group?
        
        This is the biological problem of Group Selection - also known as the problem of Atruism
        or Cooperation: When is my attempt to saved your life true cooperation, and when is it just
        the result of my individual "genetic programming"?
        """,
        "Again, you don't need to answer this - just think about how difficult the question is",
        x -> true
    ),
    Activity(
        """
        The problem of cooperation is this: It is always easier to solve a problem with the help of
        others, but this carries a price: you also need to put aside your own needs:
            -	A viral gene that finds a way of replicating faster may make the virus so deadly
                that it can no longer spread effectively through a population of hosts.
            -	A cell that replicates faster may turn into a cancer that damages the entire body.
            -	Villagers sharing a meadow may take just a little too much grass for their own
                goat, so that the entire meadow collapses and the whole village starves.
            -	Humans sharing a planet may each individually drive their car a little more than is
                necessary, so that the entire planet suffers from catastrophic climate change.

        The problem of cooperation is that we must both take responsibility for a common resource,
        and for any others that play a part in maintaining that resource into the future. That is:
            Cooperation ALWAYS involves a conflict of interest between individuals and groups!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        So problems are always linked to survival. So in order to think about problem-solving, we
        must therefore think about selection; and in order to think about cooperative problem-
        solving, we must always think about how selection operates at multiple levels. How does
        this behaviour affect the individual AND the group on which that individual depends?
        
        These issues are addressed in the module MultiLevel. Run its demo simulation now. How many
        green agents (Cooperators) are left after 200 generations or so?
        """,
        "",
        x -> x==0
    ),
    Activity(
        """
        In the MultiLevel demonstration, Cooperators and Defectors live together in a world in
        which Cooperators create a resource in their neighbourhood that contributes to solving the
        problem of survival. Notice that one Cooperator cannot survive by itself - it requires a
        group to contribute to their communal survival resource. Also, each Cooperator pays a
        fitness cost for having to do the work of producing this resource.

        Defectors also need the resource to survive, but they do not produce it themselves.
        Instead, they survive on the resource produced by any Cooperators in their neighbourhood,
        and so avoid paying the cost of producing the resource themselves.

        Notice how Defectors only increase so long as there are Cooperators to produce the resource
        for them - as soon as the Cooperators disappear, the Defectors stagnate at a level around
        1200. At this stage, Defectors are only living off their inherited birth fitness defined
        in agent_step!. What is this default fitness of every agent?
        """,
        "",
        x -> x==0.1
    ),
    Activity(
        """
        Now do the following. Move the slider prob_birth down from 1.0 to 0.8. This makes it
        significantly (20%) harder for new agents (whether Cooperators or Defectors) to be born.
        Which population type now survives best?
        """,
        "",
        x -> occursin("coop",lowercase(x))
    ),
    Activity(
        """
        This is really interesting! By making survival harder for BOTH population types, we force
        them into dependence on each other: They MUST cooperate in order to survive. The lesson
        seems to be that although access to a common resource combines agents into co-dependent
        neighbourhoods, it is LIMITED access to this resource that forces the agents to seek
        ways of cooperating with each other.
        
        You can get an idea of how this works if you again set up the demonstration with
        prob_birth==0.8, and then step slowly through it. You will notice that the blue Defectors
        quickly die off. Which Defectors last longest: those near to Cooperators or those far from
        Cooperators?
        """,
        "",
        x -> occursin("near",lowercase(x))
    ),
    Activity(
        """
        It is the ability to use the resources produced by Cooperators that enables agents to
        survive. Now keep stepping through the demonstration and watch how the Cooperators develop
        after the Defectors have disappeared. Where are new Cooperators born: near to other
        Cooperators or far from existing Cooperators?
        """,
        "",
        x -> occursin("near",lowercase(x))
    ),
    Activity(
        """
        This means that Cooperators first build their density, and then slowly grow out from their
        borders to fill the entire space. Also notice that the Cooperators are able to utilise the
        space far more effectively than the Defectors, who stagnated at a population of around
        1200. At which population size are the Cooperators approximately stable?
        """,
        "",
        x -> 1500 < x < 2000
    ),
    Activity(
        """
        Now set the prob_birth slider to 0.92 and either start or step through a new run. Here, the
        Cooperators are able to survive the work of the Defectors by consolidating themselves into
        dense clumps. Whenever Defectors penetrate the borders of a clump, the Cooperators simply
        die off at that point and consolidate elsewhere. This seems to be the means by which groups
        form, survive and solve problems: they form local cells that are relatively isolated from
        the predations of the external environment.

        That is in fact the basis of the research project for this course. In that project, you
        will investigate how to train agents to gather together to solve parts of a wider problem,
        and the way they do that is by using flows as a common resource.

        And that is the end of the content for this course! :)
        """,
        "",
        x -> true
    ),
]