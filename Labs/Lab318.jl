#========================================================================================#
#	Laboratory 318: The Stabilisation Project
#
# Author: Niall Palfreyman, 21/04/2026.
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Lab 318: How does Stabilisation implement adaptation?

        Now we will start our final, assessed, project for this course. You will investigate how
        Stabilisation implements adaptation in living systems. You have three main resources for
        this project:
            -   The paper "Constructing lived cognition" in the script Palfreyman2026.pdf;
            -   The module WattWorlds used as a demonstration by Palfreyman (2026);
            -   All sample programs that you have so far worked through in this course.

        Please note that this is a complex project. It requires you to read and understand the long
        and complex paper Palfreyman (2026), then understand and adapt the module WattWorlds in
        the Julia file WattWorlds.jl. You should start studying these as soon as possible.
        """
    ),
    Activity(
        """
        A guide to reading the paper:
            0.  Print out the paper and make sure you keep a pencil handy to underline anything
                you do not understand;
            1.  Read the Structured Abstract at the beginning of the paper;
            2.  Read the one-page Introduction;
            3.  Read the Conclusions at the end of the paper;
            4.  Notice how the section headings follow the bullet list in paragraph 4;
            5.  Return to the beginning and read the entire paper, underlining and then looking
                up anything you do not understand;
            6.  Run and understand the method WattWorlds.demo();
            7.  Ask your teacher about Everything you do not yet understand.
        """,
    ),
    Activity(
        """
        In this paper, Palfreyman argues that stabilisation implements adaptation. However, in the
        accompanying WattWorlds program, he does this in a very primitive way:
            -   The variational structure of his agents consists of a "genome" containing only the
                single locus B.K, which encodes the Hill half-response constant of one half of a
                Watt governor;
            -   His world has no spatial structure: agents cannot move and all have equal access
                to a single, globally available resource value R;
            -   His environment has no dynamic of its own such as diffusion or chemical reaction,
                making it impossible for agents to construct a niche within which they can
                stabilise their structural variation locally;
            -   His agents have no life-cycle in the sense of using genetically encoded exploratory
                processes to manipulate their environment.

        I'm sure that you can do better than this! :)
        """,
    ),
    Activity(
        """
        The aim of your project work is to write your own program and paper to demonstrate how
        stabilisation implements at least one of the following important functions of living
        systems:
            -   adaptation
            -   learning
            -   abstraction
            -   generalisation
            -   modularity (localised bubbles of stabilisation)
            -   avoiding getting trapped in suboptima
            
        Make reeeally sure you understand All of these terms, because your understanding of them
        will play an important part in the quality of paper and experimental results. Discuss them
        with your teacher if you are at all unsure what any of them means.
        """,
    ),
    Activity(
        """
        Keep the goals of your experimental system very simple! For example, you might decide to use
        stabilisation to learn a particular class of Turing patterns. Remember that if you wish to
        optimise some objective function, you will need to reformulate this optimisation problem as
        a stabilisation problem!

        You Must discuss your project ideas with your teacher before you start work on it!
        """,
    ),
    Activity(
        """
        The deliverables of your project are a paper in English and containing no more than 2000
        words, and a supporting program that demonstrates the argument in your paper. In all other
        respects, your paper should conform to the authors' guidelines for submission to the journal
        Constructivist Foundations.

        Regarding your program: it should be a single Julia module containing one or more
        interacting types that can be run in the Anatta Lab environment. You should include a demo()
        function that runs the program and demonstrates the argument in your paper. Keep the code as
        simple and clear as possible, using all of the programming techniques that you have learned
        in this and previous Subjects.

        Good luck! :)
        """,
    ),
]