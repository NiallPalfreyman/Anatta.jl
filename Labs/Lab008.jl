#========================================================================================#
#	Laboratory 8
#
# Files, Dates, Random expressions, Regular Expressions and downloading.
#
# Author: Niall Palfreyman, 30/08/2023
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 008: Text- and symbol-processing

        In this lab, we will make use of various tools available in julia for processing symbols
        and texts. Along the way, we will discover some fun stuff about how large language models
        (LLMs) like GPT are constructed, and we will also learn how to use the julia REPL for
        developing a code module. :)

        Please be aware: Lab 008 also contains your first assessed project for Subject 0, so we
        will allow ourselves a full week to complete all the work for this lab.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Before analysing texts, we'll first find out how to use the files in which we will store
        that text. Our first problem is how to find and read files in the background filesystem
        from within our program. You already know the function pwd() (Present Working Directory)
        and readdir() from lab 0.
        
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
        Right, now let's create some text to analyse. Enter this line at the julia prompt:
            sample_text = "A lazy   brown fox  trips,           over the    lazy brown dog."

        To manipulate this text, we define manipulation rules like this:
            "dog" => "cow"

        Enter this line, and save its value in a variable named `rule`. What is the typeof `rule`?
        """,
        "",
        x -> (x <: Pair)
    ),
    Activity(
        """
        In julia, we often implement rules by creating a variable of the type Pair using this
        notation: `a => b`. Now enter the following line:
            replace(sample_text,rule)

        What animal has replaced the dog in sample_text?
        """,
        "",
        x -> occursin("cow",lowercase(x))
    ),
    Activity(
        """
        We can also define rules using Regular Expressions (denoted, for example, by r"xyz"). For
        example, the following line tells julia to replace all repeated spaces by single spaces:
            replace(sample_text, r"\\s+" => " ")

        If you enter this command now, you should see that the multiple spaces are cleaned up:
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We can use the julia method split() to divide the text up into words:
            split(sample_text, r"\\s")

        However, as you see, we need to split the words on other punctuation symbols as well:
            split(sample_text, r"(\\s|\\b)")
        """,
        "",
        x -> true
    ),
    Activity(
        """
        In the module TextAnalysis, I have combined these manipulations into a single method
        splitwords(). Include this module now and create a list of the words in sample_text:
            include("Development/Computation/TextAnalysis.jl")
            using .TextAnalysis
            splitwords(sample_text)

        How many elements are in the list?
        """,
        "",
        x -> x == 12
    ),
    Activity(
        """
        As you can see, our sample_text contains 'words' like "." and ",". Although we could remove
        these pseudowords, they will not actually be a problem for our work here. What is more of a
        problem are the repeated words like "lazy". Check your list of individual words, and notice
        that this word appears twice.

        We want to eliminate duplicate words from our list, and we shall use a julia Dict(ionary)
        to achieve this. Try out the following commands at the julia prompt:
            capitals = Dict()
            capitals["France"] = "Paris"
            capitals["Tanzania"] = "Dar-es-salaam"

        Now add a few more capital cities of your own to the `capitals` dictionary, then display
        the entire dictionary by entering `capitals` at the julia prompt. Notice that the entries
        are probably not in the same order as you entered them. Dicts are Hashing structures - that
        is, the entries in the Dict are Key=>Value Pairs in whatever order enables users to access
        them as quickly as possible. What is the value of haskey(d,"Tanzania")?
        """,
        "",
        x -> x==true
    ),
    Activity(
        """
        Right, now let's eliminate duplicate entries from our sample_text. First, create inside the
        module TextAnalysis the following method:
            function entry_counts(list::Vector)
                counts = Dict{String,Int}()
                for entry in list
                    if haskey(counts,entry)
                        counts[entry] += 1
                    else
                        counts[entry] = 1
                    end
                end
                counts
            end
                    
        Remember to write a docstring for the new method. Your docstring should describe precisely
        the Contract between the method and its client: What arguments must the client provide, and
        what precisely is the result that the method delivers back to the client?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now append the name of your new method to the export list at the top of the module. Also,
        insert testcode for the entry_counts() method into the demo() method at the end of
        TextAnalysis. Finally, either reinclude TextAnalysis.jl in a julia console or else press
        the include triangle in VSC and test your code.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Congratulations! You have just used the julia console and VSC to develop and test your own
        new code. Now let's use that code to do something really fun: We will build a small LLM of
        a famous English novel, and we shall then use this model to generate text in the linguistic
        style of 19th-century English! :)

        At the julia prompt, enter the following lines to read in the entire text of the novel
        "Pride and Prejudice" by Jane Austen. Please remember the semicolons, because I won't be
        reminding you again after this! :)
            pandp_site = "https://shorturl.ac/pandp"
            raw_text = read(download(pandp_site),String);
            start_index = findfirst( "It is a truth", raw_text)[1]
            stop_index = findlast( "of uniting them.",raw_text)[end]
            pandp_text = raw_text[start_index:stop_index];
        """,
        "",
        x -> Main.pandp_text[5000:5020] == "It was then disclosed"
    ),
    Activity(
        """
        In the following, I assume you are in the following situation: You have TextAnalysis.jl
        open in VSC, and also a julia console in which you are trying out the ideas in this
        laboratory. In addition, you have included and are using the module TextAnalysis, so that
        the methods splitwords() and entry_counts() are available at the julia prompt (either in
        the free console or in VSC), and in the julia console you have two String variables:
        sample_text contains the short test text that we wrote above, and pandp_text contains the
        complete text of the book Pride and Prejudice.

        Perform a wordcount of sample_text and verify it contains two instances of the word "lazy":
            sample_wordlist = splitwords(sample_text)
            sample_wordcounts = entry_counts(sample_wordlist)
            sample_wordcounts["lazy"]

        Now construct two new julia variables pandp_wordlist and pandp_wordcounts according to this
        scheme, them tell me how often the book Pride and Prejudice mentions the name "Elizabeth":
        """,
        "pandp_wordlist = splitwords(pandp_text); pandp_wordcounts = entry_counts(pandp_wordlist)",
        x -> x == 634
    ),
    Activity(
        """
        OK. Now, we want to model the language patterns of Pride and Prejudice in a way that helps
        us to generate _new_ sentences automatically. We can solve this problem the same way we
        solve any computation problem: by breaking it down into smaller problems...
        
        Language structures involve sequences of symbols and words, and we can experiment with this
        idea by looking at sequences of numbers. Imagine a method bigrams() that takes a sequential
        list, and returns a new list of all neighbouring pairs from the original sequence:
            bigrams : [1,2,3,5,101] -> [[1,2],[2,3],[3,5],[5,101]]

        To implement this, we'll need to map a function over a list using the map() function. For
        example, tell me the result of this julia code, which maps the sin() function over a list:
            map(0:6) do n
                sin(n*pi/6)
            end
        """,
        "",
        x -> (x[1]<0.01 && x[end]<0.01)
    ),
    Activity(
        """
        Using this idea, we can implement bigrams() by mapping over a sequence of objects:
            function bigrams(sequence)
                nbr_positions = 1:length(sequence)-1
                map(nbr_positions) do pos
                    sequence[pos:pos+1]
                end
            end
        
        Test this method by telling the result of the call:
            bigrams([1,2,3,5,101])
        """,
        "",
        x -> x==[[1,2],[2,3],[3,5],[5,101]]
    ),
    Activity(
        """
        Now work out the next step yourself. Implement a more general function ngrams() that takes
        a sequence and a number n, and returns all subsequences of length n. For example:
            ngrams([1,2,3,5,101], 2) == [[1,2],[2,3],[3,5],[5,101]]
            ngrams([1,2,3,5,101], 3) == [[1,2,3],[2,3,5],[3,5,101]]

        Implement the new function ngrams in TextAnalysis (with docstring, testcode in demo() and
        export, then include and use TextAnalysis and tell me the result of
            ngrams([1,2,3,5,101], 3)
        """,
        "",
        x -> x==[[1,2,3],[2,3,5],[3,5,101]]
    ),
    Activity(
        """
        Now generate a list of the bigrams (ngrams(sample_wordlist,2)) contained in sample_text,
        and use entry_counts to find out how often the 2-gram ["lazy","brown"] occurs in sample_text:
        """,
        "sample_dig_counts = entry_counts(ngrams(sample_wordlist,2))",
        x -> x==2
    ),
    Activity(
        """
        Repeat your work from the previous activity to construct first pandp_trigrams, then
        pandp_trig_counts, and then discover how many times the phrase "I am sure" occurs in the
        entire book Pride and Prejudice:
        """,
        "",
        x -> x==62
    ),
    Activity(
        """
        Before proceeding further, it is a good idea to save our work so far in the form of a new
        method ngram_counts() in TextAnalysis, which converts a wordlist into a Dict of ngrams:
            function ngram_counts( wordlist, n)
                entry_counts( ngrams( wordlist, n))
            end
        
        Insert this method (together with docstring, test and export) into TextAnalysis, then
        reinclude and use the new version of TextAnalysis.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, now we're ready to generate our own sentences using ngrams! The idea is that we will
        construct a "completion cache". This is a dictionary whose keys are the 2-grams in a text,
        and the value corresponding to each such key is a vector of all those words in the text
        which complete that 2-gram to a 3-gram.

        Suppose we had already written code to construct a completion cache; what value would you
        expect to be returned by the following code?
            trigrams = ngrams(sample_wordlist, 3)
            sample_completion = completion_cache(trigrams)
            sample_completion[["lazy","brown"]]
        """,
        "Look at all relevant trigrams you can find in the sample_text",
        x -> Set(x) == Set(["fox","dog"])
    ),
    Activity(
        """
        Here is the code for the completion_cache method. Insert it properly into your growing
        TextAnalysis module and test it using the ideas in the previous activity. Finally,
        reinclude TextAnalysis.jl so that we can use the new completion_cache method:
            function completion_cache(grams)
                cache = Dict()
                for ngram in grams
                    if haskey(cache,ngram[1:end-1])
                        cache[ngram[1:end-1]] = [cache[ngram[1:end-1]] ngram[end]]
                    else
                        cache[ngram[1:end-1]] = [ngram[end]]
                    end
                end
                
                cache
            end
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Right! Now we have everything we need to compose our own nineteenth-centure novel! First,
        we'll construct a language model consisting of ngrams from Pride and Prejudice, then we'll
        use this model to generate text by selecting random ngrams in such a way that each new
        ngram overlaps with the previous ngram.

        As a first step, make sure that every ngram ends in the beginning of some other ngram, by
        appending the first n-1 words to the end of the Pride and Prejudice wordlist BEFORE
        calculating the ngrams:
            n = 3
            circular_wordlist = [pandp_wordlist..., pandp_wordlist[1:n-1]...]
            pandp_ngrams = ngrams( circular_wordlist, n)

        Now show me the very last trigram in pandp_ngrams, and think carefully about why we should
        expect it to have this value:
        """,
        "",
        x -> x == [".", "It", "is"]
    ),
    Activity(
        """
        Next, construct your language_model, ...
            language_model = completion_cache(pandp_ngrams)

        ... create the first n words of your new novel, ...
            novel_wordlist = rand(pandp_ngrams)

        ... add new words up to a total of 200 from the language model, ...
            for i in n+1:200
                previous_words = novel_wordlist[end-(n-2):end]
                possible_words = language_model[previous_words]
                new_word = rand(possible_words)
                push!(novel_wordlist, new_word)
            end
        """,
        "",
        x -> true
    ),
    Activity(
        """
        ... and then string the words together into Your Very Own Nineteenth-Century Novel:
            novel = join(novel_wordlist," ")
        """,
        "",
        x -> true
    ),
    Activity(
        """
        So now we've written our 200-word novel! :) However, if you look at the text, it is a
        little shabby, isn't it? First of all, the sentences are rather long and strange, and the
        full-stops and apostrophes are separated from the rest of the words. Also, there seem to be
        two different kinds of quotation marks (") which make things difficult.
        
        My guess is that the strange sentences could be improved by using a language model based on
        longer n-grams, but that is what you will find out in your first assessed project for this
        course ...
        """,
        "I'll describe the project in the following activites",
        x -> true
    ),
    Activity(
        """
        You have one week to complete your first assessed project. For the project, you will
        implement a full version of the TextAnalysis module that includes this function:
            write_novel( source_text::String, num_words::Int; n=3)

        write_novel() generates a text file novel.txt containing num_words words, generated from a
        language model based on n-grams of the source_text. The generated novel should contain an
        appropriate title and copyright date. Here are some questions you may wish to answer:
            -   Have I written my julia code so that other students will understand it easily?
            -   How do I handle special characters in the Pride and Prejudice text?
            -   How do I implement the ideas from this lab as short, convenient methods?
            -   How can I document my module to demonstrate how users should call write_novel()?
            -   How do I generate today's date? (see Dates module in the julia ddocumentation)
        """,
        "Good luck! :)",
        x -> true
    ),
]