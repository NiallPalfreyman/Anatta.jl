#========================================================================================#
#	Laboratory 602
#
# Computability.
#
# Author: Niall Palfreyman (February 2023), Nick Diercksen (July 2022)
#========================================================================================#
[
    Activity(
        """
        Welcome to Lab 602: (Non-)Computable patterns.

        "Reductionism" is the belief that we can always understand system-level behaviours by
        reducing them to individual component behaviours, but this is certainly not always possible,
        as we saw in the previous lab. For example, we cannot reduce the collective oscillations of
        the Ecosystem model to the behaviour of individual agents, since they are determined by the
        entire system. Nevertheless, reductionists may still argue that we can reduce the Ecosystem
        oscillations to the structure of relationships _between_ individual agents.

        This argument assumes that we can always compute the effects of agents' relationships and
        behaviours. However, there exists a whole class of patterns that we can generate, yet can
        never predict using computation. In this lab, we will demonstrate this important feature of
        NON-COMPUTABILITY.
        
        Non-computable patterns are not collective, since they can be generated by a very simple
        system containing just one agent. However, non-computable patterns can arise reliably out
        of an agent's random behaviour, yet we can never predict the pattern simply by knowing that
        agent's behaviour. This has to do with the limits of computability ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Include the file Computability.jl. At each step of Computability.demo(), the single agent
        in the model chooses at random one of the three available food sources (the red vertices),
        then moves halfway towards it. To see what happens, press the Step button several times -
        you will see that the agent jumps around, and wherever it lands, it leaves behind a tiny
        (1pt) black footprint. Keep stepping the agent until you notice that these footprints are
        forming a pattern. Do you know the name of the non-computable figure that this pattern
        approximates?
        """,
        "If you're unsure, just keep stepping through the simulation :)",
        x -> occursin("sierpinsk",lowercase(x))
    ),
    Activity(
        """
        Now you know the structure of this pattern, press the Run button to watch it being
        generated at speed. You might also like to move the "spu" slider all the way to the right
        to make things go a bit faster.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now press the Reset button to randomise the simulation, and then Run the simulation from a
        new starting position. What might be a good reference mode for this model?
        """,
        "",
        x -> occursin("sierpinsk",lowercase(x))
    ),
    Activity(
        """
        Experiment with the various sliders, changing the number of particles, vertices and the
        contraction factor r. What exactly does r do? Study the method agent_step!() to answer the
        question: Which aspect of the particle's movement does r influence?
        """,
        "", 
        x -> occursin("distance",lowercase(x))
    ),
    Activity(
        """
        I now have a few questions - very important ones - about the patterns you have been
        generating. Set r=0.5 again to recover the original pattern, maximise the playground window
        and generate lots of points to see the pattern in the greatest possible detail.

        Now consider first the point in the centre of the pattern. Do you think the particles can
        ever in principle visit this point?
        """,
        "", 
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        How long do you think it would take to prove your answer to the previous activity?
        """,
        "", 
        x -> occursin("forever",lowercase(x)) || occursin("infinit",lowercase(x))
    ),
    Activity(
        """
        Now focus your attention on one of the tiniest triangles in your pattern, and pick a point
        at the centre of this tiny triangle. Do you think the particles can ever in principle visit
        this point?
        """,
        "", 
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Do you think it would take longer or shorter to prove your answer for the tiny triangle,
        than it would take to prove your answer for the point at the centre of the whole pattern?
        """,
        "", 
        x -> occursin("longer",lowercase(x))
    ),
    Activity(
        """
        Now focus your attention on one of the dark areas between the triangles in your pattern.
        Imagine a point somewhere within that dark area. Do you think the particles can ever in
        principle visit that point?
        """,
        "", 
        x -> occursin("dunno",lowercase(x)) || occursin("know",lowercase(x))
    ),
    Activity(
        """
        How long do you think it might take a computer to verify your answer to the previous
        activity?
        """,
        "", 
        x -> occursin("infinit",lowercase(x))
    ),
    Activity(
        """
        The Sierpinski triangle is an example of a NON-COMPUTABLE figure. The agents' motion
        generates a structural pattern that suggests certain properties like whether or not any
        given point lies within that figure. Yet it can take an infinitely long time for a
        computer to verify that suggestion!

        Notice this important difference: You and I see an infinite sequence of nested triangles;
        a computer, however, sees only a set of points with different distances between them. At
        best, the computer sees an algorithm for generating new points.

        Clearly, we are able to do something that a computer can't!
        """,
        "", 
        x -> true
    ),
    Activity(
        """
        Before proceeding further with this lab, I want to draw your attention to a small coding
        issue. Look at the graphics code in Computability.demo(). After setting up the playground,
        we want to superimpose onto the basic abmplot all the footprints of each agent in the
        model. To achieve this, we "lift" (i.e., add a listener to) the abmplot Observable, so that
        every time the abmplot changes (for example, after each call to model_step!()), we can plot
        the new agent footprints.

        It's a pity that we have to concern ourselves here with these messy graphics details, and I
        promise that in future implementations, I will make this all a little easier. However, for
        the moment, just notice how we solved this particular problem - it might be useful later
        for your own course project. :)
        
        What is the name of the other variable that is plotted in exactly the same way?
        """,
        "",
        x -> occursin("corners",lowercase(x))
    ),
    Activity(
        """
        Now create your own demonstration of a non-computable reference pattern by renaming the
        module Computability into a new file Leafy.jl, then modifying its code to construct another
        non-computable figure. To do this, create a 2-D continuous world with extent 10x10, define
        a model property :base_point=>[5.0,0.0], and initialise all particles in the Leafy model
        at this base_point location.
        
        Next, modify the method Leafy.agent_step!() to implement the following movement rule for
        particles: At each step, move the particle as shown below with the associated probabilities,
        where (x,y) are the particle's current position coordinates _relative_ to leafy.base_point:
                - 85%:				(x,y) -> (0.85x+0.04y, -0.04x+0.85y+1.6);
                - 7%:				(x,y) -> (0.20x-0.26y, 0.23x+0.22y+1.6);
                - 7%:				(x,y) -> (-0.15x+0.28y, 0.26x+0.24y+0.44);
                - Otherwise (1%):	(x,y) -> (0, 0.16y).
        """,
        "Reference mode: The graphical footprints should remind you of a kind of leaf",
        x -> true
    ),
    Activity(
        """
        OK, now the following point is very important for developing your own course project later:
        Notice how easily you can check whether your program is working correctly, by simply seeing
        whether it generates a leaf-like pattern. I have not drawn you a leaf or told you what the
        leaf should look like, but you will immediately know when your program works because it
        will produce a leaf-like pattern. This way of checking program correctness against an
        output pattern is called "pattern-oriented modelling":
            The reference modes of Agent-Based Modelling are PATTERNS!

        What pattern formed the reference mode of the Ecosystem model?
        """,
        "", 
        x -> occursin("sustain",lowercase(x))
    ),
    Activity(
        """
        When your program is satisfying its reference mode, investigate the 'magic parameters' in the
        generating procedure by setting up sliders to change their values. Discuss with your partners
        the meaning of the various parameters for the developing leaf pattern.
        """,
        "", 
        x -> true
    ),
    Activity(
        """
        Computability is very closely related to the term Incompleteness in logic. In 1931, Kurt
        Gödel proved that mathematical logic is 'incomplete' in the sense that there are
        mathematical truths that we can never prove, but must simply decide for ourselves - like
        for example the idea that two parallel lines never meet. We cannot prove this, but we can
        state it as an axiom of Euclidean geometry.

        Similarly, we have discovered in this lab that computation is incomplete in the sense that
        there are certain geometrical figures whose properties we can never compute, but must
        decide for ourselves - like for example whether a certain point is, or is not, contained in
        the edge of your leaf. We cannot compute this, but we can state it as an axiom that we must
        then confirm or disconfirm by experiment.

        And that is what we shall do in this course: We shall use ABM to discover how the emergent
        figures of biology are generated. We have good reason to suspect that these figures are
        non-computable, but maybe we can use ABM to compute patterns that are sufficiently close
        that we can guess the biological dynamics underlying those figures.

        But, of course, we still haven't said what exactly "emergence" is ... :)
        """,
        "", 
        x -> true
    ),
]