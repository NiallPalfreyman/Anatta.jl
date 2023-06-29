#========================================================================================#
#	Laboratory 8
#
# Symbols, files, Dates, Random numbers, Regular Expressions and downloading.
#
# Author: Niall Palfreyman, 13/01/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 008: Assorted data-science tools

        In this lab, we'll get to know various tools that make our data-science lives a little
        pleasanter: Symbols, files, Dates, Times, random numbers, regular expressions and
        downloading . :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We have already met Symbols - they define components of the julia language, and we use them
        to extend the language with new components. We construct Symbols using the colon ':'. Enter
        the following lines:
            a,b = 2,3
            expr = :(a+b)
            dump(expr)

        What is the value of expr.args?
        """,
        "",
        x -> x==Main.expr.args
    ),
    Activity(
        """
        You can see that the arguments of expr are Symbols waiting to be evaluated. Try:
            typeof(expr.args[2])

        What do you get if you enter string(expr)?
        """,
        "",
        x -> occursin("a+b",replace(x," "=>""))
    ),
    Activity(
        """
        Symbols and Strings are very similar to each other. You will see that graphics functions
        often use Symbols to define special switches such as :red or :filled.
        
        In fact, a Symbol is a String that has been prepared for being evaluated. What do you get
        if you apply the function eval() to expr?
        """,
        "eval(expr)",
        x -> x==5
    ),
    Activity(
        """
        We can use the "splat" operator (...) to convert any collection (for example a Vector or a
        Tuple) into a set of arguments for a function. Define the following function and test it
        with a few numbers (for example, funky(2,3,4)):
            funky(x,y,z) = x * (y+z)
        
        Now define the Vector v = [2,3,4]. Suppose we want to use the three numbers in v as
        arguments for funky(). First try it like this: funky(v), and see what happens ...

        It didn't work, did it? Now tell me what answer you get when you enter this:
            funky(v...)
        """,
        "",
        x -> x==14
    ),
    Activity(
        """
        Files are an important part of everyday data science: we often need to be able to find and
        read files in the background filesystem from within our program. You already know the
        function pwd() (Present Working Directory) and readdir() from lab 0.
        
        At the julia prompt, use readdir() to fetch a list of files:
            contents = readdir("Development/Computation")

        Choose a file in this list - for example maybe "pax6_hs.dat". Now use `in` to ask whether
        this file is contained in the current folder. What answer do you get back?
        """,
        "\"pax6_hs.dat\" in contents",
        x -> x==true
    ),
    Activity(
        """
        pwd() gives us the path of the current folder, and readdir() gives us a vector of files
        in that folder. We can put these together using joinpath(). Investigate this idea by first
        entering the following:
            datafile = joinpath(pwd(),"Development/Computation","pax6_hs.dat")

        This gives you a full path description of the pax6_hs datafile. Now you can ask whether
        this file exists by entering:
            isfile(datafile)

        What value is returned by this function call?
        """,
        "",
        x -> x==true
    ),
    Activity(
        """
        Now let's create a new file. The following command creates a file named "ani.dat", and sets
        up an IOStream named "os" for "w"riting to it:
            os = open("ani.dat","w")

        Now write some information to the file:
            write( os, "This is my file\nIt belongs to me!\n")

        The value returned by write() is the number of bytes you have written to the ostream. We
        can also use the print() and println() functions, for example:
            println( os, "It really does!")

        Finally, close() the ostream, then tell me the result of isfile("ani.dat"):
        """,
        "close(os)",
        x -> x==true
    ),
    Activity(
        """
        Congratulations! You have created your first file! Now let's try r(eading) from the file:
            is = open("ani.dat","r")

        Now enter: readline(is) several times to read lines from the istream. At any stage, you can
        check whether the istream has reached the end-of-file state:
            eof(is)

        What value does readline() return if you continue to read lines after the end-of-file?
        """,
        "readline(is)",
        x -> isempty(x)
    ),
    Activity(
        """
        Now close() the file, then reopen it again to start reading at the beginning of the file.
        We can read all lines of the file at once: what is the type of the structure returned by
        the following code?
            is = open("ani.dat","r")
            readlines( is)
        """,
        "",
        x -> x <: Vector
    ),
    Activity(
        """
        If our file contained binary data, it would not be possible to read it in separate lines -
        in such cases, we use the read() function.

        Rewind the file istream to the beginning using `seekstart(is)`. Enter read(is) to see the
        characters in the file, and tell me the first character:
        """,
        "0x54: Scroll the Julia console back up to see the beginning of the avalanche!",
        x -> x==0x54
    ),
    Activity(
        """
        Well, that wasn't very pleasant, was it, with all those characters screaming across the
        screen? Let's do it in a more civilised way this time...

        Rewind the istream to the beginning using seekstart(). Now enter:
            data = read(is);

        Did you remember to write ';' at the end of the line? If not, you presumably had the
        "screaming characters" problem again. :( The character ';' at the end of a line of code
        prevents the return value from being written to the console. Now tell me the value of the
        fifth element of data:
        """,
        "data[5]",
        x -> x==0x20
    ),
    Activity(
        """
        This hex code represents a character. Can you convert the code to a character?
        """,
        "Char(data[5])",
        x -> x==' '
    ),
    Activity(
        """
        We can even convert the data entirely to a String like this:
            str = String(data)

        However, this conversion process also consumes the values contained in data. What answer do
        you now get back if you call the function isempty(data)?
        """,
        "",
        x -> x==true
    ),
    Activity(
        """
        Finally, we must always close an IOStream after we have finished using it: close(is). Also,
        we should clean up our filesystem afterwards, so now remove the file we created by calling
        `rm("ani.dat")`, and tell me the type of the return value of this call:
        """,
        "First call rm(), and then ask: typeof(ans)",
        x -> x==Nothing
    ),
    Activity(
        """
        Next, we'll investigate DateTimes in julia. Support for date and time handling is provided
        by the Dates package, which we must first load:
            using Dates

        We can access the current time using the now() function:
            datim = Dates.now()

        What is the type of datim?
        """,
        "",
        x -> x==Main.DateTime
    ),
    Activity(
        """
        To create a new date, we pass year, month and day to the constructor:
            Date( 1996, 7, 16)
            Date( 2020, 6)

        What Date value is constructed by the call Date(2022)?
        """,
        "",
        x -> x==Main.Date(2022)
    ),
    Activity(
        """
        We can also create times. Use the minute() function to find the number of minutes past
        the hour in this time:
            DateTime(1992,10,13,6,18)
        """,
        "minute(ans)",
        x -> x==Main.minute(Main.DateTime(1992,10,13,6,18))
    ),
    Activity(
        """
        The module Dates also makes available Periods of time. Use the subtypes() function to find
        the subtypes of Period and also the subtypes of these subtypes. How many subtypes does the
        type TimePeriod have?
        """,
        "subtypes(TimePeriod)",
        x -> x==length(Main.subtypes(Main.TimePeriod))
    ),
    Activity(
        """
        However, we don't just want to construct dates and times - we often want to parse (i.e.,
        analyse) them. We can construct a Date from a String by passing a DateTime format argument:
            Date("19760915","yyyymmdd")

        For DateTimes, this format gets a little more complicated, so you may wish to define your
        own format:
            format = DateFormat("HH:MM, dd.mm.yyyy")

        Use this format to parse the DateTime "06:18, 13.10.1992". What character separates the
        date from the time in the result?
        """,
        "",
        x -> x=='T' || x=="T"
    ),
    Activity(
        """
        DateTimes contains many useful functions that you can look up at docs.julialang.org.
        For example, use the function dayname() to find out the day on which you were born ...

        When you've finished experimenting, just enter reply() to move on to the next activity.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Find out your age in days by subtracting your birthday Date from today(), then move on
        with reply():
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Form a list of the past 8 days by collecting this Range into a Vector:
            today()-Week(1):Day(1):today()
        """,
        "",
        x -> x==Main.eval(:(collect((today()-Week(1)):Day(1):today())))
    ),
    Activity(
        """
        Next we'll look at a very important tool of data science: Random numbers. First load the
        functions that we'll be using:
            using Random: rand, randn, seed!

        By itself, the rand() function returns a pseudo-random Float64 number in the semi-open
        interval [0.0,1.0). Try this now.
        
        If you pass rand() a range as its first argument, it returns a random element from that
        range. If you pass it a tuple of integers, it returns an array with the size specified by
        those integers. Use rand() to produce a (3,4) array of integer values between -1 and +1:
        """,
        "rand(Range,Size)",
        x -> (typeof(x) <: Matrix{Int}) && size(x) == (3,4) && all(map(y->in(y,-1:1),x))
    ),
    Activity(
        """
        randn() works just the same as rand(), but returns normally distributed values with mean
        0.0 and standard deviation 1.0. Create a (5,7) array of such normally distributed numbers:
        """,
        "",
        x -> size(x) == (5,7) && sum(x)/length(x) < 0.5
    ),
    Activity(
        """
        When we perform simulations with random numbers, we never know in advance how our program
        will behave. On the one hand, this is certainly good, because many biological processes are
        essentially random. On the other hand, it can be very frustrating if you observe some
        special problem or phenomenon, because you may never again be able to reproduce that
        special situation. Because of this, we need to be able to make random-number generation
        Reproducible. We do this by Seeding the random-number generator (rng).

        To do this, we use the function seed!() at the beginning of our program to make sure all
        random numbers follow an identical pattern across separate runs of the program. Run the
        following code several times, then tell me what result you get:
            seed!(123); rand(5)
        """,
        "",
        x -> x==(Main.seed!(123); Main.rand(5))
    ),
    Activity(
        """
        Another tool of great value for bioinformatics is Regular Expressions. A regular expression
        is a recognition procedure for locating a certain string pattern in a longer sequence of
        characters. There is a description of regular expressions in julia in the Strings chapter
        of the language documentation, and a you can find a general description of regular
        expression syntax here:
            https://www.pcre.org/current/doc/html/pcre2syntax.html

        Enter the following line at the julia prompt and tell me the type of the result:
            tata_pattern = r"TATA(A|T)A(A|T)"
        """,
        "typeof(tata_pattern)",
        x -> x==Regex
    ),
    Activity(
        """
        The regular expression `tata_pattern` describes the general pattern of a TATA-sequence in
        genome data. Let's create a toy DNA sequence to test this TATA pattern:
            dna = "GCCAATATAAATCGAGGGGGGGTATATAAAA"

        Use help (?) to find out how to search for regular expressions using the function
        occursin(), then tell me whether it is true or false that `dna` contains a TATA-sequence:
        """,
        "occursin(needle,haystack)",
        x -> x==true
    ),
    Activity(
        """
        We can gather statistics on all pattern matches in a sequence using eachmatch(). Enter the
        following two lines:
            em = eachmatch(tata_pattern,dna)
            for m in em println(m.match) end

        em is an iterable collection of regular expression matches. Here, we iterate through this
        collection, printing the exact match that was found at each location in dna. Each match in
        the collection has a field `.offset` that tells whereabouts in the dna pattern the match
        was found. At which offset location did julia find the first match in dna?
        """,
        "You may prefer to collect() the iterable em in order to study the individual elements",
        x -> x==6
    ),
    Activity(
        """
        Now use your knowledge of regular expressions to tell me whether it is true or false that
        our pax6 data for Mus musculus contains a TATA-sequence:
        """,
        "",
        x -> x==true
    ),
    Activity(
        """
        OK, and fi-i-inally at the end of this laboratory, we look briefly at downloading resources
        from the Internet. First, we load the download() function from the package Downloads:
            using Downloads: download

        Next we define the url of our resource:
            url = "https://raw.githubusercontent.com/NiallPalfreyman/Anatta.jl/master/src/Anatta.jl"

        Next, we download this page into a local file:
            file = download(url)
        
        Use readlines() (don't forget the ';'!) to discover the Date on which Niall Palfreyman
        started writing the Anatta project:
        """,
        "data = readlines(file);",
        x -> x == Main.Date("1/01/2023","d/mm/yyyy")
    ),
    Activity(
        """
        OK, that's the end of this laboratory. The resource we just downloaded is my own source
        code - feel free to explore it and use it as much as you like. Bye! :)
        """,
        "",
        x -> true
    ),
]