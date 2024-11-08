#========================================================================================#
#	Laboratory 7
#
# Hashing, Sets, Tuples, Pairs, Dict and memoisation.
#
# Author: Niall Palfreyman, 13/01/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 007: Hashing Structures, Symbols and files ...

        In this laboratory we look at julia's various hashing structures, including Sets, Tuples,
        Pairs and Dicts. These structures make use of a computational technique called Hashing,
        which we can use to improve the performance of our programs.

        You may remember that we earlier implemented a method count_common(), which counted the
        number of common subsequences possessed by two genetic sequences. We noted there that our
        current implementation has complexity O(n^2), and said that we would improve this using
        Hashing Structures. Well, the time has now come to do precisely that! :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        To lower the complexity of our common subsequence solution method, we will use a particular
        hashing structure called a Set, so it is a good idea for us to first experiment with Sets,
        to find out why we call them Hashing Structures. At the julia prompt, enter:
            s = Set([1,2,1,3,1,4,1,5,1])

        Look at the display of s, and tell me the number of times that the number 1 appears in it:
        """,
        "",
        x -> x==1
    ),
    Activity(
        """
        Julia Sets encapsulate the idea of a mathematical set, in which elements exist only once.
        This means that if we insert a new element into the Set, julia must immediately and quickly
        check whether the new element is already in the Set. Insert the new element 5 into the Set
        s, then tell me the number of times that the number 5 appears in s after this insertion:
            push!(s,5)
        """,
        "",
        x -> x==1
    ),
    Activity(
        """
        So we can use Sets as a way to quickly store values where we only want to know WHETHER a
        particular value is present, and not how often or exactly where in the Set the value
        exists. But of course this is exactly what we want for the common subsequence problem: we
        want to know WHETHER there are two matching subsequences, but not where.

        It actually gets even better than this. The check for uniqueness of elements must be very
        fast, and Sets, Vectors and many other structures in julia use Hashing to achieve this
        speed. Check this out by entering the following commands and noting how long the last line
        takes to run:
            a = rand(99999999)                              # This number is 8 digits long!
            b = a[end]
            for c in a if c==b return true end end
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now enter the equivalent question: `b in a`. Does this answer come back faster?
        """,
        "`b in a` means: Is b an element in a? And of course, b is the last element of a!",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        This answer comes back really fast - in fact, it comes back in O(1) time: hashing can search
        the entire Vector or Set in CONSTANT time! How does it achieve this? By using a Hashing
        Function. Enter each of the following function calls and notice the result you get back:
            hash("Ani Anatta")
            hash(65)
            hash(Char(65))
            hash(Int(Char(65)))

        Does the hash() function always return identical values given identical input arguments?
        """,
        "For convenience, you could convert the hexadecimal hash-code to a Float: `Float64(hash(5))`",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        The hash() function is a little like a random-number generator. It is difficult to predict
        the number that it generates, but that number is reliable: for identical inputs, hash()
        ALWAYS generates the same hash-code. This means we can use this hash-code as a storage
        address for objects: we store the String "Ani" at the address hash("Ani"), and it becomes
        immediately accessible! The only drawback is that we need to allocate more computer memory
        for hash-addresses that we might not yet be using, but this isn't usually a problem.

        Now let's take advantage of Sets' uniqueness and O(1) properties to re-implement our
        solution to the common subsequence problem ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We are finally ready to write a more efficient implementation of count_common(). In your
        Computation folder, open the file Computation.jl and locate the method fast_common(). At
        present, it contains dummy code, but we will soon change that!
        
        Your first step is the same step that any software developer takes: we copy any of our
        previous work that is relevant to what we want to do now! We have already implemented the
        slow version (O(n^2)) method count_common(), so copy the code from there into fast_common()
        and check that it works by compiling and running the Computation.demo() method.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, so now let's look at what our old code does. First of all, it handles very efficiently
        the case where the argument len is either smaller than 1 or greater than the length of the
        shortest sequence. This takes a great deal of work off our shoulders, since we can now
        assume that len has a sensible value, so we'll leave that code as it is.

        The real slowdown comes from the nested loops that together yield the O(n^2) complexity.
        We would really like to separate the seq1 loop from the seq2 loop, and we can achieve this
        by using one loop to store the seq1 Strings of length len in a Set, then another (separate)
        loop to check whether we can find these Strings in seq2.

        So: strip out the body of the outer loop over seq1, and replace the loop body by this code:
            push!( memory, seq1[i:i+len-1])
        """,
        "Remember, you're deleting the entire inner loop over seq2",
        x -> true
    ),
    Activity(
        """
        In your code, you should still have the variable count, which is initialised to 0 and is
        then returned at the end of the method. However, we still haven't created the Set into
        which our loop pushes the various Strings from seq1. So between the line `count = 0` and
        the beginning of the for-loop, insert the line:
            memory = Set()

        Your method should now run, even though it doesn't yet return correct results, so run it
        now, and ensure that it is reliably returning a zero (0) result.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We're now half finished! We've stored all the seq1 subsequences of length len in memory;
        now we need to look them up in seq2. This involves a similar loop to the one we already
        have, so copy and paste the seq1 loop just before the final return line `count`.

        Now replace `seq1` by `seq2` in this second loop, and replace the loop body by this code:
            if seq2[i:i+len-1] in memory
                count +=1
            end

        Your new method should now work correctly - compile and test it to be sure that the demo()
        output is identical for both count_common() and fast_common().
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Great! :) Now we need to check whether this new implementation has lower complexity. Recall
        that we measured the complexity of our earlier implementation using this test code:
            for i in 1:12
                @time Computation.count_common(prod(data_hs[1:i]),prod(data_mm[1:i]),100)
            end

        To repeat this test scenario, you'll first need to read in the datasets data_hs and
        data_mm. When you have done this, move on to the next activity.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now that you have read in the datasets data_hs and data_mm, run the following lines
        of test code once for count_common() and once for fast_common():
            for i in 1:12
                @time "\$i" Computation.count_common(prod(data_hs[1:i]),prod(data_mm[1:i]),100)
            end
            
        Finally, run each of these two tests once again, because some of the time in the first
        run might have been due to compiling new code. Now discuss the two sets of output
        results with a friend before moving on ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        You should immediately see that fast_common() runs much faster than count_common() (look at
        the time in seconds). This vindicates our idea that we should store values in a Set.
        Instead of two nested loops, we now have two loops running one after each other, so their
        execution times are added, rather than multiplied.

        But wait! That should mean that the number of allocations rises linearly in constant steps!
        Look at the allocation values for fast_common(): Do they rise in equal constant steps?
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        Hm. What is happening here? Notice particularly that the jump from one loop iteration to
        the next stays approximately constant at around 150 from step 4 to step 11, but then there
        is a sudden bigger jump of 1400 from step 11 to step 12.

        The problem is that at present, we first allocate `memory` as an empty Set, and then push
        lots of Strings into it in the first loop. This means julia cannot know in advance how big
        the memory will be in the end, and so has to keep reallocating it when space runs out.

        We can solve this problem by replacing our initialisation line and pushing loop by a single
        comprehension that allocates sufficient memory in one block:
            memory = Set( [seq1[i:i+len-1] for i in 1:length(seq1)-len+1])

        Do this, and re-run your fast_common() test. Do allocations rise in roughly constant steps?
        """,
        "",
        x -> true
    ),
    Activity(
        """
        That was exciting, wasn't it? The goal of lowering solution method complexity is often like
        detective work, and it is soooo satisfying when you manage to achieve this goal. :)

        So, with the glint of success in our eye, let's move on to some other hashing structures. A
        Tuple is an immutable container that can contain several different types. We construct
        Tuples using round brackets, for example:
            tuply = (5, 2.718, "Ani")

        What is tuply[2]?
        """,
        "tuply[2]",
        x -> x==Main.tuply[2]
    ),
    Activity(
        """
        You have already seen that size() returns a Tuple. Enter the following code:
            siz = size(zeros(3,4))

        What is the value of siz[1]? Try changing the value of siz[2]. Finally, what is the type
        of siz? 
        """,
        "typeof(siz)",
        x -> x==typeof(size(zeros(3,4)))
    ),
    Activity(
        """
        Tuples are especially useful when we want to define anonymous functions with more than one
        argument:
            map((x,y)->3x+2y,[1,2,3],[4,5,6])

        Construct a single line mapping that calculates sin(x*y) for corresponding elements in the
        two ranges x = 1:5 and y = 5:-1:1
        """,
        "map((x,y)->sin(x*y),1:5,5:-1:1)",
        x -> x==map((x,y)->sin(x*y),1:5,5:-1:1)
    ),
    Activity(
        """
        A Pair is a structure that contains two objects - typically a key and its entry in a
        dictionary. We construct a Pair like this:
            pairy = "Yellow Submarine" => "Beatles"

        Construct pairy and then find the value of last(pairy):
        """,
        "",
        x -> x==last("Yellow Submarine" => "Beatles")
    ),
    Activity(
        """
        A Dict(ionary) is a hashed database of Pairs. Dicts are very lightweight, so we can easily
        use them in everyday code. We construct a Dict by passing a sequence of Pairs to the
        constructor:
            dicty = Dict( "pi" => 3.142, "e" => 2.718)

        Construct dicty, and notice that the Pairs are not necessarily stored in the same order
        that you entered them. Now look up the value of "pi" in dicty:
            dicty["pi"]
        """,
        "",
        x -> x==3.142
    ),
    Activity(
        """
        We can find out whether our Dict contains the key "e" by using the keys() function:
            "e" in keys(dicty)

        Delete the entry for "e" from dicty using the delete!() function. What word do you now
        see in red if you enter dicty["e"]?
        """,
        "delete!(dicty,\"e\")",
        x -> x=="ERROR"
    ),
    Activity(
        """
        Now add two extra entries to dicty:
            dicty["root2"] = 1.414
            dicty["epsilon0"] = 8.854e-12

        What is the result of calling haskey(dicty,"root2")?
        """,
        "",
        x -> x==true
    ),
    Activity(
        """
        Before we close this lab, I want to show you a useful trick called Memoisation that we can
        use to improve the performance of programs that call themselves recursively. Take, for
        example, the Fibonacci function fib(n) defined in Computation.jl:
            function fib( n::Int)
                if n < 3
                    return 1
                end
            
                fib(n-1) + fib(n-2)
            end
        
        Compile and experiment with this method. Then calculate fib(7) + fib(8). What is the value
        of fib(9)?
        """,
        "",
        x -> x==34
    ),
    Activity(
        """
        Now use your knowledge of @timing functions to time Computation.fib(n) for values of n in
        the range 10:10:50.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Look at the the sequence of computation times for fib(10), fib(20), ...
        
        If you divide each computation time by the previous computation time, you will see that the
        values are at least multiplied by some factor. That is, the times rise exponentially: the
        time requirements of our method for calculating fib(n) grow EXPONENTIALLY with its argument
        n, so our method has time complexity O(2^n). This makes it very difficult to calculate, for
        example, fib(99).

        This is where we can use Memoisation to make our calculation more efficient. Suppose we want
        to calculate fib(21) an fib(25). To calculate either of these, we must first calculate
        fib(20), so it makes sense to remember (Memoise) the value of fib(20) from the first
        calculation, so that we don't have to go to the trouble of calculating it again in the
        second calculation. Let's do this ...

        In Computation.jl, in the line immediately BEFORE fib(), insert this declaration:
            fib_table = Dict{Int,Int}()
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now insert immediately after the line `return 1` in the if-statement, these two lines:
            elseif haskey(fib_table,n)
                return fib_table[n]
    
        These two lines check before proceeding whether the value fib(n) alreay exists in our
        lookup table for Fibonacci values. Make sure your new code is correctly indented, then
        compile and run the method again to be sure that everything is still working properly.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Right, now comes the vital code that will accelerate fib(). Replace the final line of
        fib() by this line of code:
            fib_table[n] = fib(n-1) + fib(n-2)

        Notice that this line is not so very different from the line you have just replaced - it
        merely stores the result of fib(n) under the key n in fib_table. But now repeat your
        @timing from before. What is the new time complexity of your fib() method?
        """,
        "",
        x -> occursin("linear",lowercase(x)) || occursin("O(1)",x)
    ),
    Activity(
        """
        It's like magic, isn't it? :)

        Memoisation is enormously helpful when we analyse biological sequence structures that
        require us to perform exponentially complex searches through trees of sequence combinations.
        """,
        "",
        x -> true
    ),
]