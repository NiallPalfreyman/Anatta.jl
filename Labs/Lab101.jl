#========================================================================================#
#	Laboratory 101
#
# Semantics.
#
# Author: Niall Palfreyman, 8/11/2024
#========================================================================================#
let
include("../src/dev/Logic/Semantics.jl")
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 101: The semantics of propositions

        In lab 100, we built an LL-parser for the syntax of the language PL for Propositional
        Logic. In lab 101, we look at the Semantics of PL. For Saussure, and indeed still for many
        people today, it seems very obvious what semantics is about: it describes the meaning of
        syntactically correct sentences. But what do you think the following line of code means:
            #include <string.h>

        A C compiler interprets this line by inserting the library header string.h into the
        current program file. But what value will a julia compiler return from this code-line?
        """,
        "Try it out for yourself in the julia REPL",
        x -> isnothing(x)
    ),
    Activity(
        """
        So meaning depends not only on the sentence, but also on who is reading it! We will see
        later in Subject 600 (Enactive dynamics) how meaning is linked to the autonomy of
        organisms, but for now, we shall think of meaning as depending on the belief-Model that an
        organism uses to organise its ongoing perceptual experience.

        A syntactically correct sentence in PL is a Proposition, and can contain constants and
        variables. The truth-value meaning of a constant is clear: WFF("T") is true and WFF("F") is
        false. But variables have no clear truth-value; it can become very difficult to decide the
        truth-value of a proposition containing several different variables. For example, what do
        you imagine is the truth-value of this proposition:
            "If unicorns are orange, then cows eat grass."

        To determine the semantics of propositions, we use WFFs: computer-manipulable structures
        that represent propositions. If p = "Unicorns are red" and q = "Cows eat grass", which
        WFF represents the above proposition regarding unicorns?
        """,
        "You can give it to me in either WFF or String form",
        x -> string(x) == "(p -> q)"
    ),
    Activity(
        """
        To define the meaning of a WFF, we first introduce the idea of a Model: an assignment of
        T/F values to all the variables in a proposition. The module Semantics, contained in the
        file Semantics.jl, contains our julia definition of a model. Look at this definition now,
        then reply() me the julia type on which our definition of a model is based:
        """,
        "Give me the type itself - not a string",
        x -> (x <: Dict)
    ),
    Activity(
        """
        Suppose wff, wff1 and wff2 are all well-formed formulae (WFF). Then we use the following
        recursive definition for the Truth-value of a WFF in a particular model M:
        -   The truth-value of WFF("T") is TRUE; the truth-value of WFF("F") is FALSE.
        -   The truth-value of the variable WFF("a41") in the model M is M["a41"] (that is, it is
            equal to the truth-value of "a41" in the model M).
        -   The truth-value of the Negation WFF("~",wff)) is TRUE in the model M if and only if the
            truth-value of wff is FALSE in M. Otherwise, the negation's truth-value is FALSE.
        -   The truth-value of the Conjunction WFF("&",wff1,wff2) in M is TRUE iff (if and only if)
            both wff1 and wff2 are TRUE in M; otherwise, the conjunction's truth-value is FALSE.
        -   The truth-value of the Disjunction WFF("|",wff1,wff2) in M is FALSE iff both wff1 and
            wff2 are FALSE in M; otherwise, the disjunction's truth-value is TRUE.
        -   The truth-value of the Implication WFF("->",wff1,wff2) in M is TRUE iff either wff1 is
            FALSE in M, or wff2 is TRUE in M; otherwise, the implication's truth-value is FALSE.

        What is the truth-value of the following proposition in your personal belief model?
            "If cows have four legs and unicorns are orange, then pigs can fly."
        """,
        "You may be surprised at this result, but don't worry - we shall study it right away! :)",
        x -> x==true
    ),
    Activity(
        """
        Let's study the previous activity in a little more detail. Define these propositions:
            c = "Cows have four legs"
            u = "Unicorns are orange"
            p = "Pigs can fly"

        Give me the WFF that represents the proposition from the previous activity, that is:
            "If cows have four legs and unicorns are orange, then pigs can fly."
        """,
        "You can give me your reply in either WFF or String format",
        x -> string(x) == "((c & u) -> p)"
    ),
    Activity(
        """
        In my personal belief-model, c is TRUE, while u and p are both FALSE, so "(c & u)" is FALSE
        in my model. Just to remind you, here again is the recursive rule for the truth-value of an
        implication:
        -   The truth-value of the Implication WFF("->",wff1,wff2) in M is TRUE iff either wff1 is
            FALSE in M, or wff2 is TRUE in M; otherwise, the implication's truth-value is FALSE.
        
        Apply this rule very carefully to find the truth-value of the proposition
            "((c & u) -> p)" = "If cows have four legs and unicorns are orange, then pigs can fly."
        """,
        "",
        x -> true
    ),
    Activity(
        """
        It may seem strange to you that this implication is true, even though everyone know that
        pigs CAN'T fly! The purpose of an implication (u -> p) is to say that if u is true, then p
        must also be true, but how can we even make sense of this implication if u is false?!

        Believe me, you are not alone! Over many centuries, students of logic have asked themselves
        this same puzzled question. The key is to think about models not as reality, but as BELIEFS.
        Immanuel Kant pointed out that we can never know what is Absolutely True, but only what we
        believe to be true. Suppose we define the following two propositions:
            c = "Ani is a computer program."; f = "Ani lacks free will."
        
        If the implication (c -> f) is true in your belief-model, then whenever you believe that
        Ani is a computer program, you also believe that Ani lacks free will. Now, even if you one
        day discovered that Ani is actually a human being, this probably wouldn't change your belief
        that computer programs lack free will! Therefore, we build logic in such a way that the only
        way I can change your belief (c -> f) is by convincing you that c is true AND f is ... ?
        """,
        "",
        x -> x==false
    ),
    Activity(
        """
        Exciting, this, isn't it! :)

        To check your understanding of all we've discussed so far, I want you now to implement the
        method evaluate(WFF,Model) in the module Semantics, which returns the truth value of a
        given WFF within a given model.

        In the previous lab, I checked your answers myself, but please note that I am now passing
        that job over to you. In the method Semantics.demo(), you will find a whole variety of
        wff definitions that have been commented out. By activating each of these definitions
        alternately, you can create a good test environment for your own implementation of the
        evaluate(WFF,Model) method. Implement and test your code with each of these possible wffs,
        and if it produces correct output for ALL of them, you can be satisfied that your work is
        reasonably correct.

        In particular, make sure that demo()'s explicit call to the method evaluate(WFF,Model)
        generates correct output. To do this, you'll need to experiment with various models and
        wffs, but make sure you restore both model and evaluated wff to their original values after
        experimenting. Then reply() me ...
        """,
        "",
        x -> begin
            Main.Semantics.evaluate(
                Main.Propositions.parse( Main.Propositions.WFF, "((p->~q)&r)"),
                Main.Semantics.Model("p"=>true,"q"=>false,"r"=>true)
            )
        end
    ),
    Activity(
        """
        Julius Caesar asked: "What is Truth?", and Kant's answer is: "Truth consists of those
        propositions that are true in all possible belief-models. E.g., the contrapositive rule:
            ((p->q) -> (~q->~p))

        is a true proposition if and only if it evaluates as true in Every Possible model. We call
        such a proposition, that is true under ALL circumstances in ALL belief-models, a Tautology.
        In order to test whether the contrapositive rule is a tautology, we must therefore generate
        all possible belief models of 2 variables. We do this in a Truth-Table:
            Model( "p"=>false, "q"=>false),
            Model( "p"=>false, "q"=>true ),
            Model( "p"=>true,  "q"=>false),
            Model( "p"=>true,  "q"=>true )
              
        Notice how I have ordered this truth-table in Binary Counting Order, where the rightmost
        variable (q) changes value most rapidly. How many different models would the truth-table
        contain if we wanted to test the truth of a proposition containing 7 different variables?
        """,
        "",
        x -> x==128
    ),
    Activity(
        """
        As you see from the previous activity, the number of models in a truth-table increases
        exponentially with the number of variables in the proposition we want to test. For this
        reason, we shouldn't generate these models carelessly. For example, it would be a terrible
        waste of space and time if we were testing for a tautology in N variables, and generated
        ALL 2^N possible models in the truth-table, and then found that the proposition we are
        testing was already false in the first or second model.
        
        We shall therefore be very cunning: Rather than generating all models in the truth-table at
        once, we shall instead implement the truth-table as a Lazy Iterator that generates the
        individual models ONLY when we ask for them in a for-loop. To see how to do this, first
        enter the following lines in the REPL, then reply() me the answer that julia constructs:
            Model = Dict{String,Bool}
            vars = Set(["p","q"])
            tt_row = [false,true]
            Model(vars.=>tt_row)
        """,
        "",
        x -> x == Dict{String,Bool}("p"=>false,"q"=>true)
    ),
    Activity(
        """
        OK, so we now know how to create a Model, and this model forms a row in a Truth-Table that
        will display all possible assignments of truth-values to the variables in a proposition.
        Our next step is to create the full truth-table using comprehension like this:
            tt1 = [Model(vars.=>row) for row in [[false,false],[false,true],[true,false],[true,true]]]

        What type of container have I used here to collect together the 2^2==4 rows of the
        truth-table?
        """,
        "",
        x -> (x <: Vector)
    ),
    Activity(
        """
        Now we'll do something really interesting. Use the up-arrow key to retrieve your truth-
        table definition from the previous activity. Now edit your definition: replace the very
        first and last square brackets of the comprehension by Round brackets, like this:
            tt2 = (Model(vars.=>row) for row in [[false,false],[false,true],[true,false],[true,true]])

        Now compare the contents of tt1 and tt2. Notice how the variable names "p" and "q" are
        contained explicitly in tt1, whereas in tt2, there is only a DataType variable looking
        something like this: `var"#3#4"`. This immediately saves space in our iterator, since it is
        a reference that outsources the names of the variables p and q to the Set `vars` that we
        defined earlier to store those names.

        Use the following for-loop to access the individual models in tt2. Does your printout
        accurately reflect the contents of tt1?
            for model in tt2 println(model) end
        """,
        "",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        tt2 is an Iterator: it uses Lazy Evaluation to generate the models of the truth-table when
        they are needed, without wasting computer memory by storing those models explicitly.

        The only problem with this iterator is that we still had to explicitly provide the binary
        ordered truth-value assignments [[false,false],[false,true],[true,false],[true,true]], and
        you can imagine that this list of possible assignments would get exponentially large if we
        had to take account of 3, 4, 5, ... different variables in a proposition. To avoid this
        exponential increase in the length of the iterator specification, we shall make us of the
        Base.product() function, but in order to do so, we first need to understand how the
        Splat (...) operator works in julia. To start off, reply() me the value of
            ^(3,4)
        """,
        "",
        x -> x==81
    ),
    Activity(
        """
        As you can see, the function ^ takes its first argument and raises it to the power of the
        second argument. Now, we are looking for ways to use one programm to build and run another
        program (the iterator), so it is natural for us to ask whether there is some way of storing
        the arguments 3 and 4 as a vector, and then inserting this vector as a single argument into
        the ^ function - like this:
            ^([3,4])

        Try this now: enter the above command at the julia prompt - does it work ok?
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        Oh dear! The problem is that ^ treats our vector [3,4] as a single (Vector) arguement,
        rather than as two separate values 3 and 4. And this is where the splat operator is very
        useful! What answer do you get back if you enter the following line?
            ^([3,4]...)
        """,
        "",
        x -> x==81
    ),
    Activity(
        """
        Bingo! :) The splat operator takes a vector (or Tuple or Range) and 'splats' its values out
        into an argument list that can be used in a method call. Now let's use this idea to build
        all those truth assignments ([false,false],[false,true],...) that were so troublesome in
        our earlier iterator. Just to remind you, here's the current state of our iterator code :
            tt2 = (Model(vars.=>row) for row in [[false,false],[false,true],[true,false],[true,true]])

        Now, wouldn't it be nice if we could construct all those assignments automatically? This
        is exactly what the function Base.operator() does! At the julia REPL, enter the following
        command now, and reply() me the answer:
            tuples = Base.product([1,2],[3,4,5])
        """,
        "Your answer will look quite confusing, but don't worry! I'll test it",
        x -> collect(x) == [(1,3) (1,4) (1,5);(2,3) (2,4) (2,5)]
    ),
    Activity(
        """
        The object `tuples` that you just created is an Iterator over the entire product space of
        Tuples of the form (i,j), where i ∈ 1:2 and j ∈ 3:5. To see this, enter this command:
            for tup in tuples println(tup) end

        Now enter collect(tuples) to see the way in which this product space iterator orders the
        individual Tuples, and reply() me the type of this structure:
        """,
        "",
        x -> (x <: Array)
    ),
    Activity(
        """
        OK, now let's gather all these partial solutions together. Remember: we want to generate an
        Iterator over all possible models of a set of variables. Here is the code we have so far:
            Model = Dict{String,Bool}
            vars = Set(["p","q"])
            tt = (Model(vars.=>row) for row in [[false,false],[false,true],[true,false],[true,true]])
            collect(tt)

        First create and reply() me a product space iterator that will generate a complete list of
        true/false assignment Tuples for 2 variables In Any Order:
        """,
        "",
        x -> begin
            typeof(x) <: Base.Iterators.ProductIterator &&
            Set(collect(x)) == Set([(false,false),(false,true),(true,false),(true,true)])
        end
    ),
    Activity(
        """
        Great! Now we build this idea into our definition of a truth-table:
            tt = (Model(vars.=>row) for row in Base.product([[false,true] for _ in vars]...))

        Try this out now at the julia REPL. Notice that truth assignments are still not in binary
        counting order. Fix this problem, then use your result to implement the method
        Semantics.truth_table() in the file Semantics.jl. Include your modified version of this
        file, then reply() me so that I can test your code...
        """,
        "Use the function reverse() at an appropriate point in the code",
        x -> begin
            true
        end
    ),
    Activity(
        """
        Now implement the method Semantics.truth_values(), which creates an Iterator over the
        truth-values of a wff in each of a sequence of models.
        """,
        "",
        x -> begin
            true
        end
    ),
    Activity(
        """
        You are now in a position to describe the complete semantics of a wff - its truth-value in
        every possible model. Look at the method Semantics.print_ttable(), which prints to screen a
        pretty version of the truth-table of a given wff. Notice how the first three lines of this
        method call the methods you yourself implemented. Use print_ttable() to check the
        correctness of your implementation of those methods on the various wffs I have commented
        out in demo().
        """,
        "You should not proceed with this Subject until all four wffs in demo() work properly",
        x -> true
    ),
    Activity(
        """
        These three definitions are important in studying the semantics of logical structures:
        -   A proposition is a Tautology if it is True in EVERY possible model.
        -   A proposition is a Contradiction if it is False in EVERY possible moel.
        -   A proposition is Satisfiable if it is True in SOME possible model.

        Now use the methods you have implemented so far to implement the following three methods
        in the Semantics module, and check them using the wffs in demo():
            istautology(wff), issatisfiable(wff), iscontradiction.
        """,
        "The code for all these three methods is basically the same: iterate through the models",
        x -> true
    ),
    Activity(
        """
        Notice that the following wff is a tautology, which under Kant's terminology makes it
        law of Logic. This is our old friend the Contrapositive Law:
            ((c -> f) -> (~f -> ~c))

        The contrapositive rule says that if we believe that statement c implies statement f, we
        must automatically also believe that not-f implies not-c. Let's take our earlier example:
            c = "Ani is a computer program."; f = "Ani lacks free will."

        If you believe (c -> f), the contrapositive law means you also believe (~f -> ~c), i.e.:
            "If Ani has free will then she is NOT a computer program."

        This way of manipulating beliefs and arguments is very useful in science!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Before we finish this labe, I want to remind you of the Anatta project's long-term goals.
        It is our aim in the Anatta project to discover how a world consisting of non-local
        processes can produce things like tables and chairs that seem so structurally stable and
        tangible. To explore this, we have developed two different ways of describing our beliefs
        about our experience: Propositional WFFs and Semantic Meaning.

        WFFs are governed by the syntactic combination rules specified in the WFF constructor,
        while Semantics are generated by the truth-value rules specified in the method
        Semantics.evaluate(WFF,Model). But do wffs and truth-tables describe the same beliefs? Do
        syntactic structures truly cover PRECISELY the same ground as their dynamical meaning?
        
        For example, can you think of a proposition that has no meaning?
        Or do there exist meanings that cannot be expressed in a proposition?
        
        Think very carefully about the importance of these questions for discussing beliefs ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        These questions concern the issues of Soundness and Completeness of the relationship
        between syntactic structures and their semantic meaning:
        -   Soundness: Does every propositional structure describe a truth-table meaning?
        -   Completeness: Can every truth-table meaning be described by some propositional structure?

        In fact, YOU have already proven that the wffs of PL are sound! Which method did you
        implement that generates truth-table semantics from a wff?
        """,
        "Give me the method as a function object",
        x -> x==Main.truth_table
    ),
    Activity(
        """
        To round off this lab, we will prove computationally that wffs are Complete with respect to
        truth-table semantics. That is, you will now finish writing two methods that construct, for
        any truth-table, a proposition whose semantics correspond precisely to that truth-table.

        In Semantics.jl, you will find that I have already implemented the method dnf(), which
        takes a list of variables and a list of truth-values that we wish to assign to each
        poossible model containing those variables. That is, the two arguments `vars` and `tvalues`
        together define a unique truth table, or truth-value function, over the variables. The aim
        of the method dnf() is to compute a wff that generates exactly this truth-table.

        This wff is in Disjunctive Normal Form - it consists of a chain of Terms linked by the
        Disjunction operator `|`, and each of these terms consists of a chain of Factors linked by
        the Conjunction operator `&`. The idea is that each term in the disjunctive chain completely
        specifies a single model in the table, while each factor in a conjunctive chain completely
        specifies a single truth-value in that model. Check out carefully all of the code relating
        to dnf(), run the Semantics.demo() function, make sure you understand how its (mistaken)
        output arises, then complete this lab by implementing the method conjunctive_wff().
        """,
        "The conjunctive_wff() code is similar to the method dnf(), although you can make it more\n" *
            "efficient by using foldl() instead of the iteration that I used in dnf()",
        x -> true
    ),
    Activity(
        """
        Congratulations! You have now proven the Soundness and Completeness of wffs! :))

        I should make a cautionary comment here: The aim of Logic is not only to express beliefs,
        but also to find out whether those beliefs are useful. Later in this Subject, we will
        extend the syntax of PL by introducing the idea of proofs, and this will make it necessary
        to prove soundness and completeness again for this new proof syntax.
        
        But for now, we can take pride in achieving a very important goal along the way: soundness
        an completeness of the Expressivity of wffs! For, although we cannot yet predict whether
        or not a wff is true, we Can be certain that the wff expresses some kind of meaning, and
        this expressivity is vital to our project of building a foundation for science. After all,
        we need to be able to express both true And false beliefs in order to discuss them.

        In the next lab we will look at how incompleteness can arise in syntactic structures.
        """,
        "",
        x -> true
    ),
]
end