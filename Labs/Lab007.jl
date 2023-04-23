#========================================================================================#
#	Laboratory 7
#
# Data visualisation and graphics
#
# Author: Niall Palfreyman, 06/09/2022
#========================================================================================#
[
    Activity(
        """
        Welcome to Lab 007: Visualising data graphically

        In this laboratory we learn how to use Julia's Makie plotting package to create graphical
        displays for data visualisation. Makie is the front-end for several different backend
        graphics packages - for example, Cairo, GL and WebGL. We shall focus here on GLMakie,
        which we now load with the following command:
            using GLMakie
        """,
        "This might take a while ...",
        x -> true
    ),
    Activity(
        """
        Note that julia uses Just-in-time (JiT) compilation, so the first time you call a graphics
        method, it will always take longer than later calls. Enter the following command (being
        sure to include the semicolon at the end!), then tell me the type of the return value fig:
            fig = scatterlines( 0:10, (0:10).^2);
        """,
        "Enter the command exactly as I have done here",
        x -> x==Main.Makie.FigureAxisPlot
    ),
    Activity(
        """
        As you can see, fig contains a graphics object; the only reason you can't see it is
        because of that semicolon you included. As always, a semicolon at the end of a function
        call prevents the function's value being returned from the function-call.

        Makie plotting commands like scatterlines() create three things: a Figure that can be
        displayed, an Axis system contained in that Figure, and Plot objects such as curves and
        test boxes that Makie draws inside that Axis system. When we display the Figure, it already
        contains one or more Axis systems, and one of these Axis systems contains our Plot curve.

        Let's display at this internal structure - reply() me the fieldnames of fig:
            fieldnames(typeof(fig))
        """,
        "",
        x -> x == (:figure,:axis,:plot)
    ),
    Activity(
        """
        Now we know about the structure of Figures, let's display our curve in graphical form.
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
        like colour, thickness, dotted line, and so on. Check out the `attributes`` field of plt to
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

        Tell me which attribute you would use if you wanted your graph curve to be a dotted line:
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
        like maybe the Hill function. The Hill function describes the activation and inhibition by
        a transcription factor (tf) of DNA expression in biological cells:
            function hill( tf, K=2.0, n=1.0)
                abs_n = abs(n)
                if abs_n != 1
                    K = K^abs_n
                    tf = tf.^abs_n
                end
                (n >= 0) ? (tf./(K.+tf)) : (K./(K.+tf))
            end
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The Hill function is a generalisation of the Michaelis-Menten function, with which you
        might already be familiar. For each transcription factor concentration value tf, the
        function call `hill(tf)` calculates a corresponding level of gene activation or inhibition.
        Use the following commands to visualise the hill() function for varyious values of K and n:
            transfactor = 0:20
            lines(transfactor,hill(transfactor))
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Verify that the value of K in the Hill function always specifies the "half-response" level
        of transcription factor concentration, at which the activation/inhibition level is equal to
        half of its maximum value.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Which value, n=1 or n=-1, corresponds to inhibition by the transcription factor?
        """,
        "Plot the Hill curve for each given value of n, and study the difference",
        x -> x == -1
    ),
    Activity(
        """
        We can brighten up our Hill-function figure by adding some interesting line attributes:
            lines( transfactor, hill(transfactor); color=:blue, linewidth=3, linestyle=:dash)
        
        The ; symbol marks the beginning of keyword arguments of a function. Experiment with this
        plot by changing the keyword arguments of lines(). What argument value displays a line
        consisting of a sequence of two dots and a dash (-..-..-..-)?
        """,
        "Search for keyword arguments on the site: https://makie.juliaplots.org/",
        x -> x==:dashdotdot
    ),
    Activity(
        """
        The lines() function returns a Plot object: the line that is to be plotted. This line is
        positioned within a set of axes: an Axis object. We can redesign the structure of this Axis
        object by adding to our lines() call a specification of the Axis:
            lines( trfactor, hill(trfactor,2,1);
                color=:blue, label="Activation",
                linewidth=3, linestyle=:dash,
                axis=(;
                    xlabel="TF concentration", ylabel="Expression rate",
                    title="Transcription regulation",
                    xgridstyle=:dash, ygridstyle=:dash
                )
            )

        Notice carefully how I have used indentation to make it clear the level of nesting of
        structures and function calls. It's not so easy to do this in the REPL, but soon we will be
        writing our own program code in files, so it's good to practise making our code easily
        readable by other programmers. Try out a few interesting axis parameters of your own ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        This Axis object is then displayed within a Figure object. We can also redesign the
        appearance of that figure by adding a Figure specification to lines():
            lines( trfactor, hill(trfactor);
                color=:blue, label="activation",
                linewidth=3, linestyle=:dash,
                axis=(;
                    xlabel="TF concentration", ylabel="Expression rate",
                    title="Transcription regulation",
                    xgridstyle=:dash, ygridstyle=:dash
                ),
                figure=(;
                    figure_padding=5, resolution=(600,400), font="sans",
                    backgroundcolor=:green, fontsize=20
                )
            )

        Experiment now with the figure parameters ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Once we have set up a Plot object inside an Axis, we can add extra Plot objects to this
        same Axis using bang! methods that change the current state of the Axis, for example:
            scatterlines!( trfactor, hill(trfactor,2,-1);
                color=:red, label="repression", linewidth=3
            )
            axislegend( "Legend"; position=:rc)

        Having done this, we can view the result by redisplaying the current figure:
            current_figure()
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In your graphic, look closely at the point where the curves of the two Hill-functions
        intersect. You can see that this transcription-factor concentration correspondes to the
        value of K that we pass to the Hill function. Check that this is generally true, and tell
        me generally which value of Expression rate corresponds to the TF concentration K:
        """,
        "Create a new graphic, using a new value of K that is common to BOTH curves",
        x -> x==0.5
    ),
    Activity(
        """
        OK, let's go wild! We'll use our new-found knowledge of plotting to display a bubble-plot:
            xdata = rand(50); ydata = rand(50); colours = rand(50)
            fig, ax, plt = scatter( xdata, ydata;
                color=colours, label="Bubbles", colormap=:plasma,
                markersize=15*abs.(data[:,3]),
                axis=(; aspect=DataAspect()),
                figure=(; resolution=(600,400))
            )
            limits!(-3,3,-3,3)
            Legend( fig[1,2], ax, valign=:top)
            Colorbar( fig[1,2], plt, height=Relative(3/4))
            fig

        Do you like my pretty bubble-plot?
        """,
        "I'm very insecure: Please say yes!",
        x -> true
    ),
    Activity(
        """
        As you see, to create a nice graphic, we often need to build it up in several steps, so it
        is a good idea to collect these steps together into a single function. For example, suppose
        we want to display several different 2-d functions as heatmaps - we might do like this:
            function prettyheatmap( f::Function)
                figure = (; resolution=(600,400), font="CMU Serif")
                axis = (; xlabel="x", ylabel="y", aspect=DataAspect())
                xs = range(-2, 2, length = 25)
                ys = range(-2, 2, length = 25)
                zs = [f(x,y) for x in xs, y in ys]

                global fig, ax, plt = heatmap( xs, ys, zs, axis=axis, figure=figure)
                Colorbar( fig[1,2], plt, label="A colour bar")
                fig
            end

        This function is getting VERY long to be having to type it all in at the prompt! Why don't
        you just copy and paste my version into the julia prompt?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now call our new graphics function prettyheatmap() as follows:
            ringy(x,y) = cos(5*hypot(x,y))
            prettyheatmap( ringy)

        Now tell me how many yellow rings you see:
        """,
        "Just count the complete rings - not the circle",
        x -> x==2
    ),
    Activity(
        """
        Now that we have wrapped our plotting code inside the function prettyheatmap(), we can
        easily reuse this encapsulated code to display a completely different function:
            mountains(x,y) =
                3 * (1-x)^2 *               exp(-(x^2+(y+1)^2))
                -(1/3) *                    exp(-((x+1)^2 + y^2))
                -10 * (x/5 - x^3 - y^5) *   exp(-(x^2+y^2))
            prettyheatmap( mountains)

        Again: just copy and paste my code. This function itself is unimportant - I just want you
        to see how it is possible to reuse the graphics function prettyheatmap() with various
        different data functions.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        I want to show you just one more trick. Wouldn't it be cool if we could animate our
        graphics and make them move? We can do this using the Observables package:
            using Observables
        
        Now enter the following lines of code (leaving out the copious comments!) to make your
        very own exciting sine-wave movie!

            x = 0:0.1:4pi                       # Spatial x-axis of a sine-wave
            λ = 6.0;    k = 2π/λ                # Wavelength and wave-number
            f = 0.5;    ω = 2π*f                # Frequency and angular frequency
        
            simtime = Observable(0.0)           # The simulation time is Observable by others.
            sinecurve = lift(simtime) do t      # sinecurve is a sine-curve whose shape depends
                sin.(k*x .- ω*t)                # directly upon the current value (t) of simtime.
            end
        
            fig = lines(x,sinecurve)            # Plot a Figure of the sine-curve (dependent on the
            display(fig)                        # current simtime) and display the Figure.
        
            for t in 0:0.1:10                   # Finally, animate the figure: Step through the given
                simtime[] = t                   # time range, update simtime, and watch the sine-curve
                sleep(0.1)                      # move accordingly.
            end
        """,
        "If you have problems, restart Julia, load both Observables and GLMakie, " *
            "and retrieve the above commands using up-arrow",
        x -> true
    ),
]