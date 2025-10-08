#========================================================================================#
#	Laboratory 304: Complex behaviour
#
# Author: Niall Palfreyman, February 2025.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 304:
            Complex behaviour - Biological behaviour is non-computable, but Reliable!

        To summarise our discoveries so far in this course: We have reason to believe that
        biological systems are collectively embodied and non-computable. That is, their behaviour
        arises from interactions between many individuals, and generates patterns that computers
        cannot calculate, but might be able to approximate. We will measure the success of our
        computational experiments by Pattern-Fitting; that is, we will generate structural patterns
        experimentally, then measure how well they 'fit' with observed biological patterns in
        nature. By doing this, we will investigate the meaning of the interrelated terms:
            Supervenience, Complexity and Emergence ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        When we think about living beings, we often think of them as having a 'soul' or 'identity'.
        But what is a soul? Is it a ghostly substance that floats around inside us? Or is it a
        kind of 'life force' that animates us? Or is it something else entirely? In this course,
        we explore the idea that soul and identity are not ghostly substances, but a behavioural
        organisation that emerges from the interactions of the many cells in our bodies.
        
        This idea is not new; the philosophers Arthur Schopenhauer, Gilbert Ryle and Daniel Dennett
        all suggested that soul is not a 'thing' that we have, but instead a 'thing' that we are.
        The important underlying idea is that the behavioural identity of a living organism
        Supervenes on the physical structure of its body; that is, we cannot compute the identity
        from the body, but if two bodies are identical, then their identities must also be
        identical. In this case, we say that the behavioural identity Emerges from the organism's
        physical structure.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Supervenience and Emergence are closely related to the concept of Complexity. Complexity is
        the ability of a system to generate collective, non-computable behaviour that is Reliable -
        that is, the behaviour Always arises from some family of structures, even though the way in
        which this behaviour arises may be different each time it happes. The complex system
        achieves this reliability by selectively constraining the behaviours of its own component
        agents.
        
        You may find these ideas of supervenience, emergence and complexity difficult to grasp, so
        we will explore them in this lab using Craig Reynold's (1986) famous Boids model. The Boids
        model was first used in cinema to simulate the movement of a stampeding herd of dinosaurs in
        the film "Jurassic Park". This stampede was not created by animating each dinosaur
        individually, but by simulating the collective behaviour of a flock of dinosaurs. The
        stampeding behaviour supervenes on individual dinosaurs' behaviour, since it is collectively
        non-computable, yet is a reliable product of the herd's structure.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Let's test the Boids model. Load and run the module Boids(.jl), then press the Run button
        in the ABM playground. You will see a collection of boids moving around the screen. After
        the simulation has run for a while, how many flocking groups emerge from the boids' motion?
        """,
        "",
        x -> x==1 || occursin("one",lowercase(x)) || occursin("1",lowercase(x))
    ),
    Activity(
        """
        The Boids model attempts to mimic the flocking behaviour of birds. This motion also closely
        resembles that of shoals of fish, herds of buffalo and swarms of bees. The flocks that
        emerge from the model are not created or guided by any particular leader bird. Rather, the
        flocking emerges from boids that follow exactly the same set of three simple rules of
        Cohesion, Alignment and Separation. All boids continually adjust their velocity to ...
            ... move toward the average Position of neighbouring boids (Cohesion);
            ... align with the Velocity of neighbouring boids (Alignment);
            ... move away from neighbouring boids that are dangerously close (Separation).
        
        When two boids are too close, the Separation rule overrides the other two rules, which are
        deactivated until the minimum separation is attained. To observe these rules in action, set
        the sleep slider to 0.01, press reset, then run the model again. Notice how the boids first
        form subgroups, which then merge into larger flocks.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Change min_separation to its MAXimum value and press <reset model>, then run (or step
        through - whichever you prefer) the the model again. Can you see any small clusters of boids
        forming now?
        """,
        "You should actually observe boids bouncing abruptly away from each other!",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Now set min_separation to its MINimum value and press reset, followed by run. You can stop
        the simulation at any time by pressing run again. Notice how this very low value of
        min_separation leads to the formation of rigid files of boids. Find the minimum value of
        min_separation that avoids this strict regimentation, and instead forms a more fluid flock
        resembling a migrating flock of Canada geese.
        """,
        "",
        x -> abs(x-4)<1
    ),
    Activity(
        """
        The tight flocking formation of Canada geese is an aerodynamically efficient way to fly long
        distances. The geese take turns leading the flock, with the leader falling back when it gets
        tired. This way, the flock can fly long distances without any one bird getting too tired. on
        the other hand, the flocking behaviour of crows is more fluid and independent, with
        individuals constantly moving away from the flock then returning to it. This behaviour is
        helpful when scouting for nesting and feeding possibilities. Which value of min_separation
        do you think best converges toward the flocking behaviour of crows?
        """,
        "",
        x -> abs(x-4.75)<0.5
    ),
    Activity(
        """
        The flocking behaviour of starlings is different again, with the relative positions of
        individual birds constantly changing within the flock. This wild, yet coordinated flocking
        behaviour of starlings is called Murmuration, and is thought to confuse predators, making
        it difficult for them to target any individual starling or herring.

        Murmuration is characterised by high separation, yet with high cohesion. Set min_separation
        to the high value 7.5, then adjust the cohesion_weight slider to find a value that best
        binds the boids together in a fluid flock. What value of cohesion_weight do you think best
        binds boids together into the flocking behaviour of starlings?
        """,
        "",
        x -> x>0.7
    ),
    Activity(
        """
        Reynolds' rules for flocking are implemented in the method agent_step!() in the Boids
        module. Study this method now, and notice that it contains no randomness at all - the
        Boids model uses random numbers Only to determine the initial position of the boids. The
        fluid, lifelike behaviour of the boids is produced entirely by deterministic rules. Yet if
        we performed two different runs of the model using two veeery slightly different starting
        positions, we would find that the behaviour of the two models would diverge exponentially
        rapidly. The boids' motion is therefore non-computable, yet if we ran the model twice with
        the same initial conditions, we would find that the behaviour of the two models would be
        absolutely identical.
        
        The dynamical behaviour of the Boids model therefore Supervenes on its initial structural
        conditions, and indeed, the collective flocking behaviour Emerges non-computably from the
        boids' individual interactions. Since this collective, non-computable behaviour is also
        reliable, we describe it as being Complex.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Let's now investigate the individual parameters of Reynolds' rules. Set min_separation to
        its highest value, to keep the flocks open, then set cohesion_weight to its highest value,
        while setting cohesion_weight, alignment_weight and separation_weight all at their lowest
        value. If you run the model, you will see that the boids simply fly in random directions.
        This isn't really surprising, but now raise cohesion_weight to its highest value of 1.0,
        reset and re-run the simulation. This should cause the boids to form a single flock. Is
        this what you observe?
        """,
        "",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Remember Reynolds' movement rule that cohesion and alignment are both switched off when the
        separation between boids is too low. This means that cohesive motion has no chance to
        occur. Now set min_separation to the lower value of 5.0 and run the model again. Do you now
        observe flocking groups forming?
        """,
        "",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        OK, now set cohesion_weight to its lowest value, and alignment_weight to its highest value.
        Reset and run the model again. Do you observe the boids forming a single group?
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        Alignment causes the flight direction of the boids to become correlated, but without a
        cohesive rule, they do not cohere into a single group. Now raise cohesion_weight just a
        little to 0.05. This is just sufficient to bring the boids together into a single train.
        Flamingos sometimes fly like this. If you now reduce alignment_weight to 0, the linear
        structure of groups will break up into a more fluid organisation. Try this out.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Before we complete this lab, I want to draw your attention to two important points:
            1. Although we can describe the flocking patterns in the Boids model by relations such
                as 'tight', 'fluid' or 'open', these patterns are Not static structures. Rather,
                they are reliable aspects of the dynamical organisation between boids' motion.
            2. This reliable dynamical organisation emerges from what is called Self-Organisation:
                the emergence of collective order from the interactions of many individual agents.
                I want you to notice that this self-organisation is only made possible by the fact
                that the behaviour of each agent is constrained by the behaviour of several
                neighbours. This is a general principle of complex systems.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now extend my Boids model to answer the following research question:
            Currently, boids can see and react to neighbours in all directions around them. What
            would happen if they could only see neighbours that lie in front of them - whether
            directly ahead of them or slightly to the left or right?

        To answer this question ...
            - Formulate a research hypothesis that predicts how the flocking behaviour of boids
              would change if they could only see neighbours in front of them;
            - Formulate a null hypothesis that predicts no change in the flocking behaviour of boids
              if they could only see neighbours in front of them;
            - Implement this hypothesis by filtering the collection neighbour_ids in agent_step!().
        """,
        "",
        x -> true
    ),
]