#========================================================================================#
#	Laboratory 202: Incompleteness and substitution.
#
# Author: Niall Palfreyman, 23/11/2024
#========================================================================================#
let
include("../src/dev/Logic/Semantics.jl")
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 202: How does Incompleteness arise?

        What have we achieved so far in this Subject? In labs 100 and 101, we constructed a
        language named PL (Propositional Logic) that consisted of sentences (wffs) and their
        meanings (truth-table columns). Syntax defines the Structure of sentences, for example:
            (a -> (a | ~b))

        and Semantics define this sentence's Meaning as the rightmost column of this truth-table:
            | a | b | ~b | (a | ~b) | (a -> (a | ~b)) |
            -------------------------------------------
            | 0 | 0 | 1  | 1        | 1               |
            | 0 | 1 | 0  | 0        | 1               |
            | 1 | 0 | 1  | 1        | 1               |
            | 1 | 1 | 0  | 1        | 1               |
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We also proved that there is no gap between wffs and their truth-table meaning, in the
        sense that our syntax for wffs is both Sound and Complete:
        -   Soundness: Every sentence (wff) has a unique meaning (truth-table column);
        -   Completeness: Every meaning (truth-table column) can be expressed by some wff that
                        contains variables linked by the operators ["T","F","&","|","~","->"].
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now, what would happen if we changed the operators that we use to define PL? For example,
        suppose we created a new language PL1 that could only use the operators ["T","F","&","|"].
        Would this set of operators also be complete? What do you think?
        """,
        "Every answer is correct here - we are just wondering about what might happen",
        x -> true
    ),
    Activity(
        """
        One way to prove the incompleteness of PL1 would be to find a Counterexample: a truth-table
        column that we cannot state as a wff in PL1. For example, suppose we would like to use the
        operators ["T","F","&","|"] of PL1 to construct the truth-table column for the wff ~a. We
        could for example set up the following columns:
            | a | (a & F) | (a | a) | ~a |
            ------------------------------
            | 0 | 0       | 0       | 1  |
            | 1 | 0       | 1       | 0  |

        As you see, neither the second nor the third column exactly matches the fourth truth-table
        column described by the wff ~a. Now you try. reply() me your true/false answer to the
        question: Is it possible to set up a wff in PL1, whose truth-table column matches that of
        the wff "~a"?
        """,
        "",
        x -> !x
    ),
    Activity(
        """
        The set of operators in PL1 is small enough that we can try out all possible truth-table
        columns, and so discover that there is no way we can ever create a wff whose truth-table
        exactly matches that of ~a. In this way, we can prove that the language PL1, based on the
        operators ["T","F","&","|"], is Incomplete: there exists at least one meaning [~: 0->1, 1->0]
        that PL1 can Never describe in a sentence. PL1 is strictly LESS expressive than PL!

        This idea of incompleteness raises many interesting questions about syntactic structures:
        -   If we add new operators to PL, does the syntax become more expressive?
        -   Is PL still be complete if we base its definition on the operators ["&","|","~"]?
        -   Could it be (Oh! Horror!) that mathematics itself is incomplete?! That is, are there
            mathematical truths that we will never be able to express in the language of mathematics?

        We shall answer ALL of these questions in this Anatta Subject! Hooray!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        First, let's take a look at some new binary operators that are regularly used in computer
        science and digital engineering, together with their truth-table semantics:
                    |   xor   |    iff    |   nand   |   nor    |
            | a | b | (a + b) | (a <-> b) | (a -& b) | (a -| b) |
            -----------------------------------------------------
            | 0 | 0 | 0       | 1         | 1        | 1        |
            | 0 | 1 | 1       | 0         | 1        | 0        |
            | 1 | 0 | 1       | 0         | 1        | 0        |
            | 1 | 1 | 0       | 1         | 0        | 0        |

        Start implementing these by modifying the return value of Propositions.isbinary() to:
	        op2 in ["&", "|", "->", "+", "<->", "-&", "-|"]

        Include your modified module Propositions, then reply() me.
        """,
        "Replace the previous code in isbinary() by this new line of code",
        x -> Main.Propositions.isbinary("<->") && Main.Propositions.isbinary("-&")
    ),
    Activity(
        """
        I specifically chose these operation symbols so that they can be LL-parsed. You therefore
        shouldn't need to make any further changes to your parsing code: by simply recognising the
        new symbols as binary operations, your parsing code should work. However, unless you
        previously allowed for longer (3-character) symbols, you will need to make the necessary
        changes to the method Propositions.parse_binary(), to ensure that it recognises the
        possibility of binary operators of length 3 characters. When you have done this, include()
        your code, then reply(), and I will test your parsing code.
        """,
        "",
        x -> string(Main.Propositions.wff("(a <-> (b + (c -& (d -| a))))")) ==
                string(wff("(a <-> (b + (c -& (d -| a))))"))
    ),
    Activity(
        """
        Next, we must implement the semantics of our new operators. Extend your code in the method
        Semantics.evaluate(WFF,Model) to handle the new operators, then check that the methods
        truth_values(), pretty_tt(), istautology(), iscontradiction(), issatisfiable() and dnf()
        from the Semantics module all work correctly. When you are satisfied, include() and
        reply() - you know the ritual by now! :)
        """,
        "",
        x -> Main.Semantics.istautology(Main.Propositions.wff("~((a-|b)+(~a&~b))"))
    ),
    Activity(
        """
        Earlier, we asked whether the syntax of PL would become more expressive if we add new
        operators. To answer this question, first use your code to check that the following four
        sentences are tautologies:
            ((a+b)   <-> ((a|b) & ~(a&b)))
            ((a<->b) <-> ((a->b) & (b->a)))
            ((a-&b)  <-> ~(a & b))
            ((a-|b)  <-> ~(a | b))

        Are they all tautologies?
        """,
        "Use the call istautology(wff(\"((a-|b)  <-> ~(a | b))\"))",
        x -> 'y' in lowercase(x)
    ),
    Activity(
        """
        To see how this proves that the new operators have not increased PL's expressivity, focus
        as an example on the third of these sentences, containing the well-known operator NAND:
            ((a-&b)  <-> ~(a & b))

        Notice that the wff standing to the left of the iff-operator is "a nand b", while the wff
        to the right of the iff-operator is the definition of nand: "not (a and b)". The name "iff"
        is short for "if, and ONLY if", so the fact that this iff-sentence is a tautology means it
        is true in ALL models that the left- and right-hand wffs have exactly the same truth-value!
        
        So (a-&b) is TRUE in precisely those situations where ~(a & b) is TRUE, and is FALSE in
        precisely those situations where ~(a & b) is FALSE. This means that if we ever find the
        expression (a-&b) in a sentence, we can always replace it by the expression ~(a & b)
        without changing the truth-value of the sentence. Can you think of another name for iff?
        """,
        "",
        x -> occursin("equiv",lowercase(x))
    ),
    Activity(
        """
        Iff is also called the Equivalence operator (≡). The fact that the following four sentences
        are tautologies means we can always substitute the left-hand side of the equivalence by the
        right-hand side in any sentence:
            ((a+b)   <-> ((a|b) & ~(a&b)))
            ((a<->b) <-> ((a->b) & (b->a)))
            ((a-&b)  <-> ~(a & b))
            ((a-|b)  <-> ~(a | b))

        This idea of Substitution is enormously important. It means that these four new operators
        do not make PL more expressive, because we can substitute them by particular arrangements
        of the previously existing operators ["T","F","&","|","~","->"]. reply() me the WFF
        equivalent of (a<->b):
        """,
        "",
        x -> string(x) == "((a -> b) & (b -> a))"
    ),
    Activity(
        """
        This brings us to our second question from earlier:
            Is PL still be complete if we base its definition on the operators ["&","|","~"]?

        We already know from lab 101 that it is possible to build the truth-table of any wff in PL,
        then use this table to translate the wff into a disjunctive normal form (DNF) that contains
        only "&", "|" and "~". So it is definitely possible to reduce the operators in PL to this
        smaller set without damaging its completeness.
        
        Yet this DNF method has a practical problem: it requires us to scan the entire semantics of
        the wff by building a truth-table. If n is the number of variables in the wff, how much
        time and memory resources would we need to build the entire truth-table?
        1.  Linear resources: O(n)
        2.  Polynomial resources: O(n^2), O(n^3), ...
        3.  Exponential resources: O(2^n)
        """,
        "",
        x -> x==3
    ),
    Activity(
        """
        Yes, building truth-tables is Very expensive in time and other resources! For this reason,
        it is more efficient to find a way of eliminating operators syntactically. This is, indeed,
        the entire reason for doing mathematics: it helps us calculate answers structurally, that
        would otherwise take too long to answer. But of course this is only useful if we can be
        CERTAIN that our syntactic structures are complete and cover ALL possible meanings!

        We shall therefore try to use syntactic Substitution to eliminate operators syntactically
        from PL. For, removing "->" from the syntax of wffs will certainly lower their expressivity
        (by making it incomplete) unless we can always substitute (a -> b) in any wff by some other
        structure that leaves the wff's semantics unchanged. Let's look at some substitutions ...

        Use istautology() to find out whether the following sentence is true under ALL
        circumstances: ((p & q) <-> ~(~p | ~q)). Is this a tautology?
        """,
        "Use istautology(wff(\"((p&q) <-> ~(~p|~q))\"))",
        x -> 'y' in lowercase(x)
    ),
    Activity(
        """
        So this substitution is truth-preserving; it is one of the two De Morgan equivalences:
        -   (~(p & q) <-> (~p | ~q))
        -   (~(p | q) <-> (~p & ~q))

        And of course we all know this truth-preserving equivalence:
        -   (~~p <-> p)

        To use an equivalence to perform a substitution, we must do two things: recognise the
        operator that characterises the substitution, then substitute the variables that are linked
        together by that operator. Let's make this easier to understand by looking at a concrete
        example. Suppose we rewrite De Morgan's second equivalence in the following way. What would
        then be the wff on the right-hand side of the equivalence?
            ((p | q) <-> wff)
        """,
        "",
        x -> string(x) == "~(~p & ~q)"
    ),
    Activity(
        """
        Right, so suppose we want to apply De Morgan's secoond equivalence to the following wff:
            Apply ((p | q) <-> ~(~p & ~q)) to the wff: (~x | (z & y))
        
        We must first scan the wff to recognise the operator | that characterises the left-hand
        side of De Morgan's second equivalence, then locate its two operands (p and q). In the wff,
        the operand p corresponds to the sub-wff ~x. Having recognised this, we must then
        substitute this sub-wff into the right-hand side of De Morgan's second equivalence, by
        replacing p by ~x in the structure ~(~p & ~q). By what must we replace q in the structure
        ~(~p & ~q)?
        """,
        "",
        x -> string(x) == "(z & y)"
    ),
    Activity(
        """
        Great! Now we are ready to implement substitution for ourselves! Locate now the method
        Propositions.substitute_ops() that I have already implemented. This method takes as
        arguments a WFF named woof and a substitution map that replaces the binary structure of an
        operator such as "|" by a new structure such as ~(~p&~q). What type does substitute_ops()
        use to implement such a substitution map?
        """,
        "",
        x -> x <: Dict || x <: Pair
    ),
    Activity(
        """
        So substitute_ops() implements substitution maps using a Dict containing pairs such as
        "|"=>~(~p&~q). In this substitution map, p stands for whatever wff is the first argument of
        the | operator, and q stands for whatever wff is the second argument of the | operator.

        Study the code in method substitute_ops(). First, it recognises that it can simply return
        constants and variables unchanged. Next, it recognises that if the operator in woof is not
        mentioned in the substitution map, it need only substitute the operations in woof's
        arguments. It achieves this by calling substitute_ops() recursively on each argument, then
        reassembling the results and returning them as a new WFF containing the original, unchanged
        operator.

        reply() me when you have studied this first half of substitute_ops() up to the end of the
        first, long if-statement.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        After checking each of these special situations, the only remaining possibility is that the
        operator in woof.head appears in the substitution map, and so requires substitution. This
        is performed by the code in the second half of substitute_ops() ...

        To perform the actual substitution, substitute_ops() first assembles a new substitution map
        for the variables p and q:
            var_substitution = Dict("p"=>~x,"q"=>(z & y))

        Then it calls the method substitute_vars to apply this map to the right-hand side ~(~p&~q)
        of De Morgan's second equivalence and actually create the new, substituted structure.
        
        OK, so let's test all that we've been discussing. In the julia console, include and use
        Propositions.jl, then experiment with the substitution we've just been studying by entering
        the following command at the julia console. Then reply() me whether your result is correct:
            substitute_ops( wff("(~x|(z&y))"), Dict("|"=>wff("~(~p&~q)")))
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        If you look at the method substitute_vars(), you will see why your result was incorrect:
        substitute_vars() still only implements stub functionality that simply returns the
        unchanged woof. Now it's your turn...

        It is your task to implement the missing code in substitute_vars(). Your code should
        implement the specification in the accompanying docstring, and should NOT create WFFs
        unnecessarily. In other words, if the variable p occurs twice in the original woof, and is
        to be substituted by the wff ~x, the wff ~x should only be created Once, and each
        identifier p should be a reference to that single WFF instance. You can test your code
        using this call at the julia prompt:
            substitute_vars( wff("(p->(p&q))"), Dict( "p"=>wff("(q|r)"), "q"=>wff("r"), "r"=>wff("(p&r)")))

        The result should look like this: ((q|r)->((q|r)&r)). reply() me when your code is ready ...
        """,
        "Copy the code from show(), then replace the print() calls " *
            "to return recursively substituted WFFs",
        x -> string(Main.Propositions.substitute_vars( Main.wff("(p->(p&q))"),
            Dict("p"=>Main.wff("(q|r)"),"q"=>Main.wff("r"),"r"=>Main.wff("(p&r)"))
        )) == "((q | r) -> ((q | r) & r))"
    ),
    Activity(
        """
        If my unit testing of your method substitute_vars() ran correctly, it's now time to perform
        integration testing of your implementation by calling substitute_vars from within
        substitute_ops():
            substitute_ops( wff("((x|y)&~x)"), Dict( "&"=>wff("~(~p|~q)"), "|"=>wff("~(~p&~q)")) )

        Try this for yourself, if you like. The result should look like this: ~(~~(~x & ~y) | ~~x).
        Then reply() me when you're ready ...
        """,
        "",
        x -> string(Main.Propositions.substitute_ops( Main.wff("((x|y)&~x)"),
            Dict("&"=>Main.wff("~(~p|~q)"),"|"=>Main.wff("~(~p&~q)"))
        )) == "~(~~(~x & ~y) | ~~x)"
    ),
    Activity(
        """
        Now that we have implemented substitution computationally, recall that we are trying to
        answer the second of our questions from the beginning of this lab:
            Are PL wffs complete if we base their syntax on the operators ["&","|","~"]?

        The answer to this question is True iff we can prove that it is possible to transform
        syntactically (i.e., structurally) EVERY other operator expression into one involving only
        ["~","&","|"]. The easiest way to prove this is to write a computational method for
        performing this structural transformation, and that is your next task....
        
        Implement the stub functionality in the method Propositions.to_not_and_or() by using your
        freshly implemented method substitute_ops() to convert any wff into one containing only
        ["~","&","|"]. You can then check the method's correctness by using it to find the
        ["~","&","|"] form of the contrapositive wff in Propositions.demo(), which is:
            (~(~p | q) | (~~q | ~p))

        reply() me when your code is working correctly ...
        """,
        "You may get some hints by looking at my implementation of the method to_not_implies()",
        x -> true
    ),
    Activity(
        """
        Now implement the method to_not_and(), which converts any wff into one containing only
        ["~","&"]. You can then check the method's correctness by using it to find the ["~","&"]
        form of the contrapositive wff in Propositions.demo(), which is:
            ~(~~~(~~p & ~q) & ~~(~~~q & ~~p))

        reply() me when your code is working correctly ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, we have achieved our goals for this lab! We discovered that adding new operators such
        as ["<->","+","-&","-|"] to PL does NOT increase its expressiveness (i.e., the set of all
        meanings expressible in the language). We also discovered that it is possible to reduce the
        number of operators in the definition of wff syntax without making their expressivity
        incomplete (i.e., their ability to express ALL possible truth-table meanings).
        
        So we are free (within limits) to choose for ourselves which operators we use to define PL!

        The advantage of using many operators is that it makes it easier for us to express certain
        things. For example, in its full form, the contrapositive rule is not just an implication,
        but also an equivalence with this form:
            ((p->q) <-> (~q->~p))

        The only change I have made here is to modify the topmost-level implication into an iff
        operator. Make this change at the topmost level of the wff `contrapositive` in
        Propositions.demo(), then remove the comment marker lower down, so that demo() calls the
        method to_not_implies() to translate this equivalence into a language that only uses
        ["~","->"]. Just notice how much more difficult it is to understand this ["~","->"] form!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Wow! You can see why people prefer to use straightforward operators such as "&" and "<->"!

        Yet there is also an advantage to using a language that is defined minimally. For example,
        in this course we will base our definition of PL on precisely these two operators: ["~","->"].
        
        You might ask: Why would we do such a strange thing? Why tie one hand behind our backs, so
        to speak? The reason is that this will makes proving theorems about the language Much
        easier! Imagine what it would be like if we had to prove some exciting new property of PL
        using all of the operators ["T","F","&","|","~","->","<->","+","-&","-|"]. We would have to
        prove our new property for Every sentence that uses even just one of these operators!
        
        But with the reduced set of operators ["~","->"], life is much easier, because we know that
        all other operators can be substitutes by some combination of "~" and "->". As a result, we
        only need to prove our property for sentences that use these two. Laziness is Cool! ;)
        
        To close this lab, please use the method to_not_implies() to translate a few simple wffs
        of your choice into this new ["~","->"] version of PL, then use a truth-table to check that
        my substitution is correct. Then we will see each other again in the next lab. Have fun! :)
        """,
        "",
        x -> true
    ),
]
end