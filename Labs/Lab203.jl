#========================================================================================#
#	Laboratory 203: Structural computation
#
# Author: Niall Palfreyman, 8/12/2024
#========================================================================================#
let
include("../src/dev/Logic/Proofs.jl")
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 203: How does Inference implement computation?

        Why do we do mathematics? To help us think about this, take the simple example of adding
        together two numbers. What is addition, and how do we do it? Suppose we have 3 sheep in
        one field and 2 sheep in another field. We add these together by adjusting our perspective
        so that the sheep together form just one group - possibly by herding them into one field.
        Addition IS this merging of two groups into one group that can be counted.
        
        Now suppose you used this method to add together the following populations of two towns,
        and you needed 1 second to count each person. Approximately how many years would it take
        you to find the sum of these two populations:
            15253812 + 16303788 ?
        """,
        "Just give me an approximate value",
        x -> 0.9 < x < 1.1
    ),
    Activity(
        """
        Adding together two numbers in this way has Linear Complexity. That is, the amount of
        resources we need to add in this way is directly proportional to the combined size of the
        two numbers; if we count 2N people, it takes about twice as long as counting N people:
            The complexity of Counting-addition has order O(N).

        But of course you and I both know that mathematics offers us a faster way to perform this
        addition by using Place Notation to denote numbers as the coefficients of powers of 10:
            15253812 == 1e7 + 5e6 + 2e5 + 5e4 + 3e3 + 8e2 + 1e1 + 2e0 .

        What is the name of the mathematical relationship between the length of a number in digits
        and the size of the number that those digits represent?
        """,
        "Think about a 5-, 6- or 7-digit number; how big are the corresponding numbers?",
        x -> occursin("log",lowercase(x)) || occursin("exp",lowercase(x))
    ),
    Activity(
        """
        To compute the sum of the above two numbers, we use the addition relations that we learned
        in primary school: we add together the power-10 coefficients of the two numbers, and use
        standard rules for carrying over from one power of 10 to the next. The time it takes to
        compute this sum is not proportional to the size of the numbers, but to the Length of their
        power-10 notation. We say that place-based addition has Logarithmic Complexity:
            The complexity of Computing-Addition has order O(log(N)).

        This is Much faster! How many seconds would you need to perform the addition now?
        """,
        "I'm only looking for an approximate answer! :)",
        x -> x < 100
    ),
    Activity(
        """
        So we can add by dynamically merging and counting, or we can add by computation. The first
        is a physical, continuously dynamical process; the second is the stepwise manipulation of a
        structural model. The first links addition to our physical experience; the second is Fast.

        The subject of how things change over time is called Dynamics, but computation doesn't
        proceed through time, but rather through sequences of descrete operations. A computer can
        never time the cooking of an egg - to do that, we must connect the computer to a physical,
        dynamical clock. For this reason, in Anatta we use the following terms:
        -   Dynamics describes how the state of physical systems flows continuously through time;
        -   Computation describes how structures operate discretely from one state to the next.

        Which famous mathematician published in 1891 a Diagonal Argument, proving that there are
        infinitely many more continuous (real) numbers than discrete fractions between 0 and 1?
        """,
        "His first name was Georg! :)",
        x -> occursin("cantor",lowercase(x))
    ),
    Activity(
        """
        Mathematics studies how we use computation to Predict dynamics - that is, to compute some
        result faster than dynamical experience can present it to us. In the above example, we built
        a structural model (the place notation for numbers), then defined a computational rule
        (adding place coefficients) that generated the sum faster than physical counting.

        We have already seen in this Subject that PL wffs are sound (every wff has a unique
        truth-value, given the truth-values of its variables) and complete (every truth-table is
        denoted by some wff). These qualities apply to the expressivity of PL, but unfortunately,
        that is not yet sufficient to perform the mathematical activity of prediction. To achieve
        that, we need to compute (we say: Deduce) specifically True propositions. What name do we
        use for a proposition that is definitely true under all circumstances?
        """,
        "You implemented a method to test for this property in the previous lab",
        x -> occursin("tautolog",lowercase(x))
    ),
    Activity(
        """
        So, to summarise our aims in this Subject: We want to discover how Science and Mathematics
        uses a small set of Axioms (propositions that we generally agree are true), to deduce
        Theorems that we can then be Absolutely Certain are true, provided the axioms are true.
            THIS IDEA THAT PROOF GUARANTEES TRUTH IS THE ENTIRE BASIS OF SCIENTIFIC ACTIVITY!

        We will say that computation and deduction are ...
        -   Sound if the theorems we deduce are Always True (i.e., tautological) propositions; and
        -   Complete if there is a way of deducing Every Tautology as a theorem.

        These ideas led David Hilbert in 1900 to ask the following fundamental question:
        -   Might the axioms of number arithmetic generate any contradictions? Or in other words...
        -   Is the number-structure of science both sound and complete? Or...
        -   Can computation generate Only and All the true statements of mathematics?!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        The basic computational mechanism of mathematics is an Inference Rule, consisting of a list
        of zero or more wffs called the Assumptions of the rule, and one further wff called the
        Conclusion of the rule.

        The idea here is that inference rules play two different roles in mathematics. On the one
        hand, we use the inference rule as a truth-preserving way of deducing new true propositions
        step-by-step from existing ones. On the other hand, if we succeed in completing such a
        deductive proof, we call the inferential path from assumptions to conclusion a Theorem, and
        this theorem is itself then also a new inference rule!
        
        Here are two examples of inference rules - one with two, and one with no, assumptions:
        -   Assumptions: [(p|q),(~p|r)],    Conclusion: (q|~r)
        -   Assumptions: [],                Conclusion: (p|~p)

        If the inference rule has no assumptions, we call it an Ax... ?
        """,
        "What do we call a statement that we assume to be true without any prior assumptions?",
        x -> occursin("axiom",lowercase(x))
    ),
    Activity(
        """
        So we build mathematics by constantly proving new theorems, then using these theorems to
        prove even more new theorems! Hilbert's question is therefore:
            Does this construction process generate a set of theorems that is bigger (and therefore
            either unsound or inconsistent), or smaller (and therefore incomplete) than the set
            of true statements?

        We have now reached a stage where we can use Julia to implement this construction of
        mathematics and so find answers to Hilbert's question. We will generate InferenceRules
        automatically and see where this leads us. Go and look now at the module Proofs in the file
        Proofs.jl, and use your existing method Propositions.variables() to implement the stub
        method Proofs.variables(). Then include Proofs.jl and reply() me.
        """,
        "",
        x -> begin
            Main.Proofs.variables(
                Main.Proofs.InferenceRule([
                        Main.Propositions.wff("(p|q)"),
                        Main.Propositions.wff("(~p|r)")
                    ],
                    Main.Propositions.wff("(q|r)")
                )
            ) == Set(["p","q","r"])
        end
    ),
    Activity(
        """
        Of course, at the moment there is nothing to prevent us from creating really silly
        inference rules like this one:
            InferenceRule([wff("p")],wff("~p"))

        So if we want PL to reason sensibly, we'll need to think about which kinds of inference
        rules are silly, and which are sensible. We say that a set of assumptions A Entails some
        conclusion c if every model that satisfies all of the assumption wffs in A also satisfies
        the conclusion wff c; in this case, we describe the inference rule as Truth-Preserving,
        or Sound, and we write A |= c.

        Is it correct for me to claim that: [(p->q)] |= (q->p) ? If not, reply() me a 2-Tuple of
        truth-values for the two propositions p and q respectively, which provides a counterexample
        to my claim.
        """,
        "",
        x -> x == (1,0)
    ),
    Activity(
        """
        Here are two sound inference rules:
            [~~p]       |= p                    # Double-negation elimination
            [p, (p->q)] |= q                    # Modus ponens

        The first enables us to deduce that "It is raining" from the proposition "It is not not
        raining". The second is an important generator of new propositions, and enables us to deduce
        from "It is raining" and "If it is raining, then the grass is wet" that "The grass is wet".

        Go now to the Julia file Semantics.jl and implement (in the following order) the two
        methods Semantics.evaluate(InferenceRule,Model) and Semantics.issound(InferenceRule).
        Verify your code by testing the following commands at the Julia prompt:
            using .Semantics
            issound( InferenceRule( wff("~~p"), wff("p")))                  == true
            issound( InferenceRule( [wff("p"),wff("(p->q)")], wff("q")))    == true
            issound( InferenceRule( wff("(p|~p)")))                         == true
            issound( InferenceRule( wff("(p->q)"), wff("(q->p)")))          == false
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Great! :) We now have a way of testing the soundness of the inference rules that will
        execute the computational operations of our PL structure. Next, we need a way of
        specialising these rules in order to use them in specific situations. For example, the
        rule ~~p |= p enables us to deduce both q from ~~q, and (p+q) from ~~(p+q), depending on
        whether we substitute "q" or "(p+q)" for "p" in the rule. We call these substitutions
        Specialisations, because they create a special instance of the inference rule.

        Implement the method Proofs.specialisation(), which specialises an InferenceRule by
        substituting variables in the assumptions and conclusion of the rule. Then verify your
        implementation using this test scenario:
            specialisation(
		        InferenceRule( [wff("p"),wff("(p->q)")], wff("q")),
		        SpecialisationMap("p"=>wff("(p|q)"),"q"=>wff("r"))
	        ) == InferenceRule(WFF[(p | q), ((p | q) -> r)], r)
        """,
        "Remember to call your existing method Propositions.substitute_vars()",
        x -> true
    ),
    Activity(
        """
        Remember that our goal is to discover whether there is any gap between the soundness and
        the completeness of structural languages: whether everything we compute is actually true,
        and whether everything that is true can actually be computed. Now, computation in PL is
        simply proof, and proofs work by taking inference rules and specialising them to particular
        situations. Therefore, to check whether some proposition is provable, we must check whether
        its proof is specialising inference rules correctly. This is our next task!

        For an inference rule S to specialise a general rule G, it must satisfy these 3 conditions:
        -   All occurrences of each particular variable in the assumptions and conclusion of G must
            match the same wff in S;
        -   The head of each non-variable wff in G must match an identical head in S, and its
            arguments must recursively match those in S according to these same 3 conditions.
        -   The number of assumptions in S and G must be the same;

        Which structure defines the corresponding match between variables in G and wffs in S?
        """,
        "",
        x -> x == "SpecialisationMap" || x == Main.Proofs.SpecialisationMap
    ),
    Activity(
        """
        We will implement this task in three steps:
        -   merge( sm1::SpecialisationMap, sm2::SpecialisationMap) checks the consistency of two
            given SpecialisationMaps, and merges them into one if they are consistent;
        -   wff_specialisation() uses merge() to explore whether there exists a SpecialisationMap
            that links two given wffs into a specialisation relationship;
        -   specialisation_map() uses wff_specialisation() to check whether a given InferenceRule
            sinfrule is a specialisation of another, more general, InferenceRule ginfrule.

        Implement now the method Proofs.merge(), and verify it using these use-cases:
            merge( SpecialisationMap(), nothing) == nothing
            merge( nothing, SpecialisationMap()) == nothing
            merge( SpecialisationMap("x"=>"a","y"=>"b"), SpecialisationMap("x"=>"a","y"=>"c")
            ) == nothing
            merge( SpecialisationMap("x"=>"a","y"=>"b"), SpecialisationMap("y"=>"b","z"=>"c")
            ) == SpecialisationMap("x"=>"a","y"=>"b","z"=>"c")
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now implement the method specialisation_map(gwff,swff), which finds, if possible, a
        SpecialisationMap from the general wff gwff to the specialised wff swff, and returns
        nothing if it cannot find such a map. Remember, the head of each non-variable wff in
        gwff must match an identical head in swff, and its arguments must recursively match
        those in swff. On the other hand, the head of a variable wff could be one of the keys
        in a SpecialisationMap. Verify your code using these test cases:
            specialisation_map( "~F", "~T") == nothing
            specialisation_map( "F", "(x|y)") == nothing
            specialisation_map( "(x&y)", "(F&F)") == SpecialisationMap("x"=>"F", "y"=>"F")
            specialisation_map( "(~p->~(q|T))") "(~(x|y)->~((z&(w->~z))|T))"
                == SpecialisationMap("p"=>"(x|y)", "q"=>"(z&(w->~z))")
            specialisation_map( "(~p->~(q|T))", "(~(x|y)->((z&(w->~z))|T))") == nothing
        """,
        "Make recursive use of the merge() method that you just " *
            "implemented between SpecialisatiomMaps",
        x -> true
    ),
    Activity(
        """
        Finally, implement the method specialisation_map(ginfrule,sinfrule), which finds, if
        possible, a SpecialisationMap from the general InferenceRule ginfrule to the specialised
        InferenceRule sinfrule, and returns nothing if it cannot find such a map. Remember, the
        order of assumptions in ginfrule and sinfrule must be the same, and both assumptions and
        conclusion must all use exactly the same SpecialisationMap. Verify using these use-cases:
            specialisation_map(
                InferenceRule(["(p->q)","(p&p)"],"p"),
                InferenceRule(["(~T->(r&~z))","(~T&~T)"],"~T")
            ) == SpecialisationMap("p"=>"~T","q"=>"(r&~z)")
            specialisation_map(
                InferenceRule(["(p->q)","(p&p)"],"p"),
                InferenceRule(["(~T->(r&~z))","(~F&~F)"],"~T")
            ) == nothing
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Congratulations! You have successfully implmented a way of creating and testing sound
        inference rules and then specialising them for use in computation. As I mentione before,
        computation in mathematics is simply Deductive Proof. That is, we can test the truth of
        any proposition in mathematics by drawing up its truth-table. However, this is Very
        Expensive in time and computing resources, so instead, we want to Prove the truth of the
        proposition by deducing it computationally from a small set of axioms that we already
        know are true.

        Building and testing such proofs is our Next Exciting Adventure!
        """,
        "",
        x -> true
    ),
]
end