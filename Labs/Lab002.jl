#========================================================================================#
#	Laboratory 2
#
# Programs, types and functions
#
# Author: Niall Palfreyman, 04/01/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 002: Programming Basics

        In this laboratory we look at the very heart of julia: How it uses types to dispatch
        functions. That is, how does julia decide which particular method it will use to implement
        whatever it is we ask it to do? Remember: I call a Function, but julia executes a Method.

        First, let's start with the structure of a Julia program. Every julia program starts life
        as a text string, for example:
            prog = "8 / (2 + 3.0)"

        Enter this tiny program, then reply() me the string prog to make sure you have typed it
        correctly:
        """,
        "Just enter: reply(prog)",
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
        "Again, simply enter: reply(prog)",
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
        By the way, notice that in julia there is a very big difference between the two names
        `Expr` and `expr`: upper- an lowercase letters are different from each other. Here, `expr`
        is your own name for a new variable containing your parsed (i.e. translated) program, and
        `Expr` is the type of the thing that julia has stored under that name.

        So let's look at what an Expr looks like. An Expr is a structure with two parts: a head
        (named `expr.head`) and a vector of arguments (named `expr.args`). Tell me what is
        contained in the head of expr:
        """,
        "expr.head",
        x -> x==:call
    ),
    Activity(
        """
        The :call symbol tells julia that your program Expr is something that can actually be
        called, or executed on a computer. Use the function dump() to view the entire structure
        of expr now, and note what you see:
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
        
        We can execute (that is, evaluate) your expression expr using the function `eval()`.
        What is the value of expr?
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
        not something that can be called, but instead creates a new variable named `susan`, whose
        value is 3 times the sine of π/2. Evaluate `expr` now, and give me the answer you receive:
        """,
        "Just reply() to me with the value that you get - which should be 3.0",
        x -> x==3.0
    ),
    Activity(
        """
        OK, so your new program has correctly calculated the result 3.0, but has it created a
        variable named `susan`? Enter `susan` at the julia prompt and tell me what answer you
        get:
        """,
        "",
        x -> x==3.0
    ),
    Activity(
        """
        Bingo! Your program works! :) julia has created a variable called `susan`, containing the
        value 3.0! Now let's move on to more complicated things. We'll stop parsing the expressions
        ourselves from now on, and instead, we'll just enter them at the julia prompt and let julia
        do all the parsing work for us ...

        Now create your own function by entering at the julia prompt:
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
            fact(N) = (N <= 0) ? 1 : (N * fact(N-1))

        (If you are unsure about the ternary operator ?:, enter `?` now at the julia prompt now to
        get into help mode, then enter `?:` to ask about how this operator works)

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
        use it with floating-point numbers - it's just that this result turns out to be not quite
        what we expected!

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
        Of course, the difficulty with the gamma() function is that it is a little expensive to
        evaluate - our method fact() is faster for integer arguments. So let's define two
        different methods - one for Ints and one for Reals:
            fact(n::Int) = (n <= 0) ? 1 : (n * fact(n-1))
            fact(x::Real) = gamma(x+1)

        Check these methods by entering the two calls `fact(3)` and `fact(3.0)`. What is the
        type of the value returned by `fact(3)`?
        """,
        "eval(fact(5.0))",
        x -> x==120.0
    ),
    Activity(
        """
        OK, so now what is the value of fact(3.1)?
        """,
        "eval(fact(5.01))",
        x -> 6.812<x<6.813
    ),
    Activity(
        """
        This result seems a little more reasonable, doesn't it? If you enter the call
            methods(fact)

        you will see a list of methods stored under the name "fact". As you can see, julia has
        stored (at least) 2 different methods: one for when you call fact() with an Integer
        argument, and one for when you call fact() with a Real (floating-point) argument.

        julia takes over this decision for you at the instant when you call fact() with either
        an integer or a floating-point argument: the decision-process is called DISPATCHING,
        and we will see that it makes programming very much easier!
        
        What is the typeof the return value of the methods() function?
        """,
        "methods(fact)",
        x -> x == Base.MethodList
    ),
    Activity(
        """
        Since argument types are so important for dispatching functions, let's try creating our
        own user-defined types. First create a few ABSTRACT types to represent various
        biological organisms:
            abstract type Organism end
            abstract type Animal <: Organism end

        Now use the supertype() function to find the supertype of Animal. What type is
        returned if you ask for the subtypes() of Organism?
        """,
        "subtypes(Organism)",
        x -> (x <: Vector)
    ),
    Activity(
        """
        Next create a CONCRETE subtype of our abstract Animal type:
            struct Weasel <: Animal
                name::String
                weight::Integer
                female::Bool
            end

        Use the function fieldnames() to inspect the individual fields of the Weasel
        type, then give me the descriptor of the third field
        """,
        "fieldnames(Weasel)[3]",
        x -> x == :female
    ),
    Activity(
        """
        We use struct types to instantiate concrete OBJECTs in computer memory by
        entering specific values for the individual fields of the Weasel struct:
            wendy = Weasel( "Wendy", 101, true)
            willy = Weasel( "Willy", 115, false)

        Notice that types start with an UPpercase letter, whereas objects start with a
        lowercase letter. By default, Julia creates structs as IMMUTABLE - that is, we
        cannot modify the value of their fields. This means Julia can always know exactly
        how much memory an object needs, which provides major performance advantages. Try
        changing the value of Wendy's gender to see that this is not allowed. What word
        does the resulting exception message use to describe the struct you tried to modify?
        """,
        "wendy.female = false",
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
                length::Integer
            end

            rabia = Rabbit( "Rabia", 27)

        Change Rabia's length to 29 cm, then give Rabia to me to look at for myself:
        """,
        "rabia.length = 29",
        x -> (x.length == 29)
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
        multiple dispatching. Enter the following definitions at the Julia prompt:
            meet( meeter::Weasel, meetee::Rabbit) = "attacks"
            meet( meeter::Weasel, meetee::Weasel) = "challenges"
            meet( meeter::Rabbit, meetee::Rabbit) = "sniffs"
            meet( meeter::Rabbit, meetee::Weasel) = "hides"
            meet( meeter::Organism, meetee::Organism) = "ignores"
        
        Test these definitions by finding out what happens when Rabia meets Wendy:
        """,
        "meet(rabia,wendy)",
        x -> occursin( "hide", lowercase(x))
    ),
    Activity(
        """
        The dispatcher must make these decisions during the execution time of our
        simulation program. Enter the following function definition:
            function encounter( meeter::Organism, meetee::Organism)
                println( meeter.name, " meets ", meetee.name, " and ", meet(meeter,meetee), ".")
            end
        
        Now test this function by calling encounter() with various combinations of
        Wendy, Willy and Rabia.

        What happens if you create a new Rabbit called Robby, and Rabia encounters him?
        """,
        "meet(robby,rabia)",
        x -> occursin( "sniff", lowercase(x))
    ),
    Activity(
        """
        Now, to see the full power of multiple dispatching, add your own new concrete
        type and then check how an encounter between your type and Rabia works out. Do
        it something like this:
            struct Tree <: Organism; name::String end
            tilly = Tree( "Tilly")

        How does Rabia react to Tilly?
        """,
        "encounter(rabia,tilly)",
        x -> occursin( "ignores", lowercase(x))
    ),
    Activity(
        """
        And now one final Activity for you: Can you add a new type of Organism called
        Grass, and arrange for Rabia to eat it? It is possible to do this in just 3-4
        new lines of code.
        """,
        "encounter(meeter::Rabbit,meetee::Grass) = \"eats\"",
        x -> occursin( "eats", lowercase(x))
    ),
]