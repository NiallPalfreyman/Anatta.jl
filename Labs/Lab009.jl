#========================================================================================#
#	Laboratory 9
#
# Writing scientific code for human understanding.
#
# NOTE: This lab makes heavy use of George Datseris' eratosthenes() example from his
#		excellent course Good Scientific Code at: https://github.com/Datseris/ .
#
# Author: Niall Palfreyman, 07/09/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 009: Writing simple, understandable code

        OK, now it's time to start writing good code for real scientific computing. Remember what
        I said earlier in this course: Good scientific code is clear text whose purpose is to
        communicate to others your understanding of how to solve a particular problem. I have
        allowed plenty of time for you to complete this chapter, because it is so important that we
        learn to write clean scientific code. Please take time to work thoroughly through the
        exercises in this lab. In VSC, open the following file from your home folder:
            Development/Computation/Utilities.jl

        With your text cursor inside the file Utilities.jl in VSC, press the Play button at the
        top-right of VSC - this will include the file and open a julia console in VSC.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Utilities.jl contains a module named Utilities, and in this module is a method named
        eratosthenes_bad(). This method generates prime numbers up to a user specified maximum N.
        It implements the algorithm known as the Sieve of Eratosthenes, which is quite simple:
            Given an array of integers from 1 to N, cross out all multiples of 2. Find the next
            uncrossed integer, and cross out all of its multiples. Repeat this until you have
            passed the square root of N. The remaining uncrossed numbers are then all of the
            prime numbers less than N.

        Test the eratosthenes_bad() method now. Enter the following at the julia prompt:
            Utilities.eratosthenes_bad(100)

        What answer do you get?
        """,
        "",
        x -> x == [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
    ),
    Activity(
        """
        This eratosthenes_bad() method has been ported directly from Java, and so does not make use
        of higher-level features offered by Julia. I have copied the implementation of
        eratosthenes_bad() into a second method eratosthemes_good() - the code is identical. You
        will now adapt the code in eratosthenes_good() to create your own better implementation.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        First, think carefully about function and variable NAMES. The purpose of the name of a
        function or variable is always to indicate to readers how you intend to use the function or
        variable. Names communicate to readers the INTENTION of your code.

        In Julia, these names should always be in lower case, with multiple words separated by _.
        The name should be brief, but understandable for strangers reading your code (for example,
        NOT: rsdt, rsut and rsus!). Also, NEVER use constant literals in your program, for example,
        not '2022', but rather: 'year=2022', and then use 'year' in your code. The problem, of
        course, is that literals say nothing about your intentions.

        Start by changing the name of your method. "eratosthenes_good" is really not a useful name;
        change it to "eratosthenes", then recompile and test to make sure that it works properly.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now consider the first 8 lines of eratosthenes(). The intention of these lines is to set up
        a particular structure (or variable) - what is the name of this structure?
        """,
        "Which variable is built up in steps over the course of these 8 lines?",
        x -> x=="f" || x==:f
    ),
    Activity(
        """
        What is the intention of the structure f in the code that follows? What name would better
        describe this intentions?
        """,
        "is_prime?",
        x -> occursin("prime",lowercase(x))
    ),
    Activity(
        """
        I will assume in the following that you have chosen the name `is_prime`, but feel free to
        use your own name if you think of a better one. Rename the variable throughout the
        eratosthenes() method, then recompile and make sure that the method still runs correctly.
        """,
        "",
        x - true
    ),
    Activity(
        """
        Now go through all names of variables/functions in your eratosthenes() method to make the
        code easier to follow and understand. Don't change the code operations - only the names!
        (And remember to recompile and test afterwards! :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now focus again on the first 8 lines of eratosthenes(). Why has the author set i=0 before
        the loop (remember this function was ported from Java)? Do we need this line in julia?
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        So cross out the initialisation of i, and then think: Do we even use i in the loop? If not,
        its name is misleading, and might be replaced by `_`.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now think about how is_prime is constructed in several steps. Each step takes time, and
        poor julia cannot know in advance how long the final Vector is going to be, so has to
        reallocate it each time is_prime becomes too short for a newly pushed element.
            
        But of course in julia, we can use comprehension to allocate the complete is_prime Vector
        in one line, so please do that now ...
        """,
        "Just to remind you, here is an example of comprehension: [x*(1-x) for x in 0:0.1:1]",
        x -> true
    ),
    Activity(
        """
        Bingo! You have now replaced the first 8 lines of eratosthenes_bad by a single line! :)
        (Btw, you could also use the trues() function to do the same job, if you wish)

        Now we'll continue this work, at each stage deciding what the intention of some section of
        the code is, then thinking how we might achieve this more efficiently...

        For example, we can improve the efficiency of our eratosthenes() method by making use of
        Julia's built-in functions from the standard library. Look up the findall() function in
        julia's help; this function finds the indices of all true elements in an array. Use
        findall() now to replace the entire final section of eratosthenes().
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now look at the nested for-loop that crosses out multiples in the is_prime Vector. Can you
        make this code a little easier to read by using julia's abbreviated notation for
        multiplication by a numerical constant?
        """,
        "5x means the same as 5*x",
        x -> true
    ),
    Activity(
        """
        Julia is a FUNCTIONAL programming language. That is, you break your code down into reusable
        functions that each perform a single, specific task. It is very important that a function
        has JUST ONE responsbility, and that its name clearly indicates that specific task that the
        function performs. Higher level functions are composed out of lower-level functions. Also,
        function methods are SHORT: usually between 3-30 lines of code. Long methods and long
        method names usually indicate that your method has more than one responsibility.
        
        Functional programming dramatically increases the reusability of our code, and also reduces
        the risk of duplicating code, which can often lead to runtime errors!

        Use functional programming to pull the nested crossing-out loops out of eratosthenes() into
        a separate function whose SINGLE intention is to crossout_prime_multiples!().
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now we will work on the COMMENTS in your eratosthenes() method. By now, you should find
        that you don't actually need many comments. Quite generally, I can fairly state that:
            - Comments compensate for our failure to express ourselves clearly in code!

        A great problem with comments is that they are difficult to maintain as your code changes,
        and an out-of-date comment is much more misleading than no comments at all! However, there
        is a much better way of documenting your code:
            - Instead of writing comments for complicated code, write SIMPLE, SELF-EXPLANATORY CODE!
        
        Here are my comment rules:
            - Never use CAPITALISED comments - they look like shouting, and distract the reader.
            - Use comments only to point out the high-level intentions or risks of your code.
            - Place comments at the start of a code block, or aligned(!) at the right of a codeline.
            - Replace header comments by docstrings that precede functions, datatypes and modules.

        Now apply these rules to the comments in your eratosthenes() method.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Use VERTICAL formatting to divide your code into blocks with a consistent internal logic -
        like paragraphs in an essay. Place a comment box at the top of each logical section of a
        source file to communicate the intention of that section, and use blank lines ONLY to
        divide logically distinct trains of thought from each other. You will Never need to put a
        comment box inside a method.
        
        Improve the vertical formatting of the Utilities module now.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        HORIZONTAL formatting is often determined by your company's style-guide, but general
        rules are:
            - Code lines always have a maximum length - use 100 characters in this course.
            - All binary operators (including =) have enclosing white spaces, except for: *, ^, /.
            - Each new code block (for/map loops, functions, ifs) adds 4 spaces of indentation.
            - Floating-point literals always have a leading/trailing zero (e.g.: 0.5 or 5.0)

        Make these alterations to your eratosthenes() method now.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Finally, compare carefully your improved code with the code of George Datseris' solution,
        which I have implemented in Utilities.jl as the function senehtsotare(). Make any
        additional changes that you think appropriate to your eratosthenes() function.
        """,
        "",
        x -> true
    ),
]