#========================================================================================#
#	Laboratory 10
#
# Data visualisation and concrete data types
#
# Author: Niall Palfreyman, 06/09/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 010: Visualising data graphically

        In this laboratory we learn how to use Julia's Makie plotting package to create graphical
        displays for data visualisation. Makie is the front-end for several different backend
        graphics packages - for example, Cairo, GL and WebGL. We shall focus here on GLMakie,
        which we now load with the following command:
            using GLMakie

        Be forewarned that the first time you do this, it may take a while, since GLMakie is quite
        a large library ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        julia uses Just-in-Time (JiT) compilation, so the first time you call a graphics method, it
        will always take longer than later calls. Enter the following command (being sure to
        include the semicolon at the end!), then tell me the type of the return value fig:
            fig = scatterlines( 0:10, (0:10).^2);
        """,
        "Enter the command exactly as I have done here",
        x -> x==Main.Makie.FigureAxisPlot
    ),
    Activity(
        """
        This type description tells us that fig contains a graphics object; the only reason you can't
        see this object is because of that semicolon you included. As always, a semicolon at the end
        of a function call prevents the function's value being returned from the function-call.

        A Makie plotting command such as scatterlines() creates three things: a Plot object such as
        a curve or a text box; the Axis system inside which Makie draws the various Plot objects;
        and a displayable Figure that contains one or more Axis systems. When we display our
        Figure, it already contains one or more Axis systems, and one of these Axis systems
        contains our scatterlines Plot.

        Let's study this internal structure a little - reply() me the fieldnames of the Figure
        structure `fig`:
            fieldnames(typeof(fig))
        """,
        "",
        x -> x == (:figure,:axis,:plot)
    ),
    Activity(
        """
        Now we know about the structure of Figures, let's display our figure in graphical form.
        Simply ask the julia prompt to display the value of fig:
            fig

        Doesn't it look pretty? :) What is the return type of the graphic you have just displayed?
        """,
        "typeof(ans)",
        x -> x <: Main.Makie.FigureAxisPlot
    ),
    Activity(
        """
        Our figure is still a little primitive - let's customise its attributes. First capture
        the three different fields contained in fig, so that we can manipulate them for ourselves:
            fg,ax,plt = fig;

        Every plot object (curve, text, etc.) has a whole bunch of attributes that we can adjust,
        like colour, thickness, dotted line, and so on. Check out the `attributes` field of plt to
        find out how many different attributes it has:
        """,
        "",
        x -> x >= 14
    ),
    Activity(
        """
        We can inspect the available plot attributes by pressing the '?' character. Try:
            ? scatterlines

        As you see, scatterlines shares many attributes with the lines() command (a scatterline is
        a line with marker points scattered along it), so we can get even more information by
        looking up help on lines:
            ? lines

        Which attribute would you change if you wanted your graph curve to be a dotted line:
        """,
        "Study the list of attributes in help",
        x -> x=="linestyle"
    ),
    Activity(
        """
        Now we'll use this information on line attributes to replot our curve. Try entering this:
            fig = scatterlines(0:10,(0:10).^2,color=:red)

        Now replot this graph using a line with thickness 9-point, then tell me exactly which value
        you needed to assign to the relevant attribute in order to do this:
        """,
        "The important point here is that numbers are already symbols, so you don't need the colon",
        x -> x==9
    ),
    Activity(
        """
        It might be useful to save our curve to a picture file, but to do this, we first need to
        check out the filesystem. Enter the Present Working Directory command:
            pwd()

        In the chapter "Filesystem" of the Julia user manual you will find many other functions for
        exploring the filesystem. If you are not currently in your Anatta home folder, move there
        now by entering home(). You may also choose to create a new subfolder named "Graphics" in
        which to save your wonderful pictures. In this case, enter:
            mkdir("Graphics")
            cd("Graphics")

        Now we are ready to save our Makie figure. Enter the following command, go and look at the
        resulting file using Adobe Acrobat, then come back here and tell me the highest number on
        the vertical axis:
            save("myfig.jpg", fig)
        """,
        "",
        x -> x==100
    ),
    Activity(
        """
        OK, now let's get fancy. We don't always want the scatter points on our plot, so we'll try
        out the lines() function. Also, it would be nice to plot something a little more exciting,
        like maybe the Hill kinetics that I have implemented in the file FunGraphics.jl in the
        Computation folder. Hill kinetics are a generalisation of the Michaelis-Menten reaction
        kinetics used in bioreactor engineering. Hill kinetics describe the effect of a catalyst on
        a chemical reaction - in particular, they model the activation or inhibition of DNA
        expression in biological cells by a transcription factor (tf).

        In VSC, open FunGraphics.jl and take a look at the overall structure of the file. I highly
        recommend that you use this file as a model for all modules you write in the future. You
        can see that it contains three basic items:
            -   a public (i.e., exported) data type HillTF, which stores all information needed to
                calculate the catalytic effect of a range of transcription factor concentrations;
            -   a private (i.e., not exported) utility method hill() for calculating Hill kinetics;
            -   a public method expression() for calculating expression rates of the entire
                range of transcription factor concentrations stored in a HillTF variable.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Inside the HillTF type definition, I have also defined a Constructor: a special function
        that can construct new variables of the type HillTF. Compile and load the FunGraphics module,
        that is, compile using the Play button in VSC, then enter `using .FunGraphics`. All public
        (exported) services provided by the FunGraphics module are now available to you at the julia
        command line. Enter the following line now, then reply() me the new HillTF variable tf:
            tf = HillTF(0:30,5)
        """,
        "",
        x -> x==Main.HillTF(0:30,5)
    ),
    Activity(
        """
        By the way, here's a fun fact: When I first implemented this lab, students were surprised
        that I didn't accept their (perfectly correct) answers to the previous activity. The
        reason was that I had forgotten to implement the comparison == between two HillTFs. Please
        take a moment now to study my example in FunGraphics.jl of how to implement the comparison
        between two instances of a custom type (i.e., a user-defined type) such as HillTF. You may
        well want to do this sometime with a custom type of your own!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Remember that you have now defined your own HillTF instance like this:
            tf = HillTF(0:30,5)

        Now load GLMakie, and use this function call to visualise the kinetics of your Hill
        transcription factor tf, which possesses the default values K=3 and n=1:
            lines(tf.range,expression(tf))
            
        The plotted Hill kinetics converge to a maximum upper limit; what is this limit?
        """,
        "The limiting value will probably not be labelled, but should be obvious to you",
        x -> x==1.0
    ),
    Activity(
        """
        The lines() function returns a Plot object: the line that is to be plotted. This line is
        positioned within a set of axes: an Axis object. We can make our plot a little easier to
        understand by using the keyword argument `axis` to add labels to this Axis object:
            lines( tf.range, expression(tf), axis=(;xlabel="TF", ylabel="Expression rate"))

        What is the value of the expression rate when the TF concentration reaches the value K=5?
        """,
        "Again, the value will not be labelled, but you should be able to estimate it",
        x -> x==0.5
    ),
    Activity(
        """
        Use the following commands to visualise Hill kinetics for several different values of K,
        while keeping n at the default value of 1.0, for example:
            tf = HillTF(0:30,10)
            lines( tf.range, expression(tf), axis=(;xlabel="TF", ylabel="Expression rate"))

        Use your visualisations to verify that the value of K in the Hill function always specifies
        the "half-response" level of transcription factor concentration, at which the expression
        rate is equal to half of its maximum value. Study the hill() method to see why this is so.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We can brighten up our Hill graphs by adding some interesting keyword attributes:
            lines( tf.range, expression(tf), color=:blue, linewidth=3, linestyle=:dash)
        
        Experiment with your lines() plot by changing the keyword arguments. What linestyle value
        displays a line consisting of a sequence of two dots and a dash (-..-..-..-)?
        """,
        "Search for keyword arguments on the site: https://makie.juliaplots.org/",
        x -> x==:dashdotdot
    ),
    Activity(
        """
        We can specify the value of n by specifying a third argument in our HillTF constructor,
        for example:
            tf = HillTF(0:30,5,2)

        Use lines() to discover which value, n=1 or n=-1, corresponds to inhibition of expression
        by the transcription factor, then tell me your answer
        """,
        "Plot the Hill curve for each of these two values of n, and study the difference",
        x -> x == -1
    ),
    Activity(
        """
        Experiment with other keyword arguments of the lines() function, for example:
            figure=(; figure_padding=5, backgroundcolor=:green, fontsize=20)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Once we have set up a Plot object inside an Axis, we can add extra Plot objects to this
        same Axis using bang! methods that update the current Axis, for example:
            tf = HillTF(0:30,10,-5)
            scatterlines!( tf.range, expression(tf), color=:red, label="repression", linewidth=3)

        At any time, we can view the result by redisplaying the current figure:
            current_figure()
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now we'll do something a little bit exciting: we will try to understand the meaning of the
        cooperation number n by using animation to simulate changes in n over time. To do this, we
        will create a series of curves using different values of n, but all with the SAME value of
        K. We will use Observables to do this ...

        To understand how Observables work, first enter the following lines at the julia prompt to
        convince yourself that changing the value of t has no influence on the value of x:
            t = 1
            x = cos(t)
            t = 2
            x
        """,
        "Work very carefully: check the result of each individual line to be sure you understand",
        x -> true
    ),
    Activity(
        """
        x and t are simply two different locations in memory, so if we change the value of t, it
        has no effect at all on the value of x. Now we'll perform a similar experiment, but this
        time we will make t an Observable:
            using Observables
            t = Observable(1)
            t
            t[]
            x = cos(t[])
            t[] = 2
            t
            x

        Does the value of x change when we change the value of t?
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        As you see, simply making t Observable doesn't yet influence the value of x. To achieve
        this, we must first tell x that it is an observer of t - that is, its value depends on t.
        Enter the following code, then reply() me the value of x[]:
            t = Observable(1)
            x = map(cos,t)
            t
            x
            t[] = 2
            t[]
            x[]
        """,
        "",
        x -> x == cos(2)
    ),
    Activity(
        """
        An Observable is a variable that contains a list of listeners that react to changes in its
        value. We can make use of this idea to create an animation of the Hill function under
        changes in the cooperativity n. I have done this in the method animate_hill() in the module
        FunGraphics. Call this method now to see the animation, then change the range of values of
        n to run downwards from -1 to -10.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Finally, to round off this lab, you will use your new-found knowledge of plotting to solve
        a puzzle. If you call the function fun_graphics() in the module FunGraphics like this:
            fun_graphics()

        you will find that it prints out 11 scrambled lines of julia graphics code. You will also
        see that fun_graphics() returns the value false, indicating that this code is too
        scrambled to execute properly. Your job is to find a permutation of these lines of code
        that will execute properly. For example, if you enter this:
            fun_graphics([2,1,3,4,5,6,7,8,9,10,11])

        you will see that this permutation vector swaps round the first two lines of code;
        unfortunately, the resulting code is still not executable. reply() me various permutation
        vectors until I tell you that one of them will unscramble the graphics code. When you have
        found this permutation, you can execute the resulting unscrambled code by specifying the
        named argument evaluate=true in fun_graphics().
        
        Good luck - may the Force be with you! :)
        """,
        """
        A permutation vector such as p=[2,3,1] specifies the order in which we want to access the
        elements of an array. To understand this at the julia console, first define this vector p,
        then define a = ["yah!","Hal","lelu"], and try calling a[p] and join(a[p]).
        """,
        x -> Main.fun_graphics(x)
    ),
]