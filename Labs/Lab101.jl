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
        organisms, but for now, we shall think of meaning as depending on the belief-Model of the
        world in which some interpreting organism believes.

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
        in my model. Here again is the recursive rule for the truth-value of an implication:
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

        Believe me, you are not alone! Over centuries, students of logic have asked themselves this
        same puzzled question. The key is to think about models not as reality, but as BELIEFS.
        Immanuel Kant pointed out that we can never know what is Absolutely True, but only what we
        believe to be true. Suppose we define the following two propositions:
            c = "Ani is a computer program."; f = "Ani lacks free will."
        
        If the implication (c -> f) is true in your belief-model, then whenever you believe that
        Ani is a computer program, you also believe that Ani lacks free will. Now, even if you one
        day discovered that Ani is actually a human being, this probably wouldn't change your belief
        that computer programs lack free will! Therefore, we build logic in such a way that the ONLY
        way I can change your belief (c -> f) is by convincing you that c is true and f is ... ?
        """,
        "",
        x -> x==false
    ),
    Activity(
        """
        Exciting, this, isn't it! :)

        To check your understanding of all we've discussed so far, I want you now to implement the
        method evaluate() in the module Semantics. ???
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