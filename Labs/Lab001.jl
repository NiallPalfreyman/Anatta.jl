#========================================================================================#
#	Laboratory 1
#
# Introduction to Julia, variables and functions.
#
# Author: Niall Palfreyman, 08/05/2023
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 001:
            Computation - Using structures to explore and predict the world

        Anatta is a course in thinking about the complex issues around Wholeness, Life, biological
        Autonomy and Learning. This first 0-level Anatta Subject introduces you to the computer
        language julia, which we shall use to investigate the concept of Anatta. We will use
        activities and questions to explore the basics of programming in any computer language.
        Feel free to experiment at any time by entering your own commands at the julia prompt! :)
        
        I will interpret anything you enter as an argument of the function reply() as an answer to
        the current question. Try this now - at the julia prompt, enter the following code:
            concept = "Anatta"

        Then enter your answer as:
            reply(concept)
        """,
        "We're still getting started - simply follow the above instructions precisely. :)",
        x -> (x=="Anatta")
    ),
    Activity(
        """
        You have just created a Variable - that is, a name for a type of data in computer memory.
        In this particular case, the name of the variable is "concept", and the contents of that
        variable is the String of characters "Anatta". Whenever I want to refer in this text to
        some julia code, I will either write it on a new line like this:
            x = 5

        or else I will write it within the text enclosed in backticks, like this: `sin(x)`. Enter
        each of these two lines of code now, then tell me your result like this:
            reply(sin(x))
        """,
        "",
        x -> abs(x-sin(5)) < 0.1
    ),
    Activity(
        """
        Every variable has a Type that determines how julia will handle it. Find out the type of
        your new variable x now:
            typeof(x)

        then reply() me the result of your inquiry:
        """,
        "",
        x -> x <: Int
    ),
    Activity(
        """
        The environment that you are interacting with right now is called the julia REPL (Read-
        Execute-Process-Loop) - it is signalled by the julia prompt "julia>". You can use the julia
        REPL like a calculator. All the arithmetic operations (+,-,*,/,^) have their usual
        priorities, so tell me the result of entering `(3+4)*5`.

        As always, use reply() to tell me your result ...
        """,
        "reply((3+4)*5)",
        x -> x==35
    ),
    Activity(
        """
        OK, now before we move on, I want to explain something very important...

        I want you to learn from this course. I'll be giving you information and activities for you
        to do, or sometimes, but you will ONLY learn if you try things out for yourself!
        So make sure with each learning activity that you always follow these useful learning tips:
            -   If I ask you to do something, like calculating `(3+4)*5`, try also doing something
                slightly different, such as `(3+4)/5`, to increase your understanding efficiently.
            -   The Scripts subfolder of your Anatta home folder contains the full documentation
                for julia. If I say Anything that you don't understand, just look it up in there.
            -   If I use a julia function whose meaning you are curious about, try pressing `?` at
                the julia prompt, then entering the name of the function. This provides quick help.

        Try this now: Enter `?sin`, then reply() me whether this statement is `true` or `false`:
            "The function sin(x) computes the sine of x, where x is in degrees."
        """,
        "Look carefully at the units of the angle x",
        x -> x==false
    ),
    Activity(
        """
        A very useful feature of the Julia REPL is that you can always retrieve the result of
        your previous calculation by entering `ans` at the Julia prompt. Press up-arrow a few
        times until you see your previous calculation `(3+4)*5`. Enter this calculation, and
        then enter `ans` at the Julia prompt. What value is returned?
        """,
        "35",
        x -> x==35
    ),
    Activity(
        """
        Remove the brackets: `3+4*5`. First calculate this value, then retrieve it again
        by entering the variable `ans`. Finally, show me the value using `reply(ans)`:
        """,
        "23",
        x -> x==23
    ),
    Activity(
        "What answer do you get if you remove the multiplication sign: `5(3+4)`?",
        "35",
        x -> x==35
    ),
    Activity(
        "What do you get if you use floating-point division `1 + 1/7`?",
        "$(1+1/7)",
        x -> abs(x-(1+1/7)) < 0.01
    ),
    Activity(
        "Or you can use exact division to produce a rational number `a = 1 + 1//7`:",
        "$(1+1//7)",
        x -> x == 1+1//7
    ),
    Activity(
        "You can then convert this to a floating-point number: `Float64(a)`",
        "$(1+1/7)",
        x -> abs(x-(1+1/7)) < 0.01
    ),
    Activity(
        """
        Functions are centrally important in julia, and the language offers us three
        different ways of defining them. Use this format to define your own squaring
        function, then use it to compute the square of -253:
            function sq1( x)
                x * x
            end
        """,
        "64009",
        x -> x == 64009
    ),
    Activity(
        """
        Now use this shorter format to define a new squaring function, and use it to
        compute the square of the imaginary number 5im:
            sq2( x) = x * x
        """,
        "-25",
        x -> x == -25
    ),
    Activity(
        """
        Finally, functions are so important in Julia that we often want to create an
        anonymous function quickly in the middle of a calculation. Use the following
        anonymous notation to compute the square of the complex number 1+im:
            (x -> x*x)(1+im)
        """,
        "2im",
        x -> x == 2im
    ),
    Activity(
        """
        Use tuples to assign values in parallel to the variables x and y:
            (x,y) = (2,3)

        Then give me (as a string) the code to swap the values of x and y:
        """,
        "(x,y) = (y,x)",
        x -> (r=replace(x," "=>""); r == "(x,y)=(y,x)" || r == "(y,x)=(x,y)")
    ),
    Activity(
        """
        You can use conditionals in the usual way, for example we might implement the
        "absolute value" function like this:
            function f(x)
                if x ≥ 0
                    x
                else
                    -x
                end
            end

        Now use the shorter notation "x ≥ 0 ? x : -x", and assign g equal to an anonymous function
        that calculates the factorial of its argument. That is, g(n) returns 1 if n ≤ 1, and
        returns n * g(n-1) otherwise. Use g to calculate 9!:
        """,
        "n -> (n ≤ 1 ? 1 : n * g(n-1))",
        x -> (x == 362880)
    ),
    Activity(
        """
        We use double quotation marks to denote Strings. Find out the typeof() "Niall":
        """,
        "typeof(\"Niall\")",
        x -> (x == String)
    ),
    Activity(
        """
        We can concatenate two or more Strings into a single String using the operator *.
        Define the two strings:
            name1 = \"Ani\"
            name2 = \"Anatta\"

        What result do you get if you concatenate these two Strings?
        """,
        "name1 * name2",
        x -> (x == "AniAnatta")
    ),
    Activity(
        """
        I prefer my name with a space between the first and second names. We can do this
        using the call join([name1,name2]," "). What String results from this?
        """,
        "\"Ani Anatta\"",
        x -> (x == "Ani Anatta")
    ),
    Activity(
        """
        We can pattern text more simply using STRING INTERPOLATION. Enter this code:
            "\$name1 \$name2\"

        The dollar sign (\$) interpolates the values of name1 and name2 into the string.
        Enter the following code and then see if you can work out the return value of
        the function println():
            x = π/2; println("The sine of \$x is \$(sin(x)).")

        (Note: You can enter the symbol π by typing "\\pi" and then pressing Tab.
        Alternatively, you can replace this symbol by the named constant "pi".)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Julia offers us many different functions for manipulating strings. Let's start
        by creating a String that we can play around with:
            a_string = "We are one and we are many, and from all the lands on Earth we come."

        Now ask whether the substring "Earth" occurs in the string a_string: What is the
        return value of the function call occursin("Earth",a_string)?
        """,
        "",
        x -> x == true
    ),
    Activity(
        """
        What value does the function call startswith(a_string,"We are") return?
        """,
        "",
        x -> x == true
    ),
    Activity(
        """
        What value does the function call endswith(a_string,"Earth") return?
        """,
        "",
        x -> x == false
    ),
    Activity(
        """
        Try out the following function calls: lowercase(a_string), uppercase(a_string)
        and titlecase(a_string).
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Try out the call: replace(a_string, "lands" => "countries"). Then find out the
        type of the second argument of this function call:
        """,
        "typeof(\"lands\" => \"countries\")",
        x -> (x <: Pair)
    ),
    Activity(
        """
        The call split(a_string, " ") divides a_string into tokens separated by the
        space symbol " ". How many tokens arise if we split a_string using the
        separator "an"?
        """,
        "split(a_string,\"an\")",
        x -> x == 5
    ),
    Activity(
        """
        We can convert numbers to strings. For example, what result do you get if
        you enter string(2.718)?
        """,
        "",
        x -> x == "2.718"
    ),
    Activity(
        """
        And converting back again, what result do you get if you enter
        parse(Float64,"2.718")?
        """,
        "parse() parses argument 2 according to the type of argument 1.",
        x -> x == 2.718
    ),
    Activity(
        """
        Computer-programming is nothing other than Problem-Solving. Before completing this lab, I
        want to introduce you briefly to three Very Important problem-solving concepts: Branching,
        Iteration and Recursion. All three techniques show us how to solve big, complicated
        problems by breaking them down into smaller problems:
            -   Branching: If I go to visit my daughter, I either cycle or take the bus. As soon as
                I choose one means of travel, I no longer have to worry about how to do the other;
            -   Iteration: If I want to read a book, I read page 1, then I read page 2, then 3, 4,
                and so on. I apply the same skill of reading to one page after another;
            -   Recursion: If I want to travel from here to Mullaitivu, I plan travel between the
                two nearest airports, then I plan travel between those airports and my destination
                and home towns, then between the two towns and my exact destinantion and home
                addresses. I use travel-planning skills to solve smaller and smaller sub-problems.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We will use the factorial problem to explore these three techniques. To calculate the
        factorial of the number 5 - factorial(5) - we multiply together all of the positive
        integers less than or equal to 5:
            factorial(5) == 1 * 2 * 3 * 4 * 5 == 120
        
        The factorial problem is the task of calculating this value. First, explore the julia
        factorial() function at the julia prompt, for example:
            factorial(3) returns the value: 6
        
        What is the value of factorial(0)?
        """,
        "Type in factorial(0)",
        x -> x==1
    ),
    Activity(
        """
        OK, let's use Branching to solve for ourselves the problem of how to calculate the
        factorial of a number. First, notice that 0 is a special case: factorial(0)==1. We cannot
        calculate this value by multiplying numbers together, because multiplying by 0 always
        returns the value 0. Instead, we must use branching to choose whether we want to multiply
        numbers together or simply return the value 1:
            function fact(n)
                if n < 1
                    1
                else
                    5
                end
            end

        This function doesn't yet do a very good job of calculating factorial when n is greater
        than 1, but it does a GREAT job of calculating the special case fact(0)! :) Enter this code
        and check that it calculates fact(0) correctly ...
        """,
        "",
        x -> x==1
    ),
    Activity(
        """
        OK, now Iteration. We've used branching to solve the special case of n==0, but now we need
        to solve the factorial problem for other numbers. We want to multiply together all integers
        less than or equal to n. We'll handle the case n==0 in the if-branch, and use a for-loop to
        Iterate through the multiplications:
            function fact(n)
                if n < 1
                    1
                else
                    f = 1
                    for i in 2:n
                        f = i*f
                    end
                    f
                end
            end

        This implementation keeps multiplying by numbers (i) between 2 and n, until it has
        calculated the result. Enter the code and check it calculates factorial(5) correctly ...
        """,
        "",
        x -> x==120
    ),
    Activity(
        """
        Finally, let's look quickly at Recursion - breaking problems down into smaller and smaller
        chunks that are easier to solve. We have already found an adequate iterative solution to
        the factorial problem; however, there are many problems such as the travel planning problem
        that we cannot solve using iteration. In such cases, Recursion is often useful. Even though
        we don't need it for the factorial problem, this problem shows us how to use Recursion in
        other, more complicated, situations ...

        First, notice that:
            -   factorial(100) == 100 * 99 * 98 * ... * 5 * 4 * 3 * 2 * 1
            -   factorial(99)  ==  99 * 98 * 97 * ... * 5 * 4 * 3 * 2 * 1

        So by which number must we multiply factorial(99) in order to get factorial(100)?
        """,
        "",
        x -> x==100
    ),
    Activity(
        """
        We can build this idea into a Recursive solution to the factorial problem, in which our
        fact() function now calls itself (Recursion means "calling itself"):
            function fact(n)
                if n < 1
                    1
                else
                    n * fact(n-1)
                end
            end

        Notice how this recursive method is much more compact and intuitive than our iterative
        method. That is the main advantage of recursion: recursive solutions are easier to
        understand. Check that our new fact() method works correctly ...
        """,
        "",
        x -> true
    ),
]