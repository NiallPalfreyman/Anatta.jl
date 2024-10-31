#========================================================================================#
#	Laboratory 6
#
# Replication: How do populations grow? (Including encapsulation and software design)
#
# Author: Niall Palfreyman, 05/09/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 006: Encapsulation, simulation and software design

        In this laboratory we look at the issue of Encapsulation - a super-important topic in
        modern software engineering. There are two important reasons for using encapsulation:
            -   If everyone is able to change the value of important variables in our program, this
                will make it REALLY difficult for our program to behave reliably, so encapsulation
                hides data from unwanted changes.
            -   In addition, we want to cooperate with other people. They will only be able to
                adapt, develop and maintain our code, if they can understand what it is doing, so
                encapsulation hides details of our program that others don't need to understand.
                
        I have seen one firm come to bankruptcy because one crucial developer didn't understand
        encapsulation!
        
        So encapsulation is all about hiding data - let's find out how it works ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In a moment, you will discover that the variables inside a module or function have LOCAL
        SCOPE - that is, they are only visible and available inside that function, and not in
        the GLOBAL SCOPE outside the function.

        Sometimes, we are tempted to pass data from one function to another by storing that data
        in global variables, but this ALWAYS brings with it the danger that someone might change
        that data by accident, and so cause our program to crash! In this laboratory we investigate
        how to pass data in ways that protect it from being changed by accident.

        In our first experiment, enter the following code, then tell me the value of paula:
            linus = [5,4,3,2,1]; paula = 5
        """,
        "",
        x -> x==5
    ),
    Activity(
        """
        Now enter the following function:
            function change_paula()
                paula = 7
                paula
            end

        Then call the function change_paula() and tell me the value you get back:
        """,
        "Your result may (or not) surprise you, depending on how you think about scoping rules",
        x -> x==7
    ),
    Activity(
        """
        Your result shows us that the variable paula has two different meanings: the meaning in
        the GLOBAL scope outside the function change_paula, and the meaning inside the LOCAL
        scope of change_paula.

        Now tell me the current value of paula:
        """,
        "Ask julia for the value of paula",
        x -> x==5
    ),
    Activity(
        """
        Aha! So although we can change the value of LOCAL paula inside the function change_paula(),
        this does not affect the value of GLOBAL paula. In fact, there exist two different variables
        named paula: the GLOBAL variable containing the value 5, and a LOCAL variable containing
        the value 7. When change_paula() ends, the variables in its local scope are thrown away,
        and the LOCAL paula disappears.

        If we REALLY want to change the global value of paula, we can do so by redefining
        the function change_paula():
            function change_paula()
                global paula = 7
                paula
            end

        NOTE: Doing this is a Very Bad Idea! Nevertheless, tell me the value of paula after you
        have called your new version of change_paula().
        """,
        "",
        x -> x==7
    ),
    Activity(
        """
        So julia does allow us to make use of global values inside a local scope, but it forces us
        to announce this by using the keyword "global".

        There is a further issue here. Enter this code:
            function change_linus()
                linus[3] = 7
                linus
            end

        Again, when we call change_linus(), the return value shows us that we are able to change
        the value of a local variable named linus. But now tell me the value of the GLOBAL variable
        named linus:
        """,
        "",
        x -> x==Main.linus
    ),
    Activity(
        """
        The point here is that linus is a (global) Vector that refers to its contents (5,4,3,2,1).
        If we do not use the keyword `global`, julia does not allow us to change linus itself,
        however julia DOES allow us to change the CONTENTS that linus refers to. So global
        variables are still very unsafe! What are we to do? Here is the solution:

            ALWAYS encapsulate (i.e.: wrap/hide) EVERYTHING you do inside a MODULE!

        Modules offer a very effective tool for preventing our variables and code from being
        changed by other programmers. Let's see how to do this. Enter the following code:
            module MyModule
                function change_paula1()
                    global paula = 9
                    paula
                end
            end

        Now call MyModule.change_paula1(), then tell me the global value of paula afterwards:
        """,
        "",
        x -> x==7
    ),
    Activity(
        """
        OK, so putting change_paula1() inside the module MyModule means it cannot interfere with
        the value of our global variable paula! Now that we know how to hide variables and
        functions inside a module, we can do some real live software development!
        
        In later laboratories we will develop our own software modules; however, these modules can
        get quite complex, so we must first learn to build them up step-by-step within a file.

        We will start by modifying some code that I have written. In the subfolder
        `Development\\Computation` of your Anatta home folder is the julia file Replicators.jl.
        Open this file now in VSC and study its contents. What is the name of the data type
        defined in the file Replicators.jl?
        """,
        "The definition is in line 22 of Replicators.jl",
        x -> x=="Replicator"
    ),
    Activity(
        """
        Replicators.jl is the starting point of a project to simulate a growing population of bio-
        logical replicators (e.g. genes, bacteria, yeast, ...). I recommend STRONGLY that you use
        Replicators.jl as a general template for starting new projects of your own. When you start
        a new project, copy Replicators.jl to a new file, then adapt its contents to fit your needs.

        Take a good look at the following important aspects of the file Replicators.jl:
            1.  It uses comment lines and boxes to divide the code into simple explanatory chunks.
                Please never neglect these comments - ALWAYS keep their information up to date!
            2.  It contains just one module called Replicators, which will hold together all the
                data and methods that we need for our coming project.
            3.  The Replicators module contains the definition of a new data type Replicator which
                will form the central storage point for the information in our simulation.
            4.  The Replicators module also contains just ONE method: the Use-Case demo() which
                specifies and tests all the high-level actions that we will want our program to do.
                For example, we intend to design a method run!() that will simulate a Replicator
                population, so demo() calls this method, even though I haven't implemented it yet.
            5.  Before EVERY module, type and method is a string that serves as help documentation.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now parse the file Replicator.jl. You can do this either by opening the file in VSC and
        pressing the Play button, or else by calling the include() function from a julia console
        located within your Anatta home folder:
            include("Development/Computation/Replicators.jl")

        This should go smoothly, and include() reports back the presence of the new module
        Replicators in your console's Main scope. Tell me the return value of include():
        """,
        "",
        x -> x==Main.Replicators || strip(x)=="Main.Replicators"
    ),
    Activity(
        """
        It is important that our use-case runs correctly, because it is the springboard for
        developing and testing the entire project. Run the use-case now by calling the function
        Replicators.demo() and tell me in which line of code you get your first error:
        """,
        "",
        x -> x==50
    ),
    Activity(
        """
        Ani's Law of Programming: You will ALWAYS get error messages, and this is a Good Thing! :)

        The point is this: NO-ONE else in your life is able to give you such consistently patient,
        supportive, nonjudgemental feedback as a compiler! Compilers never get cross - they simply
        tell you how it is.

        You have already started making friends with the julia compiler by noting the line number
        in which the error occurred: 50. Now take it one step further - in the ERROR line, it says
        there is an UndefVarError. That is, we forgot to define something. What is the name of the
        thing we forgot to define?
        """,
        "",
        x -> occursin("run!",x)
    ),
    Activity(
        """
        As you see, julia reminds us that we are calling the function run!(), but we haven't yet
        defined a method for it. We will need to do that later, but for now, just comment out the
        three lines in demo() which call run!(). That is:
            -   Set a line-comment marker (#) before each of the three lines where run!() is called.
            -   Save the file Replicator.jl
            -   In the julia console, include() again the file Replicator.jl
            -   At the julia prompt, call the method Replicators.demo(), and
                check that it now runs correctly without errors.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, now we will develop our Replicators module by introducing successive small (!) changes
        into the file Replicators.jl. We start by thinking about how to construct a Replicator:
            -   First, we need to give users (in this case, demo()) the tools to specify values for
                the time-scale, time-step and time-series in line 45, although we of course can't
                know the value of the time-series until the Replicator simulation has run.
            -   Second, although the simulation needs to know all three of these values, for users
                it is more convenient to only have to enter the duration and time-step of the
                simulation in line 45. For example, change line 45 to look like this:
                    repl = Replicator(5,1)

        Now recompile and run demo() and tell me in which line you get an error:
        """,
        "Look at the StackTrace information lower down in the error message.",
        x -> x == 45
    ),
    Activity(
        """
        To fix this error, we must implement an appropriate constructor that can build a Replicator
        from the two values `duration` and `dt`. In fact, we don't really want users to use the
        default constructor Replicator(t,dt,x) at all! After all, what would happen if users
        specified a time-step that was inconsistent with the steps contained in the time-scale?

        We can block this possibility by defining an Inner Constructor. Go to line 26 of
        Replicators.jl and change the definition of the data type Replicator to look like this:
            struct Replicator
                t::Vector{Real}			# The simulation time-scale
                dt::Real				# The simulation time-step
                x::Vector{Real}			# The population time-series
            
                function Replicator( duration::Real, dt=1)
                    timescale = 0.0:dt:duration
                    new( timescale, dt, zeros(Float64,length(timescale)))
                end
            end
        
        Now rerun demo() and tell me value of your Replicator's time-scale:
        """,
        "You can read this from the first element in the displayed Replicator",
        x -> x == 0.0:1:5
    ),
    Activity(
        """
        OK! Now we have a real Replicator model, let's make it run!!! Insert the following lines of
        code directly underneath the comment box "Module methods:":
            \"""
                run!( replicator, x0, mu=1.0)
            
            Simulate the exponential growth of a Replicator population, starting from the initial
            value x0, and with specific growth constant mu.
            \"""
            function run!( repl::Replicator, x0::Real, mu::Real=1.0)
                repl.x[1] = x0                  # Set initial value of the population
            
                for i in 2:length(repl.t)
                    # Perform Euler step:
                    repl.x[i] = repl.x[i-1] + repl.dt * mu * repl.x[i-1]
                end
                
                repl											# Return the Replicator
            end
        
        Now remove the comment marker in front of the first call of run!(), then run demo()
        and tell me the value of your Replicator's timeseries:
        """,
        "",
        x -> x == [1,2,4,8,16,32]
    ),
    Activity(
        """
        Congratulations! You have implemented your first simulation in julia! Now remove the comment
        markers in front of the remaining calls to run!() and make sure everything runs correctly.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now we can use our Replicator to start doing some experiments with replicating populations.
        You have already seen from demo() how to change the values of dt and mu, but we'd like
        to do this manually for ourselves outside demo(). Enter the following command at the
        julia prompt - does it run successfully?
            yeast = Replicator(5,1)
        """,
        "You should get at error",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        Of course we can't call Replicator() - we haven't yet loaded the module into our Main
        environment! So let's do that now:
            using .Replicators

        Can you now successfully create your Replicator?
        """,
        "You should still get an error",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        What has happened?! Well, using a module doesn't load all of the methods in that module.
        After all, we sometimes want to write some private methods in the module that should not
        be used by users outside the module. For this reason, julia requires us to explicitly
        export any names in our module to which we want external users to have access. Uncomment
        and complete the following line 12 in Replicators.jl:
            export Replicator, run!

        This makes the data type Replicator and the method run!() available to external users.
        Now save the file, include() it, then enter the following at the julia prompt:
            using .Replicators
            yeast = Replicator(5,1)
            run!(yeast,1)

        What is the value of the timeseries?
        """,
        "This should run correctly",
        x -> x == [1,2,4,8,16,32]
    ),
    Activity(
        """
        Now let's do an experiment. You have already created a Replicator whose population
        doubles in each generation, but large, asynchronous populations do not usually jump
        in size at regular time intervals! (Can you think of an animal population that does
        actually behave this way?)

        Let's now see what happens when our population grows in steps of 0.5 instead of 1:
            yeast = Replicator(5,0.5)
            run!(yeast,1)

        What is now the size of the yeast population when t = 1?
        """,
        "Remember that our timestep is now half the previous size, so more steps are needed",
        x -> x == 2.25
    ),
    Activity(
        """
        This is interesting. If the population grows in smaller timesteps, it also grows faster!
        So if we study the population over ever smaller timesteps, will it grow infinitely
        quickly? Let's investigate this phenomenon by looking at the population's growth more
        closely over the timescale 0-1:
            yeast = Replicator(1,0.2)
            run!(yeast,1)

        What is now the size of the yeast population when t = 1?
        """,
        "Since our timescale only runs to 1, it should be the last value in yeast.x",
        x -> abs(x-2.48832) < 0.1
    ),
    Activity(
        """
        OK, so reducing the timestep doesn't make the value increase infinitely. So does it maybe
        increase towards an upper limit? Find out by mapping the population over the timescale
        0-1 with a timestep of 0.001. Even this value is not yet accurate, since the sequence
        converges only very slowly, so you may want to investigate the case dt=1e-6. (You can
        suppress output from the julia prompt by ending your input with a semicolon ;)

        What symbol do we use to represent the value of this limit?
        """,
        "You'll find that the limit lies around 2.718",
        x -> occursin('e',x)
    ),
    Activity(
        """
        You have discovered the reason why nature (and our cognition) cannot be a computer: NO
        computer can EVER simulate continuous time, because dt would then be infinitely close to 0!

        However, we can do better than the Euler method above. If we set dt=1e-6, we can improve our
        simulation results by using the more accurate Runge-Kutta-2 integration method. Replace the
        loop in your run!() method by the following code. Is your result closer to e than before?

            dt_2 = repl.dt/2                                # dt2 is one half-timestep
            for i in 2:length(repl.t)
                # Perform Runge-Kutta-2 step:
                x_2 = repl.x[i-1] + mu*dt_2*repl.x[i-1]     # Calculate new x halfway thru step
                repl.x[i] = repl.x[i-1] + mu*repl.dt*x_2    # Use x2 as better approximation
            end
        """,
        "",
        x -> occursin("yes",lowercase(x))
    ),
    Activity(
        """
        Finally, you will now apply your exponential model to the problem of drinking and driving.
        If you drink two 25ml shots of whiskey, 8ml of alcohol immediately enters your blood. In
        Europe, you may only drive if the concentration of alcohol in your blood is less than 0.05%
        by volume. If you contain 6 litres of blood, this legal limit corresponds to a blood alcohol
        volume of 3ml. So how long must you wait until your liver has broken down the 8ml of blood
        alcohol to 3ml?

        To find this out, think about the story of how the liver works. In this bioprocess, the
        liver takes a cupful of your blood, then filters the alcohol out of this cupful. If there is
        no alcohol in the cupful, the alcohol breakdown rate is zero; the more alcohol there is, the
        higher the breakdown rate. If there are x=10 ml of blood alcohol, your liver breaks it down
        at a rate of dx/dt=-3 ml/hr. Assuming that the breakdown rate is proportional to blood
        alcohol level (i.e.: dx/dt=μx), what is the numerical value of μ in our particular case?
        """,
        "Remember that this is a breakdown process - not growth!",
        x -> x == -0.3
    ),
    Activity(
        """
        What function is the exact (analytic) solution of the equation dx/dt = -0.3 x ? reply()
        me an anonymous julia function that matches this exact solution.
        """,
        "If you are unsure how to write the exponential function, look it up in this lab file.",
        f -> (f isa Function) && (t->f(t)==exp(-0.3t))(rand())
    ),
    Activity(
        """
        If μ is negative, the exponent of e in this solution is negative, so as time progresses,
        your blood alcohol level gets divided (not multiplied!) by e≈2.718 over each unit of time.
        What is the numerical value of x0 in our particular case?
        """,
        "",
        x -> x == 8
    ),
    Activity(
        """
        Use a Replicator with the appropriate parameters to create a simulation which calculates
        how many hours you must wait before you can drive legally after your two shots of whiskey. 
        """,
        "Use logical indexing and findfirst to locate the time when x falls below 3.",
        x -> abs(x-3.3) < 0.1
    ),
]