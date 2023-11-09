# Anatta Package Documentation

## Purpose of the Anatta package

The term **Anatta** means: "*Has no substantial structure*" - like the candle-flame shown in our
logo. Its form seems so stable and substantial, yet this form is constantly being reconstructed
through the ongoing processes of burning and convection.

The Anatta package is a constructivist exploration, using the julia programming language, of
the implications of the concept of Anatta for scientific understanding in the twenty-first century.
Through exploring how our experience of the world is based entirely on processes, rather than on
substantial structure, we will learn how to ...

- **describe**, explain and test our ideas in the programming language julia;
- **design** and implement scientific software;
- **model** the structures that help us to interpret experimental results;
- **recognise** the explanatory gaps that necessarily exist in these intepretive structures;
- **simulate** the stories that organise our *choice* of structures to fill these gaps;
- **construct** new stories using the principles of relativity, quantum theory and thermodynamics.

## Working with Anatta

Anatta is divided into a number of *subjects* that build successively upon each other,
each subject corresponding roughly to a 5-credit undergraduate-level lecture course.
Anatta subjects are in turn divided into *labs* (learning laboratories) consisting
of 20-30 learning *Activities* in which which you will learn by trying things out in the julia
console, making mistakes and correcting them.

I have specifically written the Anatta package so that you can study and learn from its own code.
For example, if you investigate the julia code of the lab files, you will discover that they
contain a julia Vector of Activities. In turn, each Activity is a concrete julia type consisting of
three entries: an exercise text, a hint text, and a Boolean success function to test the
correctness of your reply to the Activity. Feel free to copy and reuse the Anatta code as much as
you like.

Anatta is a work in progress that I fully expect to take years to complete. Many labs are currently
either in incomplete stub form or simply missing. In fact, at present, the *only* Anatta subject
in a satisfactory state of readiness is subject 0: *Using computation to explore and predict the
world*. I will add the remaining subjects as time goes by, but for the moment, I
recommend that you regard Anatta simply as an introduction to programming in julia.

## Installing Anatta

The only prerequisite for installing Anatta is that you have already installed julia on your
computer, can open a julia console (also called the REPL: Read-Evaluate-Print-Loop), and can
successfully get back the answer `5` from entering `3+2` at the julia prompt.

To install Anatta, go to the julia prompt and press the "Close square bracket" key `]`. This puts
you into the julia Package Manager mode, where the new prompt looks something like this:

`(@v1.9) pkg>`

At the Package Manager prompt, enter this command:

`(@v1.9) pkg> add Anatta`

This will download all packages necessary for using Anatta, and may take a long time (say,
10 minutes), so go and have a cup of tea or coffee while you wait ...

When the console returns to the Package Manager prompt, press the `<Backspace>` key to exit the
Package Manager and return to the julia prompt. I now recommend closing then reopening the julia
console to ensure that all of your precompiled libraries are up to date.

When you are ready to start subject 0, enter the following commands at the julia prompt:

```julia
julia> using Anatta
julia> Anatta.go()
```

At this point your guide, Ani Anatta, will ask for your name. I recommend that you provide a
short, familiar form, since Ani will always use this name to address you as they support you
on your learning journey. For example, in lab 0, Ani will introduce you to the structure of your
computer by assisting you in setting up several convenient tools such as the software
development environment Visual Studio Code (VSC).

**Welcome to Anatta, and enjoy the fun of playing in julia!**

## Some useful Anatta DocStrings

```@docs
Anatta.go()
Activity
act()
ani()
askme()
hint( act::Activity=session.activity[session.current_act])
home!( dir::String=pwd())
home()
lab()
nextact( act::Int=0)
nextlab( lab_num::Int=-1, current_act::Int=1)
reply( response=nothing)
setup( library::String; force=false)
```
