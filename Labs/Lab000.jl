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
        Welcome to Anatta: A programmer's guide to understanding the world in terms of processes.

        Two key concepts lie at the heart of post-modern scientific philosopy: Change and
        Wholeness. On the one hand, the world is not as stable as we thought: the world is not a
        bottomless rubbish-tip for carbon-dioxide, plastic and nuclear waste, but changes in
        response to our actions. And on the other hand, this relates to the fact that the world is
        also a deeply connected Whole. Indeed, it is precisely these changing processes of our
        world that bind it into a complete, evolving Unity.

        Hi! My name is Ani! I will be your guide on this fascinating process-oriented journey. This
        is also the story of my own personal journey of discovery that the world is so much
        different and so much MORE than it seems on the surface.
        
        As we follow this journey, whenever you want to move on from one learning activity (like this
        one) to the next, enter `reply()` at the julia prompt. Do this now:
        """,
        "We're still getting started - simply enter `reply()` at the julia prompt. :)",
        x -> true
    ),
    Activity(
        """
        At the heart of post-modern science is the idea that scientific knowledge is not Truth, but
        rather something that is known (or at least believed) by living organisms. And in turn, we
        organisms are not objects, but biological processes of longer or shorter duration. To
        understand how deeply these ideas changes the way we view the world, we will dive into a
        whole series of fascinating subjects that build upon each other. I have divided Anatta into
        Subjects that each correspond roughly to a 5-credit undergraduate-level lecture course:
            -   Subject 0: Programming: How to pose, analyse and solve problems
            -   Subject 1: Mathematics: How to describe the structure of the world
            -   Subject 2: Dynamical systems: How to explain the dynamics of the world
            -   Subject 3: Quantum computing: How micro-dynamics generates macro-structure
            -   Subject 4: Thermodynamics: How micro-structure generates macro-dynamics
            -   Subject 5: Agent-based systems: How populations construct knowledge
            -   Subject 6: Relativity theory: How organisms abstract knowledge from experience
            -   Subject 7: Quantum-field theory: How to balance the big and the small pictures
        """,
        "Again, enter reply() at the julia prompt to move on ...",
        x -> true
    ),
    Activity(
        """
        Each Anatta Subject is divided into a series of Labs (learning laboratories), so for
        example, Subject 2 consists of a series of Labs named Lab200, Lab201, ...

        Each Lab is divided up into a sequence of learning Activities. The text you are reading
        right now is Activity 3 of Lab 00 in Subject 0.

        In each Activity, if you enter the function reply(???), I will always interpret its
        argument (that is, the value ??? between the brackets) as your response to the current
        Activity. Try this now - at the julia prompt, enter the following code:
            concept = "Anatta"

        Then enter your reply as:
            reply(concept)
        """,
        "Again, enter reply() ...",
        x -> (x=="Anatta")
    ),
    Activity(
        """
        This very first lab 000 aims to introduce you to working with Anatta before we start
        working through the programming Subject. First, be aware that the data on your computer is
        broadly divided into two areas: system data and user data. This division is a good idea,
        because you work with your user data every day, but the system data needs to stay quite
        stable. Therefore, we will set up two different areas on your computer: a system area for
        you to configure the Anatta system, and a user area for you to do the Activities ...

        I have already set up a learner configuration file for you at this location:
            $(joinpath(session.anatta_config,session.learner*".lnr"))

        I suggest you find and view this file now. Which number is contained in the top line?
        """,
        "Now it's time for you to start answering questions. Enter `reply(number)`",
        x -> x==0
    ),
    Activity(
        """
        As you probably realised, the first two lines in your learner configuration file contain
        the number of the Lab and of the learning Activity that you are currently working on. What
        about the third line? This appears to be the path of some folder on your computer ...

        As you play with Anatta, you will write julia programs to create new ideas and solve
        problems. You will want to save these solutions and ideas for later reference in a special
        "home" folder on your computer. We will now choose that home folder and at the same time
        get to know how julia helps us move around the computer ...
        """,
        "Again, enter reply(). From now on, I'll stop irritating you with this hint :)",
        x -> true
    ),
    Activity(
        """
        julia offers us many ways to guide its console around the computer. For example, type
            pwd()
        
        at the julia prompt now. The pwd() function tells you where exactly you are at the moment
        within the computer's folder structure. When I enter pwd() on my computer, I get:
            "C:\\\\Users\\\\Ani\\\\AppData\\\\Local\\\\Programs\\\\julia-1.8.4\\\\bin"

        This is julia's system binary area, and I DEFINITELY don't want to mess around with the
        data there! So now try entering the following Anatta command:
            home()

        Now enter pwd() and then give me the last 5-6 characters of your new location as a
        character string...
        """,
        "For you, it will probably be something like this: reply(\"\\Temp\")",
        x -> true
    ),
    Activity(
        """
        Well, at least we're no longer mucking around in the system area. In fact, since you
        haven't yet set up an Anatta home area, the home() function has probably landed you like me
        in the scratch-space, or Temp area. But we also don't want to store all our wonderful
        discoveries there, so we need to navigate through our folder structure and create a new
        dedicated Anatta home folder in a place of our own choosing.
        
        The important functions for doing this are cd() (or: "change directory") and readdir():
            cd()            = Go to my user area (e.g.: "C:\\Users\\Ani")
            cd("..")        = Go up to the parent folder of my current folder
            cd("C:/Users/Ani/AppData/Local/Temp")
                            = Go across to this absolute folder location
            cd("docs")      = Go down to the subfolder "docs" of my current folder
            readdir()       = Give me a list of files and subfolders of my current folder

        Use these functions now to step slowly through the folder structure until you arrive in
        the parent folder of where you want to create your Anatta home folder. When you get there,
        reply() me to let me know. If you need to see the above commands again, enter `askme()`.
        """,
        "Remember: entering `askme()` shows you the Activity again",
        x -> true
    ),
    Activity(
        """
        Well, that was probably a lot of hard work, wasn't it? The good news is that you won't need
        to do it again, because we will save this location. At present, you are located here:
            $(Main.pwd())

        Do you want to create your Anatta home folder inside this one?
        """,
        """
        Ignore my rather puzzling answer (I'm only a machine, after all! ;-), and navigate on to
        the folder within which you'd like to create your Anatta home folder. Then reply("yes")
        """,
        x -> occursin("yes",lowercase(x))
    ),
    Activity(
        """
        OK, so we'll create the home folder here:
            $(Main.pwd())
        
        Do this by entering:
            mkdir("Anatta")

        Then use `readdir()` to check that julia has created the new folder.
        """,
        "Use reply() to continue",
        x -> true
    ),
    Activity(
        """
        Now step into the new home folder:
            cd("Anatta")

        and finally, enter
            home!()

        to tell Anatta that this is to be your home folder from now on.
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

        As practice in what we have been doing, I suggest that you now use julia to navigate to
        your learner configuration file:
            $(joinpath(session.anatta_config,session.learner*".lnr"))

        Then use `edit("$(session.learner*".lnr")")` to check that the third line of the configuration file
        really has recorded your correct home location. Finally, use `home()` to return to your new
        Anatta home and then reply() me that we can continue.
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
        Now that you have installed VSC, the next step is to make sure it knows about julia. Select
        View, and then click on Extensions so that the Extensions View opens down the left-hand
        of the VSC screen. Type the string "julia" (WITHOUT quotes) in the searchbox at the top.

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
        This value is called a String - that is, a sequence of characters contained between double
        quotes (") that are intended to communicate some kind of information. Strings use the
        backslash character '\' to signify special characters such as the Alarm character '\a';
        test this now by printing the Alarm character from the julia prompt:
            print("\a")

        (Make sure your speakers are switched on!) If you really like the sound, you can irritate
        friends by repeating it several times: Just press up-arrow and enter the command again.

        However, the difficulty is this: If Strings always think the backslash indicates a special
        character, what do we type in a String if we simply want to signify the backslash character
        itself?! Maybe you can guess by looking at the BINDIR variable. reply() me your answer as
        a string containing a backslash character:
        """,
        "",
        x -> occursin("\\",x)
    ),
    Activity(
        """
        I should perhaps mention that if you are working in Unix, you won't have this double-
        backslash problem - if so, adapt the following instructions to what you see on screen ...

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
            -   Add "\\julia.exe" at the end of the edit window contents
            -   Close the settings tab.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        You should now notice several things that have changed:
            -   The three dots should appear to the left of Ani.jl in Explorer
            -   A message at the left-bottom of the VSC editor says the julia server is running
            -   At the right of the tab line above the VSC editor pane is a Play button (i.e.,
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
                construct a null hypothesis, then use Practice to contradict it.
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