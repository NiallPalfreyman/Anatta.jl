#========================================================================================#
#	Laboratory 515
#
# An efficient algorithmic implementation of Turing systems.
#
# Author: Niall Palfreyman (April 2023).
#========================================================================================#
[
    Activity(
        """
        Welcome to Lab 515: Efficient algorithmic implementation of a Turing system

        Nature has one enormous advantage over computers: time is continuous, and the number of
        particles is huge. This means that when proteins diffuse and react in a Turing system,
        they explore every little corner of the space of possible results of their activity.

        When we simulate such systems on a computer, we can only approximate their continuous
        behaviour, and must always wonder whether we have missed a possibility along the way.
        Think of changing the sliders for evaporation and diffusion in the Turing model. Did
        you ever find that you had missed a useful value because you had jumped past it? In
        real systems, Nature tries all the values along the way, and so is more likely to find
        a solution.

        Of course, the answer is to make the time-step dt in our simulations very small, but then
        we quickly find that our simulation runs extremely slowly! For this reason, it is often
        useful to replace continuous dynamics by a structural algorithm that approximates the
        continuous system's behaviour sufficiently well ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The ideas in this lab were developed by Uri Wilensky:
            http://ccl.northwestern.edu/netlogo/models/Fur
                
        We shall speed up our Turing simulation by directly calculating values that are only
        approximate, yet are 'good enough' to help us model the system efficiently.

        Usually, we cannot calculate systems' time-development accurately, and have to simulate
        them numerically instead. However, sometimes we can use this numerical simulation to
        understand more about how the system works, and then replace the continuous development
        by a formula that approximates its dynamics. Once we understand how activators and
        inhibitors interact with each other to produce Turing patterns, we can calculate their
        behaviour approximately using two rings of activation and inhibition around each patch.
        
        Run the StructuralTuring simulation now. Just look at how much bigger this world is, and
        how quickly it develops over time.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Again, we are looking for the dynamical mechanisms underlying such periodic patterns as a
        zebra's stripes, a leopard's spots or the repeating vertebrae along a primate's spine. If
        Turing's idea is correct, the rules underlying the development of such biological patterns
        are similar across species, and only the parameters are different.

        This brings us back to the idea of EXPLORATORY PROCESSES, and helps us to understand how
        Darwinian variation of these patterns might occur over evolutionary time. Remember that
        West-Eberhard's idea of phenotypic plasticity suggests that offspring do not inherit the
        patterns of their parents, but instead only the rules and numerical values that generate
        those patterns. The outcome of these developmental processes then depends upon chance
        circumstances of the cell or organism's developmental environment.

        We will model an animal's skin by a square array of many melanocytes (pigment cells) that
        vary between two states: 0 (undifferentiated) and 1 (differentiated/colourful). A cell's
        state can vary continuously between these two values. The differentiated cells secrete two
        types of morphogen: activator and inhibitor. Activator diffuses outwards from a central
        differentiated cell, creating a kind of puddle, while inhibitor diffuses more quickly to
        form a ring around that puddle. Which method defines the x- and y-radii of these features?
        """,
        "",
        x -> x=="structural_turing"
    ),
    Activity(
        """
        The activator morphogen influences cells at the centre of this 'puddle' to differentiate
        and become colourful; inhibitors in the surrounding ring tend to prevent the central cell
        from differentiating. In order to accelerate the calculation of these activatory and
        inhibitory influences, structural_turing() stores, for each cell in the flow matrix
        `differentiated`, a Vector list of `activators` (neighbouring cells in the puddle) and
        `inhibitors` (neighbouring cells in the outer ring). What is the name of the set operation
        in julia that structural_turing() uses to calculate the cells in this ring?
        """,
        "",
        x -> x=="setdiff"
    ),
    Activity(
        """
        Now let's investigate the method nearby_patches(), which calculates the cells in an ellipse
        around the central cell with x- and y-radii given by r==(rx,ry). Notice particularly how it
        first uses comprehension to build a list (nbhd) of the subscripts in an ellipse around
        (0,0). What julia keyword do I use to constrain this comprehension only to those cells that
        lie within an ellipse with radii r[1] and r[2]?
        """,
        "",
        x -> x=="if"
    ),
    Activity(
        """
        Next, nearby_patches() eliminates the point (0,0) from this neighbourhood using the in-place
        method call setdiff!(nbhd,[(0,0)]). Notice the square brackets [] around the element to be
        removed. Use the julia console to explore why I can write
            a = [1,3,4,5,7]
            setdiff!(a,5)

        but this does not work if I write
            b = [(1,2),(3,4),(5,6)]
            setdiff!(b,(3,4))

        What value(s) does this call attempt to remove from b?
        """,
        "",
        x -> x in [3,4]
    ),
    Activity(
        """
        Look at the following line towards the end of nearby_patches():
            LinearIndices((w->1:w).(ext))

        Use the julia console to investigate the purpose and structure of this calculation by
        creating linear indices for the extent (3,4). What is the linear index of the Cartesian
        location (1,3)?
        """,
        "",
        x -> x==7
    ),
    Activity(
        """
        Now comes Wilensky'e cunning trick: Every cell, whether differentiated or not, is at the
        centre of its own neighbourhood - suppose for now that this is a circle with radius 3 cells
        (r[1]==r[2]==3). This means that this centre cell is influenced by other cells that are as
        far away from it as 3 cells in any direction. So if there is a differentiated cell anywhere
        within this circle, it will secrete activator morphogen that diffuses as far as the centre
        cell, whereas a cell 4 cells away would not directly affect the centre cell.

        Also, each cell also has an outer ring of radius, say, 5 cells. Differentiated cells in this
        outer ring contribute inhibitor morphogens to the central cell. So at each moment, every
        cell is influenced by both activator and inhibitor cells in its neighbourhood, and the
        decision as to whether that cell will differentiate dependes upon all of these neighbours.
        Wilensky's logic is that if the influence of the activator neighbours is greater than the
        influence of the inhibitor neighbours, the cell will become differentiated; otherwise not.
        
        Since the "influence" of activators and inhibitors depends on many factors such as their
        density and distance from the centre cell, the simplest way to calculate their total
        influence is to count each activator as having influence 1, and each inhibitor as having
        influence `inhibition`. What is the name of the method in which all these influences are
        combined into a decision about whether to differentiate each cell?
        """,
        "",
        x -> x=="model_step!"
    ),
    Activity(
        """
        A Convex Combination of several numbers is a linear combination in which the coefficients
        all add up to 1.0. We use convex combinations to find values lying along a line between
        two points. For example, in the following convex combination, each value of the convex
        parameter alpha describes a value between 3 and 7 in which alpha==0 corresponds to the
        value 3, and alpha==1 corresponds to the value 7:
            (1-alpha)*3 + alpha*7

        In the second half of the for-loop in model_step!(), I use two convex combinations. The
        first uses st.dt to parameterise a lowering of st.differentiation[i] towards the value zero:
            st.differentiation[i] = (1-st.dt)*st.differentiation[i] + st.dt*0

        The second convex combination combines this with a second change:
            st.differentiation[i] = st.differentiation[i] + st.dt

        in which st.dt parameterises a raising of st.differentiation[i] towards which value?
        """,
        "",
        x -> x==1.0
    ),
    Activity(
        """
        The above explanations assume circular neighbourhoods. To see circular neighbourhoods in
        action, set the two inner radii (inner_radius_x and inner_radius_y) to 3.0 and the two
        outer radii to 6.0. Since the differentiation state of all cells update simultaneously, it
        may be that the activation and inhibition counts for a particular cell may swing up and
        down, causing some cells to drift first towards black and then towards white, or
        vice-versa. Run the StructuralTuring.demo() method again with circular neighbourhoods and
        watch how the pattern forms. Notice particularly these drifting dynamics that are typical
        of pattern-formation in living systems.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice how unstable the patterns are with respect to changes in the parameters. For
        example, while holding everything else constant, slowly change the value of `inhibition`
        in steps upwards from about 0.2 to 0.6 (being sure to press reset between runs). At low
        values you will get a totally white field, and at high values totally black. Why is this?
        What will be the inhibitory effect of the outer ring when `inhibition` is zero?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        It is important that you remember this instability of Turing systems. If you decide to use
        this mechanism in your course project, you will find you need to constrain the values of
        the Turing parameters very strongly to avoid your program getting stuck in suboptima.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The dynamics of cell differentiation is very similar to voting models in the social
        sciences, where people's votes for a particular party can influence other voters. Of
        course, one difference is that usually we can vote for several different parties - not
        just two. Can you introduce another colour into the StructuralTuring model? You will
        need to think carefully about the rules that define how different colours interact with
        each other.
        """,
        "",
        x -> true
    ),
]