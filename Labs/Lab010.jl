#========================================================================================#
#	Laboratory 10
#
# Mathematical thinking
# (Based entirely on the book Mathematics Rebooted by Lara Alcock, 2017, OUP)
#
# Author: Niall Palfreyman, April 2025.
#========================================================================================#
let
include("../src/Development/Mathematics/MathTools.jl")
using DataFrames
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 010: Thinking about mathematics

        From here on in this Subject, we shall use our knowledge of computation and programming
        to think about the Mathematics. Mathematics is the scientific study of structure, and
        to understand it, we shall use the rather brilliant ideas in the small book "Mathematics
        Rebooted" by Lara Alcock (2017). Prepare to to have some fun thinking about maths ... :)
        """,
    ),
    Activity(
        """
        Have you ever heard of Pythagoras's Theorem? Or Fermat's Last Theorem? These are famous
        examples of the central activity of mathematics: to prove statements about structure that
        anyone, anywhere can use to solve problems. A Theorem is simply a Provably True
        mathematical statement such as:
            Theorem: The sum of two even numbers is always even.
            Theorem: A number is divisible by 9 if and only if the sum of its digits is divisible by 9.

        In this lab, we will learn about Pythagoras's Theorem and Fermat's Last Theorem by thinking
        about a subject you are already quite familiar with: Multiplying.

        Tell me whether you think the following statement is a true or false statement about numbers:
            If you multiply one odd number by another odd number, the result is an odd number!
        """,
        "Try out a few examples for yourself",
        x -> (x isa Bool) && x || x=="true"
    ),
    Activity(
        """
        Shown below is an Array diagram of the muliplication (3*5), showing 3 rows of 5 asterisks.
        Now tell me: How many stars are there in this array diagram?
        """,
        :(MathTools.array_diagram(fill('*',3,5))),
        "Try counting them! :)",
        x -> x==15
    ),
    Activity(
        """
        Here is a new array diagram of the muliplication (5*3), showing 5 rows of 3 stars. Now tell
        me: How many stars are in this diagram?
        """,
        :(MathTools.array_diagram(fill('*',5,3))),
        "Try counting them! :)",
        x -> x==15
    ),
    Activity(
        """
        You may think this result seems a little trivial, but isn't it really quite brilliant?
        Just by turning your head on its side, you can see that 3*5 has exactly the same value as
        5*3 ! And, of course, this is true of the product (m*n) of Any two integers (that is,
        whole numbers) m and n! :-o

        Since we can represent the product of any two integers m and n as an array of rows and
        columns, we know that we can Always swap the order of multiplication:
            m * n == n * m

        We describe this swapping property by saying that multiplying is c_________e!
        """,
        "reply() me the correct word as a string",
        x -> occursin("commut",lowercase(x))
    ),
    Activity(
        """
        Multiplication is Commutative. That is to say, we can swap the two numbers in a product
        without it changing the product's value at all! And guess what? This commutative property
        saves us a Huge amount of work! Let me tell you a little secret ...

        Mathematicians are fundamentally lazy - in fact, they are too lazy to fail!
        
        For instance, suppose you, as a mathematician, want to memorise the times-table of numbers
        up to 10. Since 3*5 is the same as 5*3, you must only memorise the single product: 3*5 == 15

        In fact, the 1's and 10's are so easy that you actually don't need to remember them at all!
        Study this times-table and tell me how many distinct products you need to memorise:
        """,
        quote
            N = 10
            DataFrame(
                [((i in [1,N] || j in [1,N] || i>j) ? "." : string(i*j)) for i in 1:N, j in 1:N],
                string.(1:N)
            )
        end,
        x -> x==36
    ),
    Activity(
        """
        In particular, mathematicians dislike remembering facts - they prefer to reconstruct those
        facts for themselves using general relationships. In fact,
            Mathematics is the study of Structures, and how to discover, manipulate and use them.

        Some structures are more useful than others. For example, our array of 3*5 asterisks shows
        us immediately that 3*5 == 5*3. But that is not the case for this structure of 15 asterisks:
        """,
        :(MathTools.array_diagram(fill('*',1,15)))
    ),
    Activity(
        """
        Nor is it at all easy to see three fives in this random jumble of 15 asterisks:
        """,
        :(MathTools.array_diagram(fill('*',3,5),:jumble))
    ),
    Activity(
        """
        This brings us to another interesting point... We discover new structures by scanning our
        experience for relationships that are Invariant (i.e., stay the same) when we look at them
        in different ways. For example, look at the following alternative ways of looking at an
        array of 15 asterisks, and notice how the number (15) of asterisks does Not Vary (i.e., is
        invariant), whether we think of that array as consisting of columns or of rows:
        """,
        quote
            MathTools.array_diagram(fill('*',3,5),:vbar)
            println()
            MathTools.array_diagram(fill('*',3,5),:hbar)
        end,
    ),
    Activity(
        """
        In fact, the entire reason why commutativity is so useful, is because it describes an
        Invariant property of products: The value of the product is invariant whether we think of
        this array as 3 rows of 5, or 5 rows of 3, asterisks. In mathematics, it is helpful if we
        can find structures like this array, that make invariances very easy to notice.

        For example, the following structure makes it easy to notice that another operation between
        numbers is also commutative. What is the name of this new commutative arithmeticoperation?
            * * * * * * *!* * *

            * * *!* * * * * * *
        """,
        x -> occursin("add",lowercase(x))
    ),
    Activity(
        """
        So both multiplication and addition are commutative. An example of a Non-commutative
        arithmetic operation is Subtraction, since:
            10 - 3 ≠ 3 - 10

        Can you tell me another arithmetic (that is, number-) operation that is Non-commutative?
        """,
        "",
        x -> any( map(["/","^","div","pow","exp"]) do op
                occursin( op, lowercase(x))
            end
        )
    ),
    Activity(
        """
        Let's return now to the Commutative arithmetic operations of multiplication (*) and
        addition (+). These are linked by another invariance property called Distributivity. We
        say that "Multiplication distributes over addition", which for example means that:
            4 * (3 + 5) = (4 * 3) + (4 * 5)

        I find it helpful to read the brackets in expressions like this by speeding up inside
        brackets and slowing down between them, so ...
            "Four times three-plus-five equals four-times-three plus four-times-five"

        How would you read this: (3 + 4) * 5 ?
        """,
        "Practise saying it several times out loud",
        x -> occursin("three-plus-four",lowercase(x)) && occursin("times five",lowercase(x))
    ),
    Activity(
        """
        Just as with commutativity, we can represent distributivity using arrays, only now we will
        find it easier to display this structure in a graphics window. If you don't see this
        graphics window immediately, bring it into the foreground on your screen now ...

        This is an array representation of the distributive multiplication of 4*(3+5). Notice how
        the total number of dots (32) in the array is invariant, whether we think of it as 4 rows
        of (3+5) dots, or as two groups of (4*3) and (4*5) dots.
        """,
        :(MathTools.dots_diagram(4,[3,5]))
    ),
    Activity(
        """
        There are a couple of things we should remember about brackets in mathematics. Let's start
        the distributive multiplication we've just been looking at:
            4 * (3 + 5) = (4 * 3) + (4 * 5)

        First, you may remember that we can leave out the multiplication sign in front of brackets:
            4(3 + 5) = (4 * 3) + (4 * 5)

        Also, since multiplication takes priority over addition, we could also write this as:
            4(3 + 5) = 4*3 + 4*5

        Make up your own mind which of these three forms you prefer. I like the brackets on the
        right-hand side of the first one, because they make clear the distributive structure of the
        equation. It's useful to have different notations for the same structure, because they help
        us to view that structure in different ways.

        We don't drop the multiplication sign between the 4 and 3, because that would look like ...?
        """,
        "",
        x -> x == 43
    ),
    Activity(
        """
        Distributivity gets even more interesting when we think of multiplying two brackets:
            (4 + 2) * (3 + 5) = (4*3 + 4*5) + (2*3 + 2*5)

        Notice how distributivity here works in two stages: we distribute each term in the first
        bracket over each term in the second bracket. Which (if any) of the following expressions
        are the correct result of multiplying out the brackets (a + b) * (c + d) ... ?
            1.  (a + b) * (c + d) = (a*c + a*d) + (b*c + b*d)
            2.  (a + b) * (c + d) = (a*c + b*d) + (a*b + c*d)
            3.  (a + b) * (c + d) = (a*c + b*d) + (a*d + b*c)
        """,
        :(MathTools.dots_diagram([4,2],[3,5])),
        "Give me a vector of the numbers of any correct answers",
        x -> Set(x) == Set([1,3])
    ),
    Activity(
        """
        At this point, our dot array diagrams are getting a little cumbersome, and also we shall
        shortly be looking at how to multiply fractions. For these reasons, it will help if we
        switch to using Area Diagrams to represent multiplication. In these digrams, instead of
        representing whole integer numbers by dots, we shall represent fraction and decimal numbers
        by squares that each have area 1.0. This doesn't change anything really, but it will help
        us later to generalise our findings to new situations. Here is an area diagram for our
        previous example:
            (4 + 2) * (3 + 5) = 4*3 + 4*5 + 2*3 + 2*5

        Notice how the area of the whole diagram is invariant, whether we think of it as a single
        rectangle of area 6*8, or as the sum of the four smaller rectangles of areas 4*3, 4*5,
        2*3 and 2*5. What is the area of this whole diagram?
        """,
        :(MathTools.area_diagram([4,2],[3,5])),
        "Count the squares in the coloured area",
        x -> x == 48
    ),
    Activity(
        """
        Has anyone ever told you that "Multiplication makes things bigger"? Well, for the numbers
        we've looked at so far, this heuristic (or: rule of thumb) is true - for example,
        4*3 = 12, which is bigger that either 4 or 3. But it is Not true for all numbers! For
        example, think about:
            1/2 * 6 = 3,

        which is bigger that 1/2, but Smaller than 6. Apparently, multiplication can also make
        things smaller! And now look at this area diagram of 1/2 * 1/3 ...

        Is the result of this multiplication bigger than either of the two factors 1/2 and 1/3
        that we are multiplying together here?
        """,
        :(MathTools.area_diagram(1//2,1//3)),
        "How much of one complete square is yellow?",
        x -> occursin("no",lowercase(x))
    ),
    Activity(
        """
        So you see that the heuristic "Multiplication makes things bigger" is really not true for
        all numbers. So is there anything in multiplication that we can really rely on - anything
        that we can guarantee is true for Any product of two numbers? Look at the area diagram of
        the following product:
            1/2 * (2 + 4)

        Is the area of this diagram invariant under distributivity? That is, is its area the same
        as the sum of the areas of the two smaller rectangles?
        """,
        :(MathTools.area_diagram(1//2,[2,4])),
        "Count the squares in the various coloured areas",
        x -> occursin('y', lowercase(x))
    ),
    Activity(
        """
        The law of distributivity of multiplication over addition Is still true! And by swapping
        the two factors (factor 1 and factor 2), you can see that commutativity is also true. In
        fact, commutativity and distributivity are much more than just useful tricks: they are deep
        structural properties of multiplication and addition, and this makes them Really useful!

        You can test this for yourself using the Julia method MathTools.area_diagram(), which I
        originally implemented in order to generate the area diagrams you've been looking at up
        until now. In the REPL, include the file MathTools.jl from the Anatta subdirectory
        "Development/Mathematics", then enter the following method call at the Julia prompt:
            MathTools.area_diagram( [2,1//2], [6,4])

        This displays the distributivity rule for the arithmetic expression
            (2+1/2) * (6+4)

        Does this diagram confirm the distributivity rule?
        """,
        "",
        x -> occursin('y', lowercase(x))
    ),
    Activity(
        """
        Now experiment for yourself, using MathTools.area_diagram() to test the distributivity
        rule. The first argument is factor 1, expressed as a vector list of additive terms;
        likewise for the second argument (factor 2). Try out any form for the factors that you
        like - you can even try using negative terms inside the brackets like this:
            (4-2) * (3+1)

        In the resulting diagram, positive areas are yellow, and negative areas are red. Orange
        areas are positive and negative products that cancel each other out, and so do not
        contribute to the final result of the multiplication. Any white areas lie outside the
        multiplication and also do not count towards the final result of the multiplication.

        Your mission: Can you convince yourself that commutativity and distributivity apply to
        multiplication and addition of All Possible real numbers, whether positive, negative,
        fractions, decimals or factors containing three or more terms?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Well done for working through the activities in this lab! The cross that all mathematicians
        must bear is that our subject seems so trivial to the rest of the world: Of Course 3*2 is
        the same as 2*3! So why do we need to talk so long about it?!
        
        Hopefully, through this lab you have now gained some insight into why commutativity is such
        a useful property of multiplication, and one that we cannot take for granted! For example,
        division is NOT commutative: 2/3 != 3/2. The job of mathematicians is to find out exactly
        when and how we can make use of structural properties like commutativity.

        Also, you have seen a little of the power of the julia graphics that we used to visualise
        these mathematical structures. To continue with this investigation, I would like you now to
        skip straight to lab 110 to find out how to generate your own graphics:
            lab!(110)
        """,
        "",
        x -> true
    ),
]

end