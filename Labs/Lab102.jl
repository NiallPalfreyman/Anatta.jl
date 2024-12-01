#========================================================================================#
#	Laboratory 101
#
# Semantics.
#
# Author: Niall Palfreyman, 8/11/2024
#========================================================================================#
include("../src/dev/Logic/Semantics.jl")
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 102: Syntactic Structure and Incompleteness

        What have we achieved so far in this Subject? In labs 100 and 101, we constructed a
        language named PL (Propositional Logic) that consisted of sentences (wffs) and their
        meanings (truth-table columns). Syntax defines the structure of sentences, for example:
            (a -> (a | ~b))

        and Semantics define this sentence's meaning as the rightmost column of this truth-table:
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
        We also proved that there is no gap between the wff sentences and their truth-table
        meaning, in the sense that our definition of PL is both Sound and Complete:
        -   Soundness: Every sentence (wff) has a unique meaning (truth-table column);
        -   Completeness: Every meaning is expressed by some sentence of variables linked by
                            the operators ["T","F","&","|","~","->"]
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
        -   Would PL still be complete if we removed, say, "&" and "|" from its definition?
        -   Could it be (Oh! Horror!) that mathematics itself is incomplete?! That is, are there
            mathematical facts that we will never be able to express in the language of mathematics?

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
        Semantics.evaluate() to handle the new operators, then check that the methods truth_values(),
        pretty_tt(), istautology(), iscontradiction(), issatisfiable() and dnf() from the Semantics
        module all work correctly. When you are satisfied, include() and reply() - you know the
        ritual by now! :)
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
            Would PL still be complete if we removed "&" and "|" from its definition?

        We shall answer this question by implementing Substitution in PL. Removing AND and OR from
        the definition of PL will certainly lower PL's expressivity (and so make it incomplete)
        unless we can always substitute (a & b) and (a | b) by some other expressions in sentences
        Without changing their semantics. So let's look at a few useful substitutions ...

        Is the following sentence true under all circumstances: ((p & q) <-> ~(~p | ~q)) ?
        """,
        "Use istautology()",
        x -> 'y' in lowercase(x)
    ),
    Activity(
        """
        So this substitution is truth-preserving; it is one of the two De Morgan rules of Logic:
        -   (~(p & q) <-> (~p | ~q))
        -   (~(p | q) <-> (~p & ~q))

        And of course we all know this truth-preserving substitution:
        -   (~~p <-> p)

        To perform one of these substitutions, we must do two things: recognise the operators that
        characterise the substitution, then substitute the variables that are linked together by
        those operators. We will implement this in two stages, starting with substituting the
        variables. Locate the stub method Propositions.substitute_vars(); What argument type are we
        using to model a substitution?
        """,
        "",
        x -> x <: Dict
    ),
    Activity(
        """
        Now write the missing code in substitute_vars(). This code should implement the
        specification given in the accompanying docstring, and should NOT proliferate the number
        of wffs unnecessarily. In other words, if the variable p occurs twice in the original
        sentence, and is to be substituted by the wff (r & s), this wff should only be created
        once, and each occurrence of p should be replaced by a pointer to the single WFF instance.

        reply() me when your code is ready! :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
    Activity(
        """
        """,
        "",
        x -> true
    ),
]