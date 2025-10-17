#========================================================================================#
#	Laboratory 2
#
# Introduction to computational thinking and data science.
#
# Author: Niall Palfreyman, 16/05/2023
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 002: Computational thinking and data science

        Now that we have gained some experience using variables, let try doing some data science -
        that is, we will read in some data and use computation to analyse it. First, set up the
        Computation library by calling this function at the julia prompt:
            setup("Computation")

        This copies the Computation files into the Development folder of your Anatta home folder.
        Use the functions cd() and readdir() to explore the structure and contents of the
        Computation library. When you have finished, use home() to return to your Anatta home
        folder and reply() me the name of one of the two .dat files in the Computation library:
        """,
        "Give me the file-name as a double-quoted string, like this: reply(\"filename\")",
        x -> occursin("pax6_",x)
    ),
    Activity(
        """
        In a moment, we will read one of these data files into julia. However, since we shall be
        reading the file into a Vector, we should first understand what a Vector is.

        A Vector is a list of items (elements) contained in square brackets. It can contain all
        different kinds of elements. For example, enter this definition of the Vector b:
            b = [3,5,"4",[1,2]]
            
        Then use length() to find the length of b:
        """,
        "length(b)",
        x -> x == 4
    ),
    Activity(
        "Use b[2] to access the 2nd element of b, and use the function isodd() to see if it is odd:",
        "isodd(b[2])",
        x -> x == true
    ),
    Activity(
        "What is the type of (typeof) the 4th element of b?",
        "Vector{Int64}",
        x -> (x <: Vector)
    ),
    Activity(
        "Change the 3rd element of b to my name \"Ani\" and find the length of that 3rd element",
        "b[3] = \"Ani\"",
        x -> x == 3
    ),
    Activity(
        """
        OK, now we've built up some experience with Vectors, let's use them to analyse data...

        First, set up an input stream named `is` by opening the file "pax6_hs.dat" for reading ("r").
        Assuming you are currently in your Anatta home folder, enter:
            is = open("Development/Computation/pax6_hs.dat","r")

        Then reply() me the type of the new variable `is` ...
        """,
        "When you are finished, `is` should be an IOStream",
        x -> x <: IOStream
    ),
    Activity(
        """
        Now read the first line of "pax6_hs.dat" from the input stream `is` by entering:
            readline(is)

        What is the typeof() your answer?
        """,
        "",
        x -> x <: String
    ),
    Activity(
        """
        This is a String of characters, all of which are either 'A', 'C', 'G' or 'T'. It looks like
        genome data. Let's look at the next line:
            readline(is)
        
        Yes, that's genome data alright. Let's try playing around with it. First, rewind to the
        start of the file and read in the first line again, storing it in the variable `data`:
            seekstart(is)
            data = readline(is)

        reply() me the first 5 characters of `data` using the code `data[1:5]`:
        """,
        "reply(data[1:5])",
        x -> x == "GCATG"
    ),
    Activity(
        """
        What is the length of the data string?
        """,
        "length(data)",
        x -> x == 70
    ),
    Activity(
        """
        Now let's find out at which data locations the nucleotide guanine (G) is specified:
            findall('G',data)

        You can check that these locations are correct by selecting those elements from data:
            data[ans]

        You should get a string consisting only of the character 'G'.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        What is the G-content of the data:
            length(findall('G',data)) / length(data)
        """,
        "",
        x -> 0.328<x<0.329
    ),
    Activity(
        """
        Hm. This is interesting. On average, I would expect the G-content to be around one-quarter,
        or 0.25, but this value is significantly higher. Let's look at the content for all four
        nucleotides. We could write our question like this:
            [   length(findall('A',data))/length(data),length(findall('C',data))/length(data),
                length(findall('G',data))/length(data),length(findall('T',data))/length(data)
            ]

        but this way of writing it seems very repetitive. julia offers us another way of doing
        this: we use the keyword `do` to build a function that asks our question for a single
        nucleotide, then we map that function over a list (i.e. Vector) of the four nucleotides.
        reply() me the result of this mapping process:
            map(['A','C','G','T']) do nucleotide
                length(findall(nucleotide,data))/length(data)
            end
        """,
        "Your answer should be a Vector of four numbers adding up to 1.0000",
        x -> 0.9999<sum(x)<1.0001
    ),
    Activity(
        """
        There is quite a difference in the content values for the four nucleotides, but of course
        we are only investigating 70 characters of the genome. Let's read in all of the PAX6 data
        for Homo sapiens:
            seekstart(is)
            data_hs = readlines(is)
            close(is)

        You can see that data is now a Vector of Strings - one for each line of the file. How many
        lines have been read from the file?
        """,
        "length(data_hs)",
        x -> x==39
    ),
    Activity(
        """
        39 lines of 70 nucleotides each - that's about 2700 nucleotides. To measure the nucleotide
        content, we're going to have to put all these strings together into one long string. julia
        offers us a way of doing this - to concatenate two strings, we multiply them. Tell me the
        result of concatenating these three strings:
            "Ani" * " " * "Anatta"
        """,
        "",
        x -> x == "Ani Anatta"
    ),
    Activity(
        """
        Great. Now, the operator '*' is just a short notation for the function prod(). For example,
        check out the result of this expression:
            prod([2,3,4])
        
        Then reply() me the result of this expression:
            prod( ["Ani"," ","Anatta"])
        """,
        "",
        x -> x == "Ani Anatta"
    ),
    Activity(
        """
        So prod() multiplies together the elements of a Vector. But of course, `data_hs` is a
        Vector of Strings, so we can concatenate these Strings using this function call:
            pax6_hs = prod(data_hs)

        Now we can measure the nucleotide content for the entire PAX6 gene:
            map(['A','C','G','T']) do nucleotide
                length(findall(nucleotide,pax6_hs))/length(pax6_hs)
            end

        Which nucleotide has the highest content in the PAX6 gene for Homo sapiens?
        """,
        "",
        x -> x == 'A'
    ),
    Activity(
        """
        To investigate further, instead of just calling functions from the julia prompt, we will
        write programming code. When you set up the Computation library earlier, you also copied
        into your Anatta home folder the julia file Computation.jl, which we'll now fill with code.

        Before proceeding further, I will assume in the next learning activities that you ...
            -   have VSC open with its Explorer located at your Anatta home folder;
            -   can see the contents of your Development/Computation folder in VSC Explorer;
            -   can see that this Development/Computation folder contains Computation.jl and the
                PAX6 datafiles pax6_hs.dat and pax6_mm.dat for Homo sapiens and Mus musculus;
            -   have opened the file Computation.jl in the VSC editor;
            -   have a separate julia console open, in which you are reading this text;
            -   have created in this console the two variables data_hs and pax6_hs from the file
                pax6_hs.dat. We will use the shorter strings contained in data_hs as practice data
                before working on the full gene contained in pax6_hs ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Right, so let's start programming! :)

        First, take a moment to scan through the file Computation.jl. If you go to line 9, you will
        notice that it defines a module called Computation. If you then allow your cursor to hover
        over the final `end` at the end of the file, VSC will tell you that this marks the end of
        the module Computation. Between these two lines is a whole set of methods contained in the
        Computation module - for example, the method count_seq(). This is the usual structure of
        any julia program: a single module containing methods and often an associated data type.

        Locate in Computation.jl the method count_seq(). PLEASE DO NOT RUN IT YET! Let's just think
        for a moment about what it does. For instance, what will be the return value of the
        following call?
            Computation.count_seq("abcde","abc")
        """,
        "Check out the very first if-statement in the method",
        x -> x==0
    ),
    Activity(
        """
        That's right - the needle sequence "abcde" cannot occur in the haystack sequence "abc",
        since it is too long to fit into the haystack. To understand what happens if the needle
        does fit into the haystack, let's consider specific example values for needle and haystack:
            Computation.count_seq("bc","abcde")

        In this example, length(needle)==2. What is the value of length(haystack)?
        """,
        "How many characters are in the second argument?",
        x -> x==5
    ),
    Activity(
        """
        In the second part of the method (that is, after the first if-statement) there is a
        for-loop in which the loop-counter i runs in steps of 1 from i=1 to:
            i=length(haystack)-length(needle)+1
        
        We call each separate cycle of the loop, in which the loop-counter i takes a new value, an
        Iteration. Over how many iterations will this loop run in our example call of count_seq()?
        """,
        "",
        x -> x==4
    ),
    Activity(
        """
        Each iteration of this loop compares the needle string with a new portion of the haystack,
        then adds 1 to its overall `count`` if this comparison is successful. When i==4, this
        compared portion of the haystack extends along the range i:(i+length(needle)-1). In this
        case, the compared portion of the haystack therefore runs from 4 to which value?
        """,
        "",
        x -> x==5
    ),
    Activity(
        """
        When the loop is finished, the function count_seq() returns the value of `count` to its
        caller. What is the value of `count` for our example call?
        """,
        "",
        x -> x==1
    ),
    Activity(
        """
        Now we understand how count_seq() works, let's try it out. In VSC, first make sure your
        cursor is positioned in the file Computation.jl, then click on the triangular Play (or
        include) button at the top right of the editor screen. A julia console will appear within
        VSC, which first include()s the file Computation.jl, then after a short while reports back
        with the name of the compiled module:
            Main.Computation
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Try out our first call to the count_seq() function and ensure that it returns 0:
            Computation.count_seq("abcde","abc")

        Great! Now try out our second call from above and ensure that it returns 1:
            Computation.count_seq("bc","abcde")
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK! Now things are getting moving! :)

        Let's test the count_seq() function a little. First, copy the necessary lines of code from
        the julia console into the VSC console, in order to read the data from the file pax6_hs.dat
        into the variable data_hs. Now, what value do you get if you call:
            Computation.count_seq("GCAT",data_hs[1])
        """,
        "",
        x -> x==1
    ),
    Activity(
        """
        Hm. Only 1 occurrence. OK, let's try it with the longer string:
            Computation.count_seq("GCAT",pax6_hs)
        """,
        "",
        x -> x==8
    ),
    Activity(
        """
        OK, so obviously the occurrences of "GCAT" are scattered across different portions of the
        pax6 gene. We can investigate further by using our variable `data_hs` to scan growing
        portions of the gene. How many occurrences occur within the first 11 string entries
        contained in `data_hs`:
            Computation.count_seq("GCAT",prod(data_hs[1:2]))
            Computation.count_seq("GCAT",prod(data_hs[1:3]))
            Computation.count_seq("GCAT",prod(data_hs[1:4]))
            ...
            Computation.count_seq("GCAT",prod(data_hs[1:11]))
        """,
        "",
        x -> x==3
    ),
    Activity(
        """
        Of course, it costs us more time and memory to search through the entire gene, rather than
        just through the first entry in data_hs[1]. We can measure this cost using the julia macro
        @time, which prints out execution information on our calls to the function count_seq() ...

        If you enter the following two lines, you will discover that searching the full pax6hs gene
        takes longer than just searching the first entry of data. However, your program's running
        time will vary greatly depending on how many programs are running in the background on your
        computer. For this reason, it more useful to look at the middle figure in the printout,
        which shows the number of memory allocations that your program's execution caused:
            @time Computation.count_seq("GCAT",data_hs[1])
            @time Computation.count_seq("GCAT",pax6_hs)

        On my computer, the first of these calls caused 67 memory allocations. On your computer,
        divide the number of memory allocation for pax6hs by the number for data_hs[1]:
        """,
        "On my computer, 2700 / 67",
        x -> 38<=x<=42
    ),
    Activity(
        """
        Think about this value - what might it mean? To help you, reply() me the number of String
        entries in data_hs:
        """,
        "length(data_hs)",
        x -> x==39
    ),
    Activity(
        """
        This actually makes sense, doesn't it? count_seq() has to match needle with every possible
        portion of haystack, so if pax6_hs is 39 times as long as data_hs[1], count_seq() will have
        to do 39 times as much work. We say that the method count_seq() has "complexity O(n)", or
        "Linear complexity". These terms mean that if we multiply the size (n) of our haystack by
        3, this also creates 3 times as much work for count_seq() in terms of time and memory use.

        Check that the complexity of count_seq() really does grow linearly with the size of the
        haystack by entering the following line at the julia prompt. Notice that each successive
        increase in the size of the haystack causes the number of memory allocations to rise by a
        constant amount:
            for i in 1:12
                @time Computation.count_seq("GCAT",prod(data_hs[1:i]))
            end
        """,
        "",
        x -> true
    ),
    Activity(
        """
        This idea of complexity is extremely powerful: it offers us a way of measuring the amount
        of "effort" involved in a particular solution method:
            -   We can't measure this effort in seconds, because we might run the method using
                faster or slower computers or even people.
            -   We can't measure effort in numbers of steps because different computers and people
                use bigger or smaller steps to perform the same calculations.

        Instead, we measure the complexity of solution method by seeing how fast they grow as the
        size of the problem gets bigger: Since doubling the size n of the haystack also doubles the
         work involved in finding the needle, we say that that count_seq() displays linear
        complexity of order n: O(n).
        """,
        "",
        x -> true
    ),
    Activity(
        """
        To see that solution methods aren't always so simple, imagine doing a jigsaw puzzle. If I
        do one puzzle with with n pieces, then another with 3n pieces, the number of possible
        combinations of pieces doesn't just double, it gets exponentially bigger, and so we say
        that solving a jigsaw puzzle has exponential complexity: O(2^n).

        Let's look now at a less extreme example of higher complexity. In Computation.jl, locate
        the method count_common() and tell me the value it would return if you called it right
        now in its present incomplete state with two arbitrary strings:
        """,
        "",
        x -> x==5
    ),
    Activity(
        """
        At present, count_common() contains "dummy code" - that is, it contains code that enables
        us to call the method, but without getting a sensible answer back. We will now design julia
        code to replace this dummy code in order to make the method count_common() run properly.

        First, let's think about the function's requirements. As the header documentation for
        count_common() specifies, the call count_common(seq1,seq2,len) should calculate the number
        of common substrings of the sequences seq1 and seq2 that have the length len.
        
        In software design, we make this requirement more specific by studying "use-cases" - that
        is, specific scenarios in which the software will later be used ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Our first use-case for the count_common() function is contained in Computation.demo(), and
        looks like this:
            count_common( "abcde", "xyzcdegh", len),

        where n takes one of the following Int-values, leading to the corresponding return value:
            count_common( "abcde", "xyzcdegh", 0)   -> 0
            count_common( "abcde", "xyzcdegh", 1)   -> 3
            count_common( "abcde", "xyzcdegh", 2)   -> _
            count_common( "abcde", "xyzcdegh", 3)   -> 1
            count_common( "abcde", "xyzcdegh", 4)   -> 0
        
        I have missed out the number of common substrings of length 2. What should this number be?
        """,
        "",
        x -> x==2
    ),
    Activity(
        """
        These use-cases make clear the boundary conditions of our requirements: We wish to return 0
        whenever either n==0 OR (||) n is greater than the length of the shortest sequence. Our
        method can achieve this straight away without having to do any work at all. Insert the
        following code before our dummy code in count_common() so that it looks like this:
            function count_common( seq1::String, seq2::String, len::Int)
                if len < 1 || len > min(length(seq1),length(seq2))
                    return 0
                end

                5                                               # Dummy code
            end
        
        Save, compile and test your code by calculating the following Vector at the julia prompt:
            [Computation.count_common( "abcde", "xyzcdegh", 0),
            Computation.count_common( "abcde", "xyzcdegh", 6)]
        """,
        "",
        x -> x==[0,0]
    ),
    Activity(
        """
        <sigh> But you know, it isn't much fun typing out all these test scenarios, is it? And
        we'll be doing a lot more code-testing later in this course, so how can we save ourselves
        all this effort? Fortunately, Julia offers us a way to save ourselves all this work by
        first using the arrow symbol `->` to quickly create a small "anonymous" function:
            (n -> Computation.count_common( "abcde", "xyzcdegh", n))
            
        and then using the `.` operator to "broadcast" this anonymous function over each component
        of a Vector of values for len. Try this out now by entering the following code at the julia
        prompt, and then reply() me the result you get:
            (n -> Computation.count_common( "abcde", "xyzcdegh", n)).([0,1,2,6])
        """,
        "",
        x -> x==[0,5,5,0]
    ),
    Activity(
        """
        Just quickly check that you have correctly understood broadcasting by using the following
        call to broadcast the logarithm function over a Vector of three different values:
            log.([1,exp(1),exp(2)])
        """,
        "This calculates the logarithms of 1, e and e^2",
        x -> x==[0.0,1.0,2.0]
    ),
    Activity(
        """
        Now we've dealt with the boundary cases of count_common(), we need to implement the core
        part of the functionality. Replace the dummy line "5" by the following lines of code, then
        save, compile and repeat your previous test over the entire range 0:6:
            count = 0
            for i in 1:length(seq1)-len+1
                for j in 1:length(seq2)-len+1
                    if seq1[i:i+len-1] == seq2[j:j+len-1]
                        count += 1
                    end
                end
            end

            count
        """,
        """
        Your test call at the julia prompt should look like this:
            (n -> Computation.count_common( "abcde", "xyzcdegh", n)).(0:6)
        """,
        x -> x==[0,3,2,1,0,0,0]
    ),
    Activity(
        """
        Our count_common() method seems to be working correctly - let's try it out with some real
        data. You already have the two variables data_hs and pax6_hs; now we will compare this
        Homo sapiens data with Mus musculus (mouse) data. First read in the data from the julia
        propmpt, just as you did before for H. sapiens, using the following lines of code:
            is = open("Development/Computation/pax6_mm.dat","r")
            data_mm = readlines(is);
            close(is)
            pax6_mm = prod(data_mm);

        (By the way, notice how I end the lines with a semicolon to avoid the data flooding all
        over the screen!)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        You can now analyse the common content of the pax6 gene for H. sapiens and M. musculus by
        entering commands such as the following:
            Computation.count_common(pax6_hs,pax6_mm,5)

        With this command, I look for common substrings of length 5. Experiment for yourself by
        finding out the maximum length of common substring contained in both pax6_hs and pax6mm:
        """,
        "",
        x -> x==116
    ),
    Activity(
        """
        Before we close this lab, I want to return briefly to the issue of complexity that we
        discussed earlier. You may have noticed that our calls to the method count_common() took
        took a little longer than count_seq() did, before the answer came back. We can study this
        effect more closely using @time to view the number of allocations needed to search for
        common substrings of length 100 that are contained in successively longer segments of our
        two pax6 datasets:
            for i in 1:12
                @time Computation.count_common(prod(data_hs[1:i]),prod(data_mm[1:i]),100)
            end

        In this displayed information, the last (12th) row searches through strings that are twice
        as long as the strings searched in the 6th row. But just look at the comparative numbers of
        allocations - these grow much quicker! What result to you get if you divide the number of
        allocations for row 12 by the number of allocations for row 6?
        """,
        "",
        x -> 4<x<6
    ),
    Activity(
        """
        So doubling the size of the common substring search problem leads to a factor 5 increase in
        the amount of effort involved in doing the search. If we were to perform this comparison
        for even longer strings, we would discover that the resource allocation requirements grow
        as the square of the size of the gene sequences. That is, if we increased the length of the
        sequences by a factor of 3, we would multiply the associated search effort by 3^2==9! In
        other words, the complexity of count_common() is O(n^2).

        You can actually see why this is true if you look at the program code in the second half of
        the method count_common(). Suppose that both sequences are n nucleotides long. Do you
        notice how the loop over seq2 is nested INSIDE the loop over seq1? So count_common()
        compares substrings starting at EVERY location in seq1, and for each such location in seq1,
        we compares the substring at that location with EVERY location in seq2. The result is that
        it performs n*n == n^2 string comparisons.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Just one closing comment before we end this lab. Programming is actually just the science
        of problem-solving: we will learn how to use julia to solve problems. But we also want to
        solve problems EFFICIENTLY. In other words, we want to keep the complexity of our solution
        methods as low as possible. Our count_common() method is not particularly efficient = we
        can do better than O(n^2) complexity by using Hashing Structures.
        
        But that is a story for a later lab - bye! :)
        """,
        "",
        x -> true
    ),
]