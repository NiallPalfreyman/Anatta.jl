#========================================================================================#
#	Laboratory 3
#
# Programs, types and functions
#
# Author: Niall Palfreyman, 04/01/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 003: Compilation, data types and multiple dispatch

        In this laboratory we look at the very heart of julia: How it uses types to dispatch
        functions. That is, how does julia decide which particular method it will use to implement
        whatever it is we ask it to do?
            Remember: Whenever I call a Function, julia executes a Method. This method is the julia
            program code that implements the function.

        You will also learn in this lab how to write your own full julia module to define a new
        data type together with its associated methods.
        """,
        "Just enter: reply()",
        x -> true
    ),
    Activity(
        """
        We will start by looking at the structure of a julia program. Every julia program starts off
        as a text string - usually stored in a file or entered at the julia prompt. For example:
            prog = "8 / (2 + 3.0)"

        Enter this tiny program, then reply() me the string prog, so I can check you have typed it
        in correctly:
        """,
        "Or just enter: reply(prog)",
        x -> (replace(strip(x)," "=>"") == "8/(2+3.0)")
    ),
    Activity(
        """
        A quick tip to help us understand each other: Sometimes, in the text, I want to tell you
        the specific characters that you should enter at the console. That is, I'll want to
        distinguish between normal text and julia `text`. I will do this by using backticks (``).
        So, Ani is my name, but `Ani` is a set of three characters that you should enter.

        Now, check that you have understood this by entering `prog`, then reply() me the `ans`
        that you receive back from julia:
       """,
        "Or else, simply enter: reply(prog)",
        x -> (replace(strip(x)," "=>"") == "8/(2+3.0)")
    ),
    Activity(
        """
        Notice that brackets are important in this little program: `8/(2+3.0)` will return a very
        different value from `8/2+3.0`. Now use Meta.parse() to analyse your little program prog
        into an expression `expr` and reply() me the typeof() expr:
        """,
        "Enter: expr = Meta.parse(prog)",
        x -> (x==Expr)
    ),
    Activity(
        """
        By the way, please note that in julia it makes a very big difference whether you spell a
        name using upper- or lowercase letters, for example: `expr` and `Expr`. In the previous
        activity, `expr` is our own name for a new variable containing your parsed (i.e.
        translated) program, whereas `Expr` is the type of the value that julia has stored in
        computer memory under that name. Check for yourself that typeof(expr) == Expr.

        Quite generally, every item of data, and every program, function, expression or statement
        in julia is simply an Expression object with the type Expr. Expr is the fundamental type
        of EVERYTHING in the julia language!
        
        So let's investigate what objects of type Expr look like. An Expr is a structure with two
        parts: a head (named `expr.head`) and a vector (named `expr.args`) of arguments of that
        head. Tell me what is contained in the head of the object `expr` that we created in the
        previous activity:
        """,
        "expr.head",
        x -> x==:call
    ),
    Activity(
        """
        The :call symbol tells julia that your program Expr is something that it can actually call,
        or execute, on a computer. Basically, julia interprets the variable `expr` like this:
            `call` the function `/` with the two arguments `8` and `2 + 3.0`,

        and julia interprets the subexpression `2 + 3.0` like this:
            `call` the function `+` with the two arguments `2` and `3.0`
        
        Use the function dump() to visualise the structure of expr, and note carefully what you see:
        """,
        "Simply enter: `dump(expr)`. You can then enter `reply()` to continue with this lab",
        x -> true
    ),
    Activity(
        """
        As you can see, the `.args` field of expr is a Vector. Use your experience of accessing
        vector elements to find out the typeof the second argument of the third argument of expr:
        """,
        "dump(expr) or expr.args[3].args[2] - Try both! :-)",
        x -> x==typeof(Main.expr.args[3].args[2])
    ),
    Activity(
        """
        julia has interpreted your "2" as an integer (e.g. Int64), but as you can see, your "3.0"
        has been interpreted as a floating-point number (e.g. Float64).
        
        We can execute (that is, evaluate) your expression `expr` using the function `eval()`.
        What is the evaluated value of expr?
        """,
        "eval(expr)",
        x -> x==1.6
    ),
    Activity(
        """
        Every julia program is just like your little prog. It starts as a text string, which julia
        then parses into an expression: a tree structure that your computer can evaluate. We call
        such an evaluation tree a METHOD: a single, particular implementation of some function we
        wish to evaluate.

        Let's look at a slightly more complicated evaluation tree. Enter this text-string program:
            prog = "susan = 3sin(pi/2)"

        Parse this program into the variable `expr`, then dump it. You will see that this time, the
        head of expr is no longer `:call`, but the Symbol `=`. This is because your new program is
        not something that calculates a number, but instead creates a new variable named `susan`,
        whose value is 3 times the sine of π/2. Evaluate `expr` now, and give me your answer:
        """,
        "Just reply() to me with the value that you get - which should be 3.0",
        x -> x==3.0
    ),
    Activity(
        """
        OK, so your new program has correctly calculated the result 3.0. But has it created a
        variable named `susan`? Enter `susan` at the julia prompt, then tell me your answer:
        """,
        "",
        x -> x==3.0
    ),
    Activity(
        """
        Bingo! Your program works! :D julia has created a variable called `susan`, containing the
        value 3.0! Now let's move on to more complicated things. We'll stop parsing the expressions
        ourselves from now on, and instead, we'll just enter them at the julia prompt and let julia
        do all the parsing work for us ...

        First, create your own function by entering at the julia prompt:
            ahmed(x) = 3sin(pi/x)

        We know from the previous activities that ahmed(2) should evaluate to 3sin(π/2)==3.0. So
        test your ahmed method now by entering ahmed(2), and tell me what you get:
        """,
        "",
        x -> x==3.0
    ),
    Activity(
        """
        Great! now we know how to create function methods, so let's create the more complicated
        factorial function fact(). How do we calculate the factorial of a number N? We multiply N
        by the next number down (N-1), then by the next number down (N-2), and so on down to 1.
        We can implement this in julia like this:
            fact(N) = if (N <= 0) 1 else (N * fact(N-1)) end

        When you enter this method definiton, julia will tell you that it has created a generic
        function `fact` with one method implementation. Test this implementation - enter fact(5):
        """,
        "As always, try it out, then reply() me the result so I can check it for you",
        x -> x===120
    ),
    Activity(
        """
        Our fact() method seems to be working fine. Check this by testing some other factorial
        values that you know. For instance, did you know that fact(0) is 1? Try this out:
        """,
        "Enter `fact(0)`, then enter `reply(ans)` to give me the result",
        x -> x==1
    ),
    Activity(
        """
        It even works for floating-point numbers as well as integers. Test this by calculating
        the value of fact(3.0), which should be 6.0:
        """,
        "As before, enter `fact(3.0)`, then enter `reply(ans)` to give me the result",
        x -> x==6.0
    ),
    Activity(
        """
        However, we do still have a problem with our fact() method. Try calculating the value of
        fact(3.1):
        """,
        "",
        x -> 0.7<x<0.72
    ),
    Activity(
        """
        This answer seems a little strange, but actually it makes perfect sense. Always remember:
            A computer always does EXACTLY what you tell it, and always gives you PERFECT feedback!

        We told julia to calculate the fact() function by multiplying the argument N by (N-1), then
        by (N-2), and so on until we get below 0, when we return the answer 1:
            fact(3.1) == 3.1 * 2.1 * 1.1 * 0.1 * 1 == 0.7161...
        
        As I said, julia gives us PERFECT feedback on the result of our implementation method if we
        use it with floating-point numbers - it's just that this result turns out to be different
        from what we expected!

        However, there does exist a library function that does what we want with floating-point
        values - this is the Γ-function gamma(), contained in the SpecialFunctions library:
            using SpecialFunctions

        Now experiment with the gamma function to find out its relationship to the factorial
        function. For example, what value of N yields the result gamma(N) == fact(5)?
        """,
        "Call gamma(n) with varying values of n, and compare results with fact()",
        x -> x==6
    ),
    Activity(
        """
        Of course, the difficulty with the gamma() function is that its method requires Julia to
        evaluate a complex integral, which makes it a little expensive to evaluate - our method
        fact() is faster for integer arguments. So let's define two different methods - one for
        Ints and one for Reals:
            fact(n::Int) = if (n <= 0) 1 else (n * fact(n-1)) end
            fact(x::Real) = gamma(x+1)

        Check these methods by entering the two calls `fact(3)` and `fact(3.0)`. What is the
        type of the value returned by `fact(3.0)`?
        """,
        "fact(3.0)",
        x -> x <: AbstractFloat
    ),
    Activity(
        """
        OK, so now what is the value of fact(3.1)?
        """,
        "Enter fact(3.1)",
        x -> 6.812<x<6.813
    ),
    Activity(
        """
        This result seems a little more reasonable, doesn't it? If you enter the call
            methods(fact)

        you will see a list of methods stored under the name "fact". As you can see, julia has
        stored (at least) 2 different methods: one for when you call fact() with an Integer
        argument, and one for when you call fact() with a Real (floating-point) argument.

        julia takes over this decision for you: whenever you invoke, or call, the function fact()
        with an integer argument, Julia automatically dispatches this invocation to the method
        fact(n::Int). Similarly, whenever you call fact() with a floating-point argument, Julia
        automatically dispatches this invocation to the method fact(x::Real). This decision is
        called Dispatching, and it is performed completely transparently at invocation time by the
        Julia Dispatcher. We will see that dispatching makes programming very much easier!
        
        What is the typeof the return value of the methods() function?
        """,
        "methods(fact)",
        x -> x == Base.MethodList
    ),
    Activity(
        """
        Since argument types are so important for dispatching functions, let's try creating our
        own user-defined types. To do this, it is best if we create our code in a julia file that
        we can compile, test and develop in the VSC environment. In the Computation folder, you
        will find a julia file named Dummies.jl. This is a template that you can use to create
        your own modules in the future. Now do the following:
            -   Select the file Dummies.jl in VSC Explorer. Press ctrl-C then ctrl-V to copy
                Dummies.jl to a new file that you rename Organisms.jl. Open the new file in VSC.
            -   In Organisms.jl, replace all occurrences of the word "Dummies" by "Organisms".
                This is the name of the complete module that you are now creating. We usually name
                modules using either an abstract or a plural noun.
            -   Replace all occurrences of the word "Dummy" by "Weasel". This is the name of the
                first of several types that we will create within the Organisms module. Notice
                that both modules and types start with a CAPITAL letter!
            -   Change the code of the demo() method inside the module Organsims so that instead
                of a Dummy variable named Dimmy, it creates a Weasel variable named Wendy. So, for
                example, the line in which you create Wendy will look like this:
                    wendy = Weasel( "Wendy", 3.1415)
                (Notice that variables always start with a small letter!)
        """,
        "Make sure you create the file Computation/Organisms.jl, EXACTLY as I have described it here",
        x -> isfile(joinpath(Main.Anatta.session.home_dir,"Development","Computation","Organisms.jl"))
    ),
    Activity(
        """
        Your Organisms.jl program should now run. In the julia console, you would compile it from
        within your home directory by entering:
            julia> include("Development/Computation/Organisms.jl")

        However, in VSC it is easier to just press the compilation triangle in the top-right of
        your VSC pane. This compiles your new Organisms module inside a new julia console within
        VSC, which is a good place to test new code.
        
        If you get compiler-error messages, use them to correct your code in VSC. Finally, enter
        the following line at the julia prompt to run your code, and correct any new errors you
        might get until the demo() method runs correctly:
                Organisms.demo()
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice that you had to type `Organisms.demo()` to specify that you wanted to run the demo()
        method defined inside the module Organisms. For the same reason, if you want to create your
        own Weasel in the Main julia environment, you will need to enter this:
            willy = Organisms.Weasel( "Willy", 2)

        Do this now. Is it possible for you to now to display Willy's greeting by entering the
        following line of code at the julia prompt?
            greeting(willy)
        """,
        "",
        x -> occursin("n",lowercase(x))
    ),
    Activity(
        """
        The problem, of course, is that greeting() is only defined within the Organisms module.
        You could call it like this:
            Organisms.greeting(willy)

        but that is slightly awkward. So now load the Organisms module into your Main environment:
            using .Organisms

        and then enter greeting(willy). Does this now work?
        """,
        "",
        x -> occursin("y",lowercase(x))
    ),
    Activity(
        """
        Great! :) So now we have loaded the two symbols `greeting` and `Weasel` into our Main
        environment. You can check this by entering `willy` at the julia prompt and noticing that
        the REPL no longer tells us that Weasel is inside Organisms.

        Now we'll create a few ABSTRACT types to represent various biological organisms. Enter
        the following lines of code above the definition of Weasel, and make sure you enter for
        each new type a docstring that describes their meaning:
            "Organism: a general living being."
            abstract type Organism end

            "Animal: an animate Organism."
            abstract type Animal <: Organism end

        Now modify the Weasel code to announce that it is a subtype of Animal:
            struct Weasel <: Animal
                name::String
                age::Int
            end
        """,
        "",
        x -> true
    ),
    Activity(
        """
        However, our abstract types Organism and Animal are not yet contained in Main, but only
        inside Organisms. So now extend the export line at the beginning of the Organisms module
        to look like this:
            export Weasel, greeting, Organism, Animal

        Now discard your current Main environment by pressing the dustbin icon in the VSC console,
        then reload Organisms.jl (press the triangular compile button in the VSC editor). Now enter
            using .Organisms
            willy = Weasel( "Willy", 2)
        
        Now check whether willy is an Organism:
            typeof(willy) <: Organism
        """,
        "Tell me the answer that you get back from this line",
        x -> x==true
    ),
    Activity(
        """
        Now use the supertype() function to find the supertype of Animal. What type is
        returned if you ask for the subtypes() of Organism?

        Use the function fieldnames() to inspect the individual fields of the Weasel
        type, then give me the descriptor of the second field.
        """,
        "fieldnames(Weasel)",
        x -> x == :age
    ),
    Activity(
        """
        We use struct types to instantiate concrete OBJECTs in computer memory by
        entering specific values for the individual fields of the Weasel struct:
            wendy = Weasel( "Wendy", 3)
            willy = Weasel( "Willy", 2)

        Notice that types start with an UPpercase letter, whereas objects start with a
        lowercase letter. By default, Julia creates structs as IMMUTABLE - that is, we
        cannot modify the value of their fields. This means Julia can always know exactly
        how much memory an object needs, which provides major performance advantages. Try
        changing the value of Wendy's age to see that this is not allowed. What word
        does the resulting exception message use to describe the struct you tried to modify?
        """,
        "wendy.age = 5",
        x -> lowercase(strip(x)) == "immutable"
    ),
    Activity(
        """
        Immutability might at first seem awkward, but very often we don't want to change
        an object's fields, but instead want to replace one object by another. This way
        of using objects is far faster and less error-prone. If, however, we do want to
        change the fields of a type, we must define it as MUTABLE, like this:
            mutable struct Rabbit <: Animal
                name::String
                age::Integer
            end

        Enter this new concrete type in Organisms.jl, recompile, then try creating a Rabbit
        named Rabbia in Main:
            rabia = Rabbit( "Rabia", 5)

        Does this line work properly?
        """,
        "Don't worry if you get an error - that's how it's supposed to be! :)",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        The problem is that although we have created the new type Rabbit, we have not yet
        exported this type to the outside world. To do this, enter the name Rabbit in the
        export list at the top of the module Organisms. Now recompile, then create a Rabbit
        named Rabbia in Main:
            rabia = Rabbit( "Rabia", 5)

        Change Rabia's age to 4, then give Rabia to me to look at for myself:
        """,
        "rabia.age = 4",
        x -> (x.length == 4)
    ),
    Activity(
        """
        Unlike object-oriented languages, which only dispatch on the first argument of a
        function, a major design feature of Julia is that it uses MULTIPLE DISPATCHING,
        which is particularly important when we use Julia to perform biological simulations.
        To see multiple dispatching in action, let's use our above type definitions. 

        When Animals meet each other, they react in different ways according to their type:
        Weasels challenge each other, but they attack Rabbits. We could implement these
        different interactions using if-else conditionals, but it is easier to use
        multiple dispatching. Enter the following method definitions in the Organisms module
        after the method greeting() and before the method demo(), making sure that you preceed
        them by appropriate doc-strings:
            meet( meeter::Weasel, meetee::Rabbit) = "attacks"
            meet( meeter::Weasel, meetee::Weasel) = "challenges"
            meet( meeter::Rabbit, meetee::Rabbit) = "sniffs"
            meet( meeter::Rabbit, meetee::Weasel) = "hides"
            meet( meeter::Organism, meetee::Organism) = "ignores"
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Test these definitions by recompiling Organisms, then finding out what happens when Rabia
        meets Willy:
            meet(rabia,willy)
        """,
        "meet(rabia,willy)",
        x -> occursin( "hide", lowercase(x))
    ),
    Activity(
        """
        The dispatcher must be able to make these type-dependent decisions during the execution
        of our simulation program. Insert the following method definition into Organisms.jl below
        the meet() methods:
            function encounter( meeter::Organism, meetee::Organism)
                println( meeter.name, " meets ", meetee.name, " and ", meet(meeter,meetee), ".")
            end
        
        Now test this method by recompiling, then calling encounter() at the julia prompt, using
        various combinations of Wendy, Willy and Rabia.

        What happens if you create a new Rabbit called Robby, and Rabia encounters him?
        """,
        "meet(robby,rabia)",
        x -> occursin( "sniff", lowercase(x))
    ),
    Activity(
        """
        Now, to see the full power of multiple dispatching, add your own new concrete
        type and then check how an encounter between your type and Rabia works out. Do
        it something like this (at the julia prompt!):
            struct Tree <: Organism; name::String end
            tilly = Tree( "Tilly")

        How does Rabia react to Tilly?
        """,
        "encounter(rabia,tilly)",
        x -> occursin( "ignores", lowercase(x))
    ),
    Activity(
        """
        Notice how multiple dispatching enables your new type (which the Organisms module knows
        nothing about!) to make use of the existing code for meet(Organism,Organism). This
        ability to dynamically extend existing code is the enormously useful power of ...
            MULTIPLE DISPATCHING!

        I have one last task for you: Rewrite the Organisms.demo() method to provide a proper
        demonstration of the new data types and methods that you have written in Organisms.jl.
        Make sure you test your demo() method to be sure it runs properly, and it is a VERY
        good idea to get your instructor to check your file Organisms.jl to be sure you have
        formatted and commented it well. Good-bye for now! :)
        """,
        "",
        x -> true
    ),
]