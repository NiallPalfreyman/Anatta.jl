#========================================================================================#
#	Laboratory 0
#
# Introduction to setting up the julia environment.
#
# Author: Niall Palfreyman, 22/12/2021
# Modified: 19/04/2023, Niall Palfreyman
#========================================================================================#
[
    Activity(
        """
        Welcome to Anatta: Exploring a World based on Process, rather than Substance.

        Two key concepts are central to post-modern scientific philosopy: Change and Wholeness.
        -   On the one hand, the world is not as stable as we thought. It is not a bottomless
            rubbish-tip for carbon-dioxide, plastic and nuclear waste - rather, it changes in
            response to our actions.
        -   And on the other hand, these changes in the world arise from the fact that it is also
            a deeply connected Whole. Indeed, it is precisely these changing processes that bind
            our world into a complete, evolving Unity.

        Hi, my name is Ani! I will be your guide on this fascinating process-oriented journey. This
        is also the story of my own personal journey of discovery that the world is so different
        from, and so much MORE than, it seems on the surface.
        
        Whenever you want to take the next step on this journey from one learning activity (like
        this one) to the next, enter `reply()` at the julia prompt. Do this now:
        """,
        "We're still getting started - simply enter `reply()` at the julia prompt. :)",
        x -> true
    ),
    Activity(
        """
        "Anatta" means: "Has no substantial structure".
        
        Anatta is a philosophical position based on two interwoven ideas:
            i)  scientific knowledge is not Truth, but is rather something that living organisms
                construct in order to survive; and
            ii) living organisms are not substantial Structures, but biological Processes of longer
                or shorter duration.
            
        These two ideas completely change the way we understand the world. We can immediately see
        that together they mean we must find a new way of evaluating Knowledge. For we can no
        longer think of knowledge as being true or false. Instead, we must think of knowledge as
        being more or less useful to us, as we try to protect our biological processes against
        external danger from our environment.
        
        The Big Question that Anatta asks, is this:

            "How can an ever-changing world of processes produce so much stability that we start
                to believe that the world consists entirely of substantial structures?"
        """,
        "Again, enter reply() at the julia prompt to move on ...",
        x -> true
    ),
    Activity(
        """
        While exploring Anatta, we will investigate this question very deeply. To help us do so,
        I have divided our exploration into Subjects that build successively upon each other. Each
        Subject corresponds roughly to a 5-credit undergraduate-level lecture course:
            Subject 0: Computation            - Using structures to explore and predict the world
            Subject 1: Formal Logic           - Beliefs have structure, but structures ALWAYS have gaps!
            Subject 2: System dynamics        - Dynamical stories can fill logical gaps
            Subject 3: Simulation physics     - Using structures to approximate stories efficiently
            Subject 4: Quantum computing      - Small stories generate large structures
            Subject 5: Quantum thermodynamics - Small structures generate large stories
            Subject 6: Agent-based systems    - Knowledge is a property of populations, not individuals
            Subject 7: Relativity theory      - Organisms ENACT: they abstract knowledge through action
            Subject 8: Quantum-field theory   - Knowledge combines both large and small stories
        """,
        "reply() to move on :)",
        x -> true
    ),
    Activity(
        """
        I have divided each Anatta Subject into a series of Labs (learning laboratories), so for
        example, Subject 2 consists of a series of Labs named Lab200, Lab201, ...

        Each Lab is divided up into a sequence of learning Activities. For example, the text you
        are reading right now is Activity 4 of Lab 00 in Subject 0.

        In each Activity, if you enter the function reply(???), I will always interpret its
        argument (that is, the value ??? between the brackets) as your response to the current
        Activity. Try this now. Guess my lucky number by entering, for example, `reply(3)` at the
        julia prompt:
        """,
        "Enter reply(n) at the julia prompt, where n is a number between 1 and 9",
        x -> (x==5)
    ),
    Activity(
        """
        Anatta is not a simple statement that I can hand over to you: it is an Exploration. It will
        involve you in trying things out and learning through acting and making mistakes. This is
        how we learn naturally as children: we take our first step, fall down, dust ourselves off
        and take another step - but this time a little more skilfully.

        There is really no better way to learn than through making mistakes and receiving friendly,
        supportive feedback that helps you do it better next time. And believe me, computers are
        GREAT at respectful feedback: they never want to make anyone feel bad - they just say,
        "No, sorry - that didn't work!" or "Yup, that worked just fine!"
        
        So let's get started! At the julia prompt, enter the following code:
            concept = "Anatta"

        This line creates a variable named `concept`, in which is stored the value "Anatta". The
        double quotes mean that this value is a String of the characters "Anatta". You can view
        this value by entering `concept` at the julia prompt. Try this now, then enter this reply:
            reply(concept)
        """,
        "Another way of doing this is to enter: reply(\"Anatta\")",
        x -> (x=="Anatta")
    ),
    Activity(
        """
        This very first Lab 000 introduces you to working with Anatta by helping you to set up some
        convenient tools on your computer. First, be aware that the data on your computer is
        broadly divided into two areas: system data and user data. This division is a great idea,
        because you work with your user data every day, but the system data needs to stay very
        stable. Therefore, we will set up two different areas on your computer: a system area for
        you to configure the Anatta system, and a user area where you work on the Activities ...

        I have already set up a learner configuration file for you at this location:
            $(joinpath(session.anatta_config,session.learner*".lnr"))

        Use File Explorer to find and view this file now. What number is contained in the top line?
        """,
        "Enter `reply(n)`, where n is the number in the top line of your .lnr file",
        x -> x==0
    ),
    Activity(
        """
        As you probably realised, the first two lines in your learner configuration file contain
        the number of the Lab and of the learning Activity that you are currently working on. What
        about the third line? This appears to be the path of some folder on your computer, but
        what does it mean? We will now change this line of your learner configuration file. :)

        As you play with Anatta, you will write julia programs to create new ideas and solve
        problems. It is a good idea to save these solutions and ideas for later reference in a
        special "home" folder on your computer. In the following exercises, you will choose where
        you want that home folder to lie in your computer, and at the same time you will start to
        understand how julia helps us to move around the computer ...
        """,
        "Again, enter reply(). From now on, I'll stop irritating you with this hint :)",
        x -> true
    ),
    Activity(
        """
        julia offers us many ways to guide its console around the computer. For example, type
            pwd()
        
        at the julia prompt now. `pwd` stands for "Present Working Directory", and the pwd()
        function tells you exactly where you are right now within your computer's folder structure.
        For example, when I enter pwd() on my computer right now, I get this output:
            "C:\\\\Users\\\\Ani\\\\AppData\\\\Local\\\\Programs\\\\julia-1.8.4\\\\bin"

        This is julia's system binary area, and I DEFINITELY don't want to mess around with the data
        there! So now try entering the following Anatta command to move to your Anatta home folder:
            home()

        Now enter pwd() again to find out where you are now, and then reply() me the last few
        characters of your new location (after the last backslash) as a character string...
        """,
        "For you, it will probably be something like this: reply(\"Temp\")",
        x -> true
    ),
    Activity(
        """
        Well, at least we're no longer in the system area! In fact, since you haven't yet set up an
        Anatta home folder, the home() function has probably sent you to the system's Temp area.
        But we also don't want to store our wonderful discoveries there, so we'll want to navigate
        through our folder structure and create a new Anatta home folder in a place of OUR choosing.
        
        The functions for moving through the folders are cd() ("Change Directory") and readdir():
            cd()                = Change to my own user area (e.g.: "C:\\Users\\Ani")
            cd("..")            = Change UP to the parent folder of my current folder
            cd("docs")          = Change DOWN to the subfolder "docs" of my current folder
            cd("C:/Users/Ani")  = Change ACROSS to this absolute folder location
            readdir()           = Give me a list of files and subfolders within my current folder

        Use these functions now to step slowly through the folder structure until you arrive in
        the parent folder of where you want to create your Anatta home folder. When you get there,
        reply() me to let me know. If you need to see the above commands again, enter `askme()`.
        """,
        "Remember: entering `askme()` will show you the text for this Activity again",
        x -> true
    ),
    Activity(
        """
        Well, that was probably a lot of hard work, wasn't it? The good news is that you won't need
        to do it again, because we will save this location. Enter pwd() once more, to check which
        folder you are in right now, and then answer the question:

        Do you want to create your Anatta home folder inside this present working directory?
        """,
        "Enter reply(\"yes\"), or navigate first to a different folder",
        x -> occursin("yes",lowercase(x))
    ),
    Activity(
        """
        OK, so we'll create the home folder in your present working directory (PWD). Do this by
        entering:
            mkdir("Anatta")

        Then use `isdir("Anatta")` to check that julia has created the new folder.
        """,
        "Use reply() to continue",
        x -> true
    ),
    Activity(
        """
        Now step into the new home folder:
            cd("Anatta")

        and finally (remembering the exclamation mark!), enter:
            home!()

        to tell Anatta that this will be your home folder from now on.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, now you can breathe freely again: your home folder is saved! From now on, wherever you
        are, you can always return here by entering `home()`.

        Notice the difference between bang! functions (like home!()) that change something for
        ever, and normal functions (like home()) that have no side-effects. Distinguishing between
        the two with an exclamation mark is a common courtesy in julia to help others understand
        your code.

        As practice in what we have been doing, I suggest that you now use julia to navigate in as
        few steps as possible to your learner configuration file:
            $(joinpath(session.anatta_config,session.learner*".lnr"))

        reply() me when you get there...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now use the following command to display the text in your learner configuration file, and
        check that the third line of the configuration file really has recorded your correct home
        location:
            readlines(open("$(session.learner*".lnr")"))

        Finally, use `home()` to return to your new Anatta home, an then reply() me that we can
        continue.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Right, so that was fun, wasn't it? :)

        Let me be explicit at this point: I've been assuming since you and I are sitting here
        chatting, that you have already installed the julia language. In fact, yes, I can see the
        julia executable file right here:
            $(Sys.BINDIR)

        I also assume that you have used the julia Package Manager to install Anatta and me:
            I chat with you, therefore I AM! :)
        
        However, there is another thing we need: we will use Visual Studio Code as our friendly
        programming environment. I do NOT assume you have installed VSC, so we must do that now.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        First, go now to the following website, then download and install the appropriate version
        of VS Code for the operating system (Windows, Unix, ...) that you are using:
            https://code.visualstudio.com/

        When you have finished installing, I'll be waiting here for your reply() ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now that you have installed VSC, the next step is to make sure it knows about julia. inside
        VSC, select View, and then click on Extensions so that the Extensions View opens down the
        left-hand side of the VSC screen. Type the string "julia" (WITHOUT quotes) in the searchbox
        at the top.

        In the list of extensions that appears, you will see an entry for "Julia Language Support".
        If you click on this, a VSC pane opens that describes the julia extension. Click on the
        "Install" button, then close the "Extension: julia" pane as soon as the installation is
        finished (it only lasts a few seconds).

        It's now a good idea to close and restart VSC. Do this, then reply() me when you're ready.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        I take it you have now restarted VSC. If the Explorer pane on the left-hand side of VSC
        is not yet open, open it now by selecting: View / Open View... / Explorer.
        
        Next, make sure the Explorer pane is displaying your new Anatta home folder. To do this,
        select File / Open Folder... and use the dialog box to navitate to your home folder.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        OK, we're ready to create our first julia program. Right-click on the Explorer pane
        and select New File...

        A small box will open in Explorer where you can now type "Ani.jl", but before pressing
        Enter, notice what happens as you type the final 'l' in the filename. At this instant, VSC
        should recognise that you want to create a julia file, and you will see the triangle of
        three julia-dots appear to the left of the filename. This is your first comforting sign
        that VSC is successfully talking to julia, but don't worry if you don't yet see it - we
        will fix that shortly. :)

        Now press Enter, and VSC will open the file "Ani.jl" for editing.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        So now let's turn to the issue of those three julia dots. If they don't appear, that means
        we still need to tell VSC where julia is. In fact, even if you CAN see them, it's a good
        idea to make absolutely sure the connection between the two is solid, so now we will inform
        VSC about the precise location of your julia executable file.
        
        julia stores the name of the folder containing this file in the system variable
        `Sys.BINDIR`. reply() me now the value, or contents, of that variable:
        """,
        "Just enter at the julia prompt: Sys.BINDIR",
        x -> x==Sys.BINDIR
    ),
    Activity(
        """
        This type of value is called a String - that is, a sequence of characters contained between
        double quotes (") that are intended to communicate some kind of information. Strings use
        the backslash character '\\' to signify special characters such as the Alarm character '\\a';
        test this now by printing the Alarm character from the julia prompt:
            print("\\a")

        (Make sure your speakers are switched on!) If you really like the sound, you can irritate
        friends by repeating it several times: Just press up-arrow and enter the command again.

        However, the difficulty is this: If Strings always think the backslash indicates a special
        character, what do we type in a String if we simply want to signify the backslash character
        itself?! Maybe you can guess by looking at the Sys.BINDIR value. reply() me your answer as
        a string containing a backslash character:
        """,
        "",
        x -> occursin("\\",x)
    ),
    Activity(
        """
        I should perhaps mention that if you are working in Unix or on a Mac, you won't have this
        double-backslash problem - if so, adapt these instructions to what you see on screen ...

        We want to convert the Sys.BINDIR String variable into information for VSC, so we will
        delete one backslash in each pair. Also, we want to specify not just the location, but also
        the name of the executable file. So, please do the following:
            -   Display the contents of Sys.BINDIR at the julia prompt
            -   Select and copy the characters between the String quotes
            -   In VSC, select File / Preferences / Settings
            -   Search for the settings variable "julia executable path"
            -   Paste the contents of Sys.BINDIR into the edit window for this variable (you will
                get a message saying the julia language server couldn't start, but don't panic!)
            -   Go through the edit window, deleting one backslash in each pair
            -   Add "\\julia.exe" at the end of the edit window contents ("\\julia" on a Mac)
            -   Close the settings tab.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        You should now notice several things that have changed:
            -   The julia icon of three dots should appear to the left of Ani.jl in Explorer
            -   A message at the left-bottom of the VSC editor says the julia server is running
            -   At the right of the ribbon above the VSC editor pane is a Play button (i.e.,
                a right-pointing triangle). We shall be using that soon.

        If you do not see these things, then something is stuck, and I can't help you further right
        now, but if you tell me, I promise to work on the problem in the future. In the meantime,
        try looking online for help - the julia community is very friendly and helpful! :)
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Now I'm assuming that you can see the triangular Run button at the top right of VSC, which
        means you can compile and run julia programs from within VSC. Let's do that right now ...

        Type the following two lines in the open file Ani.jl:
            greeting = "Hi - I'm Ani. It's a pleasure to meet you! :)"
            print(greeting)

        Next, save these changes by pressing Ctrl-S (the circle next to the file name will change
        to an x). Then press the Run button, sit back and watch.

        When you've seen your program run, reply() me.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Before we close this lab, let's notice what just happened ...
            1.  You have successfully written and run your first program - well done! :)
            2.  In scientific research, we formulate a Null Hypothesis, then contradict it experimentally.
            3.  Our null hypothesis was the worry that VSC and julia were not communicating.
            4.  Our successful program run disproves that worry: We now know they ARE communicating.
            5.  Keep these ideas in mind during the entire Anatta course: We use Theory to
                construct a null hypothesis (a 'worry'), then use Practice to contradict it.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Take a break now - it's been a long lab. Close julia down, and when you return, I will
        still be here. I know your name, your current lab and your current activity (remember I
        stored them in your configuration file), and we can continue where we left off. Whenever
        you want to start a new Anatta session, simply follow these steps:
            -   Start julia
            -   julia> using Anatta
            -   julia> Anatta.go()
            -   Enter your name (case sensitive!)
            -   julia> home()
            -   Follow my suggested activities ... and have fun! :)
        """,
        "",
        x -> true
    ),
]