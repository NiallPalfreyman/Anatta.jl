#========================================================================================#
#	Laboratory 100
#
# Welcome to Subject 100: Formal Logic
# This Subject draws heavily upon the ideas in the following book:
#   Gonczarowski, Y.A. & Nisan, N. (2022). Mathematical logic through Python. CUP.
#
# Author: Niall Palfreyman, 8/11/2024.
#========================================================================================#
begin
include("../src/dev/Logic/Propositions.jl")
const parse_tests = [
    ("~p211","~p211",""),
    ("((a02|a5)->~a11)","((a02 | a5) -> ~a11)",""),
    ("((b|b5))", nothing, ""),
    ("c&","c","&"),
    ("~~~d~","~~~d","~")
]
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 100:
            Formal Logic - Beliefs have structure, and structures ALWAYS have gaps!
        
        Before continuing, I want to stop and think for a moment about what we have so far achieved
        in Anatta. In Subject 000, we learned to use the Julia computer language to solve many
        different kinds of problems, yet we also found that there are some problems that we cannot
        solve with a computer - for example, predicting the outcome of a chaotic process. So it
        seems that computational structures may not be powerful enough to describe all the dynamical
        possibilities that we biological organisms must cope with. Is this a problem?
        
        In Subject 100, we study an important tension that faces all organisms: In order to survive
        and to communicate with each other, we divide our experience into convenient structures
        such as tables, chairs and tigers, yet we can never be quite sure whether these structures
        accurately describe the survival-relevant processes that we might have to face tomorrow.

        To do this, we shall define very precisely the language of mathematical Logic. We shall
        define its structural sentences and the meaning of those sentences, and then analyse these
        to discover whether there is an essential gap between sentence and meaning ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Ferdinand de Saussure (1857-1913) suggested the idea that languages consist of signs
        that possess two parts: a Signifier (a linguistic structure such as a word), and a
        Signified (the meaning of that word). This idea developed during the twentieth century 
        into the subject of Formal Linguistics, which divides the study of languages into two
        separate areas:
            - Syntax is the study of the formal structure of what we believe;
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

        To achieve this, we will use julia Strings to denote propositional sentences, and then we
        will program a way to analyse these sentences into well-formed propositional formulas. In
        the next activity, I'll show you a set of grammar rules that define the structure of a
        Well-Formed Formula (WFF) ...
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
            binary_wff  : "("*wff * " & " * wff*")"; "("*wff * " | " *wff*")"; "("*wff * " -> " * wff*")".
            letter      : "a"; "b"; "c"; ...; "x"; "y"; "z".
            number      : digit; digit * number.
            digit       : "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9".

        reply() me a String containing a valid constant.
        """,
        "Enter reply(string), where string obeys the above rules for a constant (no spaces!)",
        x -> Propositions.isconstant(x)
    ),
    Activity(
        """
        Now reply() me a String containing the name of a valid variable.
        """,
        "Enter reply(string), where string obeys the above rules for a variable",
        x -> Propositions.isvariable(x)
    ),
    Activity(
        """
        The single available unary operator means NOT, so
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
        x -> Propositions.isbinary(x)
    ),
    Activity(
        """
        Over the last four activities, I have been checking your replies using the following
        methods implemented in the module Propositions:
            isconstant(), isvariable(), isunary() and isbinary()

        Soon, I will ask you to implement some extra methods in the Propositions module, so please
        now setup() the Logic library in your Anatta home folder, open the file Propositions.jl in
        VSC and study the above four methods.

        What is the name of the method I use to check whether a variable name ends in a number?
        """,
        "Remember that a variable consists of a letter concatenated with a number",
        x -> x==Main.tryparse || occursin("tryparse",x)
    ),
    Activity(
        """
        To prepare for the implementation activities, make sure your julia console is located
        within your Anatta home folder, then include and load the Propositions module:
            include("Development/Logic/Propositions.jl")
            using .Propositions
        """,
        "Follow all THREE instructions (home, include, using), then reply()",
        x -> isfile("Development/Logic/Propositions.jl") && Main.Propositions.WFF isa Type
    ),
    Activity(
        """
        In the Propositions module, I have also defined a type WFF that stores well-formed formulae
        in a tree structure. Study that definition in VSC, then enter the following line at the
        julia prompt, which creates the WFF with string representation "~(s271 & s465)":
            wff = WFF("~",WFF("&",WFF("s271"),WFF("s465")))
        
        Now first guess, and then reply() me the value of the following expression:
            wff.arg1.arg1.head
        """,
        "Make sure you understand how this value relates to the definition of wff",
        x -> x == "s271"
    ),
    Activity(
        """
        Before starting on your own implementation, I want you to understand how Very Important it
        will be for us to use Recursion when we are analysing structures. Enter `wff` at the julia
        prompt now, and notice that the representation you see is formatted prettily as a string ...

        You should see the string: "~(s271 & s465)". Now, answer me this:
            Which method in the Propositions module specifies how to convert a WFF into a String?
        """,
        "Take a look in the file Propositions.jl in VSC",
        x -> x == Base.show || occursin("show",x)
    ),
    Activity(
        """
        Take a look at the method Base.show() in Propositions. This method extends the show()
        method from the julia module Base, which is usually responsible for converting variables
        into a String. However, since Base knows nothing about our WFF type, we must extend show()
        to handle WFFs.

        Notice the structure of the method Propositions.Base.show(). Do you see how it uses an if-
        statement to choose how to handle wff? If wff were a variable or a constant, show() would
        simply print the corresponding string. However, if wff were a binary formula, show() would
        ask print() to link the individual arguments with the binary operator and place them
        between brackets. And if print() discovers that arg1 is a WFF, it simply goes back to show()
        to ask it how to print this new WFF as a string.

            YOU will also need to use recursion to handle nested WFF structures in your code!

        Test the show() method now by replying me the following String result:
            string(WFF("->",WFF("->",WFF("p"),WFF("q")),WFF("->",WFF("~",WFF("q")),WFF("~",WFF("p")))))
        """,
        "Think carefully about how show() handles this WFF, and also consider the WFF's meaning",
        x -> x == "((p -> q) -> (~q -> ~p))"
    ),
    Activity(
        """
        All of your coding exercises in these julia modules are marked with the following comment:
            # Learning activity:
            Stub code ...

        "Stub code" is placeholder code that I have written to satisfy four conditions:
        -   You can call the (unimplemented) method without raising any internal errors;
        -   It does NOT implement the method's execution requirements: that's your job! :)
        -   It gives you some implementation hints - like the control structure in the first activity;
        -   When you call the module's demo() method, the screen output is still informative.
        
        reply() me now the method that contains the very first Learning activity in the file
        Propositions.jl:
        """,
        "",
        x -> x==Main.variables
    ),
    Activity(
        """
        OK, so now it's your turn to write some code - and remember that you'll need to use recursion!
        
        In the file Propositions.jl is the method Propositions.variables() which at present just
        contains stub code. The aim of variables() is to return the Set of all variable names that
        appear in a given WFF. Using our previous definition of wff:
            wff = WFF("~",WFF("&",WFF("s271"),WFF("s465"))),

        entering `variables(wff)` at the julia prompt should return: Set(["s271","s465"]). Write
        your own implementation of `variables`, and when you are satisfied with your code, include
        Propositions.jl, enter reply(), then I will perform my own check of your code to let you
        know whether it passes my tests.
        """,
        "You will need to use recursion: variables(wff) calls itself on each argument of wff",
        x -> let MFF = Main.Propositions.WFF
            wff = MFF("|",MFF("~",MFF("->",MFF("p1"),MFF("q2"))),MFF("F"))
            varset = Main.Propositions.variables(wff)
            println("Testing variables in WFF ", wff, " ... ", "Returned result: ", varset)
            varset == Set(["p1","q2"])
        end
    ),
    Activity(
        """
        Now implement the method Propositions.operators(), which returns the Set of all operators that
        appear in a WFF. By operators, I mean the following:
            "&", "|", "~", "->", "T", "F"
        
        When you have successfully completed the implementation, entering `operators(wff)` at the
        julia prompt should return the result: Set(["~","&"]). Then enter reply(), and I will
        perform my own test of your code and let you know how it went.
        """,
        "Again, you need recursion: operators(wff) calls itself on each argument of wff",
        x -> let MFF = Main.Propositions.WFF,
            wff = MFF("|",MFF("~",MFF("->",MFF("p"),MFF("~",MFF("q")))),MFF("F"))
            opset = Main.Propositions.operators(wff)
            println("Testing operators in WFF ", wff, " ... ", "Returned result: ", opset)
            opset == Set(["|","~","->","F"])
        end
    ),
    Activity(
        """
        Great! We know how to use recursion to analyse the structure of a WFF: Give yourself a good
        pat on the back! :)
        
        Our next task is to work out how to build a WFF from a String - this is called Parsing the
        the String's structure. Parsing is extremely important in all formal languages, and
        particularly in string-manipulation languages such as julia. Reply me the method that
        julia uses to parse a string containing julia code:
        """,
        "Rather than giving me the name of the method, give me the method itself",
        x -> x == Meta.parse
    ),
    Activity(
        """
        Our language for propositional logic is deliberately very simple. Sentence strings in this
        language contain characters, and these characters form meaningful Tokens of the language,
        such as "&", "q123" or "->". A very important feature of our language is that it is
        Context-Free - that is, the meaning of each term of a sentence is attached ONLY to that
        term, and never depends on the surrounding sentence context in which that term appears.

        For example, take a look at this part of our propositional logic grammar:
            wff         : variable; constant; unary_expr; binary_expr.
            unary_wff   : "~" * wff.
            binary_wff  : "("*wff * "&" * wff*")"; "("*wff * "|" *wff*")"; "("*wff * "->" * wff*")".

        Notice that a binary_wff has the structure of two wff terms combined by a binary operator,
        enclosed between brackets. The structures of these two terms are completely independent of
        each other, so we can parse the first term without needing to think about the second term.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        So our Propositional Logic language is entirely context-free, and this is very useful for
        parsing sentence structures. To Parse a string means that we analyse the wff structure that
        it describes, and simultaneously build that structure as a wff. The fact that our language
        is context-free means that we can ALWAYS parse strings by moving strictly from left to
        right. This is called "LL parsing": we both read the string and build its wff by starting
        from its Left end, then moving steadily rightwards along the string.

        For example, take a look now at the code for the learning activity method parse_binary().
        You will see that the code first asks whether the string contains a leading '('. If that is
        the case, the grammar rules tell us that the open bracket MUST be followed by a WFF,
        followed by a binary operator ("&", "|", "->"), another WFF, and a closing bracket ')'. If
        the string does not have precisely this structure, it does not represent a valid WFF.

        What single character at the Left end of a string tells us that it describes a unary_wff?
        """,
        "",
        x -> occursin('~',x)
    ),
    Activity(
        """
        If you study the code in Propositions.jl, you will see that I have implemented all of the
        methods for parsing propositions apart from parse_binary(). Study all the methods that
        I have implemented, to get a feel for how they work together to parse a string into a wff.
        When you understand how parsing works, your next task is to use my parsing methods as
        models to help you write your own implmentation of the method parse_binary().

        Your parse_binary() implementation should do the following:
        -   It accepts a single string as argument, and returns a Tuple containing two items;
        =   It attempts to parse the string as a binary expression (either (wff1 & wff2),
            (wff1 | wff2) or (wff1 -> wff2) ) at the string's Left end. If this parsing is
            successful, the return Tuple looks like this: (wff::WFF,tail::String), where wff is the
            parsed WFF and tail is the remainder string to the right of the parsed wff.
        -   If parse_binary() cannot parse the string as a binary expression, it returns a Tuple
            (nothing,"error msg"), whose first element is `nothing`, and whose second element is an
            error string which helps users to understand what went wrong.
        
        Implement parse_binary() now, then load your new Propositions module and reply() me. I will
        then perform my own tests on your code:
        """,
        "A binary_wff looks like this: (p5 & wff). Use parse_wff() to parse the terms p5 and wff.",
        x -> begin 
            for (s,w,r) in parse_tests
                ww, rr = Main.Propositions.parse_wff(s)
                print("Testing your parsing of ", s, " ... ")
                if (string(ww)!==string(w)) || (ww!==nothing && r!=rr)
                    println( "Returned result ", (ww,rr), " instead of: ", (w,r))
                    return false
                end
                println()
            end
            println( "All tests passed with flying colours! :)")
            true
        end
    ),
    Activity(
        """
        Congratulations!! You have just successfully implemented an LL-parser for the entire
        language (PL) of Propositional Logic. Well done!!

        Before finishing this lab, take a moment to think a little about what your work proves ...
        Our language PL for describing WFFs has the useful property that we can always recognise a
        complete WFF by reading its PL description from left to right. This means that the trailing
        tail-string at the end of a well-formed PL sentence is ALWAYS empty. For if it weren't, the
        constructed WFF would be incomplete. Your work therefore proves the following important
        theorem about WFFs:
            As soon as we have recognised a WFF, it can NEVER be the first term in a longer WFF!

        Use this theorem together with the method parse_wff() to implement the two methods iswff()
        and parse(). Their specifications and skeleton code are contained in Propositions.jl.
        """,
        "Again, just implement the two methods, then reply() me, and I will check your code.",
        x -> begin
            for (s,w,r) in parse_tests
                err = isnothing(w)
                has_tail = !isempty(r)
                is_wff = !err && !has_tail
                print("Testing your iswff( \"$s\") ... ")
                if Main.Propositions.iswff(s) != is_wff
                    println( "Returned result ", !is_wff, " instead of: ", is_wff)
                    return false
                end
                println()
                if is_wff
                    print("Testing your parse( WFF, \"$s\") ... ")
                    ww = Main.Propositions.parse(Main.Propositions.WFF,s)
                    if string(ww) != w
                        println( "Returned result ", ww, " instead of: ", w)
                        return false
                    end
                    println()
                end
            end
            true
        end
    ),
]
end