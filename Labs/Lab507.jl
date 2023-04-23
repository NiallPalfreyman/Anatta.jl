#========================================================================================#
#	Laboratory 507
#
# Differential adhesion.
#
# Author: Niall Palfreyman (March 2023).
#========================================================================================#
[
    Activity(
        """
        Welcome to Lab 507: Differential Adhesion.

        In this laboratory, we implement Stuart Newman and Gerd Müller's Differential Adhesion
        Hypothesis (DAH), according to which the entire process of morphogenesis (that is, organism
        development) is guided by proteins of varying 'stickiness' on the surface of the cells of
        the developing organism. These proteins are called "cadherins". As the cells rattle around
        due to thermal motion, adhesion between the cadherins causes the cells to organise
        themselves into the spatial forms that make up the organism's body.

        Run DifferentialAdhesion now and observe carefully what happens.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        As you see, these cells organise themselves according to their 'stickiness' to each other.
        Experiment now with the various parameters. What effect do thermal motion, adhesion_range
        and gravity have on the cell patterns you observe?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now try increasing the number of adherin classes. Do the cells organise themselves into
        neat layers around the centre of a cluster?
        """,
        "",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        To be honest, I think my implementation of the stickiness() method is pretty rubbish. Can
        you do better? Find a way of combining the adherin classes (1:8) that organises the cells
        more cleanly into layers.
        """,
        "",
        x -> true
    ),
]