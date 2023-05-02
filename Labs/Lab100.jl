#========================================================================================#
#	Laboratory 100
#
# Welcome to Subject 100: Formal Logic
# This Subject draws heavily upon the ideas in the following book:
#   Gonczarowski, Y.A. & Nisan, N. (2022). Mathematical logic through Python. CUP.
#
# Author: Niall Palfreyman, 30/04/2023
#========================================================================================#
include("../src/dev/Logic/Syntax.jl")
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 100:
            Formal Logic - Beliefs have structure, but structures ALWAYS have gaps!
        
        In Subject 0, we learned how to use julia's computational structures to describe and
        manipulate data. Knowing how much we can do with programming languages, it would be easy to
        believe that we can use structures to describe ANYTHING that we observe in the world around
        us. After all, a structure is a set of things together with the relations between those
        things, so surely everything consists of things and relations, doesn't it?!

        In Subject 100, we shall find reasons to both believe and disbelieve this hypothesis ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Ferdinand de Saussure (1857-1913) proposed the idea that languages consist of signs
        that possess two parts: a Signifier (a linguistic structure such as a word), and a
        Signified (the meaning of that word). This idea developed during the twentieth century 
        into Formal Linguistics, which divides the study of languages into two separate areas:
            - Syntax is the study of structural forms;
            - Semantics is the study of the meanings signified by these syntactic forms.

        In this lab, we explore the syntax of beliefs; in later labs, we look at their semantics.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We will start off by thinking about a very simple language called Propositional Logic.
        Propositional Logic is made up of sentences (Propositions) that can be either true ("T") or
        false ("F"). We can also use the connectives "and" (&), "or" (|) and "not" (~) to link
        together existing sentences into new ones. Here is an example proposition:
            s1 = "If Ani goes to school, she walks to the bus-stop and takes the 465 bus."

        We can construct s1 by linking together three simpler propositions:
            p1 = "Ani goes to school"
            p2 = "Ani walks to the bus-stop"
            p3 = "Ani takes the 465 bus"

        each of which is again definitely either true or false.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We can write the proposition s1 as a logical connection between the simpler propositions:
            s1 = (p1 -> (p2 & p3))

        In other words: "p1 implies that both p2 and p3." The aim of propositional logic is to help
        us prove conclusions from the sentence s1 such as:
            "If Ani doesn't walk to the bus-stop or doesn't take the 465 bus, she doesn't go to school"

        To achieve this, we will use julia Strings to denote propositions. In the next activity, I
        will show you a set of grammar rules that define the structure of a propositional Well-Formed
        Formula (WFF) ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Here is a set of grammar rules that define the structure of a WFF. In these rules, the symbol
        ':' means "can be a ...", ';' means "or ...", and '*' means "concatenated with ..." :
            wff         : variable; constant; unary_expr; binary_expr.
            variable    : letter * number.
            constant    : "T"; "F".
            unary_wff   : "~" * wff.
            binary_wff  : "("*wff*"&"*wff*")"; "("*wff*"|"*wff*")"; "("*wff*"->"*wff*")".
            letter      : "a"; "b"; "c"; ...; "x"; "y"; "z".
            number      : digit; digit * number.
            digit       : "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "0".

        reply() me a String containing a valid constant.
        """,
        "Enter reply(string), where string obeys the above rules for a constant (no spaces!)",
        x -> Syntax.is_constant(x)
    ),
    Activity(
        """
        Now reply() me a String containing the name of a valid variable.
        """,
        "Enter reply(string), where string obeys the above rules for a variable",
        x -> Syntax.is_variable(x)
    ),
    Activity(
        """
        The single unary operator available means NOT, so
            ~p3 means: "It is NOT the case that Ani takes the 465 bus"

        reply() me the wff meaning "It is NOT the case that Ani goes to school":
        """,
        "You might need to scroll up a bit to remind yourself of the wff names",
        x -> x == "~p1"
    ),
    Activity(
        """
        The available binary operators are "&" (AND), "|" (OR) and "->" (IMPLIES), so
            (p2 & p3) means: "Ani walks to the bus-stop AND Ani takes the 465 bus"

        reply() me ANY binary operator:
        """,
        "Remember that we are working specifically with String structures at the moment",
        x -> Syntax.is_binary(x)
    ),
    Activity(
        """
        Over the last four activities, I have been checking your replies using the following
        methods implemented in the module Syntax:
            is_constant(), is_variable(), is_unary() and is_binary()

        Soon, I will ask you to implement some extra methods in the Syntax module, so please now
        setup() the Logic library in your Anatta home folder, open the file Syntax.jl in VSC and
        study the above four methods.

        What is the name of the function I use to check whether a variable contains a number?
        """,
        "Remember that a variable consists of a letter concatenated with a number",
        x -> x==Main.tryparse || occursin("tryparse",x)
    ),
    Activity(
        """
        To prepare for the implementation activities, make sure your julia console is located
        within your Anatta home folder, then include and load the Syntax module:
            include("Development/Logic/Syntax.jl")
            using .Syntax
        """,
        "Follow all THREE instructions (home, include, using), then reply()",
        x -> isfile("Development/Logic/Syntax.jl") && Main.Syntax.WFF isa Type
    ),
    Activity(
        """
        In the Syntax module, I have also defined a type WFF that stores a wff in the form of a
        tree structure. Study this definition in VSC, then enter this line at the julia prompt:
            wff = WFF("~",WFF("&",WFF("s271"),WFF("s465")))
        
        Now reply() me the value of the following expression:
            wff.arg1.arg1.head
        """,
        "Make sure you understand how this value relates to the definition of wff",
        x -> x == "s271"
    ),
    Activity(
        """
        Before starting on your own implementation, I want you to understand how important it is to
        use recursion when we are analysing structures. Enter `wff` at the julia prompt now, and
        notice what you see ...

        You should see the string: "~(s271 & s465)". Now, answer me this:
            Which method in the Syntax module specifies how to convert a WFF into a String like this?
        """,
        "Take a look in the file Syntax.jl in VSC",
        x -> x == show || occursin("show",x)
    ),
    Activity(
        """
        Take a look at the method Base.show() in Syntax. This method extends the show() method from
        the julia module Base, which is usually responsible for converting variables into a String.
        However, since Base knows nothing about our WFF type, we must extend show() to handle WFFs.

        Notice the structure of the method Syntax.Base.show(). Do you see how it uses an if-
        statement to choose how to handle wff? If wff were a variable or a constant, show() would
        simply print the corresponding string. However, if wff were a binary formula, show() would
        ask print() to link the individual arguments with the binary operator and place them
        between brackets. And if print() discovers that arg1 is a WFF, it simply goes back to show()
        to ask it how to print this new WFF as a string.

            YOU will also need to use recursive calls to handle nested structures like WFFs!

        Test the show() method now by replying me the following String result:
            string(WFF("->",WFF("->",WFF("p"),WFF("q")),WFF("->",WFF("~",WFF("q")),WFF("~",WFF("p")))))
        """,
        "Think carefully about how show() handles this WFF, and also consider the WFF's meaning",
        x -> x == "((p -> q) -> (~q -> ~p))"
    ),
    Activity(
        """
        OK, now it's your turn to write some code - and remember that you'll need to use recursion!
        
        In the file Syntax.jl, you will find a method Syntax.variables() which at present just
        contains dummy code. The aim of variables() is to returns the Set of all variable names
        that appear in a given WFF. When you have completed your implementation, entering
        `variables(wff)` at the julia prompt should return the result: Set(["s271","s465"]).

        When you are satisfied with your code, make sure it is included. Then enter reply(), and I
        will perform my own check of your code and let you know whether your code passed the test.
        """,
        "You will need to use recursion: variables(wff) calls itself on each argument of wff",
        x -> let MFF = Main.Syntax.WFF, wff = MFF("|",MFF("~",MFF("->",MFF("p1"),MFF("q2"))),MFF("F"))
            varset = Main.Syntax.variables(wff)
            println("Testing variables in WFF ", wff, " ... ", "Returned result: ", varset)
            varset == Set(["p1","q2"])
        end
    ),
    Activity(
        """
        Now implement the method Syntax.operators(), which returns the Set of all operators that
        appear in a WFF. By operators, I mean the following:
            "&", "|", "~", "->", "T", "F"
        
        When you have successfully completed the implementation, entering `operators(wff)` at the
        julia prompt should return the result: Set(["~","&"]). Then enter reply(), and I will
        perform my own test of your code and let you know how it went.
        """,
        "Again, you need recursion: operators(wff) calls itself on each argument of wff",
        x -> let MFF = Main.Syntax.WFF, wff = MFF("|",MFF("~",MFF("->",MFF("p"),MFF("~",MFF("q")))),MFF("F"))
            varset = Main.Syntax.operators(wff)
            println("Testing operators in WFF ", wff, " ... ", "Returned result: ", varset)
            varset == Set(["|","~","->","F"])
        end
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