#========================================================================================#
"""
	Anatta

Anatta: Understanding Nature in terms of processes instead of things.

This is the central switchboard for the Anatta project, which will gradually build up into a
full course in using Julia to understand the world in terms of non-self (anatta).

Author: Niall Palfreyman, 01/01/2023
"""
module Anatta

# Externally callable methods of Anatta
export ani, gimme, lab, act, reply, hint, nextlab, nextact

using Pluto								# We want to be able to use Pluto notebooks

#-----------------------------------------------------------------------------------------
# Module fields:

include("Session.jl")					# Include definitions of Session and Activity types.

session = Session()						# Create the single Anatta session

#-----------------------------------------------------------------------------------------
# Module methods:

#-----------------------------------------------------------------------------------------
"""
	run()

Initiate an Anatta session.

Establish the name of the learner, then look up whether we possess persistent registry
information on that learner. If not, create a new registry entry for the learner. In either
case, decide which laboratory and current Activity this learner requires, and initialise
the session accordingly.

# Notes
* This module is a work in progress 😃 ...

# Examples
```julia
julia> Anatta.run()
Welcome to the pedagogical playground of Anatta!! ...
```
"""
function run()
	global session					# We're setting up the global session

	# Create path to Anatta labs registry:
	session.lab_path = normpath(joinpath(dirname(@__FILE__),"..","Labs"))

	println()
	println( "Welcome to the pedagogical playground of Anatta!! :)")
	println()
	println( "Anatta is the idea that Nature is based not on things, but on processes. In this")
	println( "course, we use the programming language julia to investigate how this change of")
	println( "focus completely alters the way we think about our experience of Nature.")
	println()
	print( "My name is Ani! What's yours?  ")
	learner = readline()
	println( "\nHi ", learner, "! Just setting things up for you ...\n")

	# Establish session learner file:
	session.lnr_file = learner*".lnr"
	if !(isfile(session.lnr_file))
		# Register info for new learner:
		stream = open(session.lnr_file,"w")
		println(stream, "1")		# Initial laboratory
		println(stream, "1")		# Initial activity
		close(stream)
	end

	# Grab information on learner's current progress:
	stream = open(session.lnr_file)
	laboratory = lpad(readline(stream),3,'0')[1:3]
	session.lab_num = parse(Int,laboratory)
	session.current_act = parse(Int,readline(stream))
	close(stream)

	# Open the requested labfile:
	nextlab(session.lab_num,session.current_act)
end

#-----------------------------------------------------------------------------------------
"""
	ani()

Display a friendly menu of Anatta commands.
"""
function ani()
	greeting = [
		"Hi, here I am!", "Interesting stuff this, isn't it?", "G'day cobber!",
		"You're doing a grand job!", "You have a lovely smile!"
	]

	println( rand(greeting)*" :) Here's a list of Anatta commands:")
	println( "   hint()               : Display a hint for the current activity")
	println( "   gimme()              : Give me the current activity")
	println( "   act()                : Display the current activity number")
	println( "   lab()                : Display the current laboratory number")
	println( "   reply(response=skip) : Submit a response to the current activity")
	println( "   nextact(act=next)    : Move to the learning activity act")
	println( "   nextlab(lab=next)    : Move to the laboratory lab")
end

#-----------------------------------------------------------------------------------------
"""
hint( act::Activity=session.activity[session.current_act])

Display a hint for the current activity
"""
function hint( act::Activity=session.activities[session.current_act])
	if isempty(act.hint)
		# No hint is given - display general remorse:
		println( "No hint available - you're on your own here, I'm afraid! :-(")
	else
		# Display the available hint:
		println( "Hint:  ", act.hint)
	end
end

#-----------------------------------------------------------------------------------------
"""
	gimme()

Display the current activity to the learner.

If this activity is available, display it; otherwise move to next laboratory.
"""
function gimme()
	if session.current_act ≤ length(session.activities)
		# There are new activities in this lab - go to the next one:
		act()												# Display activity number
		pose(session.activities[session.current_act])		# Display activity text
	else
		# Current activity was the last in the lab - go to next lab:
		nextlab()
	end
end

#-----------------------------------------------------------------------------------------
"""
	lab()

Display the current laboratory number to the learner.
"""
function lab()
	println("Laboratory ",session.lab_num," ...")
end

#-----------------------------------------------------------------------------------------
"""
	act()

Display the current activity number to the learner.
"""
function act()
	println("Activity ",session.current_act,"/", length(session.activities), " ...")
end

#-----------------------------------------------------------------------------------------
"""
	reply( response)

Learner replies to the current activity with the given response.

If the answer is correct, move on to the next activity; otherwise check with learner.
"""
function reply( response=nothing)
	if !evaluate(session.activities[session.current_act],response)
		# Response is unsuccessful:
		print("Do you want to try again? ")
		if ~occursin('n',lowercase(readline()))
			# User did not answer no: default behaviour is to stay with this activity:
			return
		end
	end

	# Whether response was correct, incorrect or missing, we're moving to the next activity:
	println( "Let's move on ...")
	println()
	nextact()
end

#-----------------------------------------------------------------------------------------
"""
	nextact( activity)

Move to the next activity.

If activity is given, move to that number activity, otherwise move to the next activity in
this lab. If that takes you beyond the end of this lab, move to the beginning of the next lab.
"""
function nextact( act::Int = 0)
	if act ≤ 0
		# No activity given - default to next activity after current one:
		act = session.current_act + 1
	end

	if act ≤ length(session.activities)
		# act is a valied activity - go to it:
		session.current_act = act
		save()
		gimme()
	else
		# We've completed last activity - go to next lab:
		println( "That's the end of lab ", session.lab_num, ". Just preparing the next lab ...")
		nextlab()
	end
end

#-----------------------------------------------------------------------------------------
"""
	nextlab( lab)

Move to the beginning of the next lab.

If lab is given, move to that number lab, otherwise move to the next lab. If that takes
you beyond the end of the available labs, stay where you are and inform the learner.
"""
function nextlab( lab_num::Int = 0, current_act::Int = 1)
	if lab_num ≤ 0
		# No lab given - default to next lab after the current one:
		lab_num = session.lab_num + 1
	end

	# Check validity of lab_file:
	lab_file = labfile(session.lab_path,lab_num)
	if !isfile(lab_file)
		# The new lab_file is not available in the lab directory:
		println("Sorry: Lab number $(lab_num) is unavailable.")
		return
	end

	# Update session information for the new laboratory:
	session.lab_num = lab_num
	session.current_act = current_act
	save()

	# Open lab_file and offer help:
	stream = open(lab_file)
	session.is_pluto = occursin("Pluto.jl notebook",readline(stream))
	close(stream)

	if session.is_pluto
		# Open a Pluto lab:
		println( "I'm about to set up a Pluto lab. After it has loaded, if you wish to experiment")
		println( "in Julia while the lab is running, you can press Ctrl-C in the Julia console.")
		println( "...")
		@async Pluto.run(notebook=lab_file)
	else
		# Open a Julia lab:
		session.activities = include(lab_file)
	end

	# Display welcome message to the new laboratory.
	println( "Great - I've set up the laboratory. Please note that if you have just completed")
	println( "another lab in this Julia console, name conflicts may arise. You can clear these")
	println( "by simply restarting the console and restarting Anatta.")
	println( "Enter ani() at any time to ask me about your available options. Have fun! :)")
	println()

	# Display the new laboratory number:
	lab()
end

#-----------------------------------------------------------------------------------------
"""
	save()

Save the status of the current session.

Write lab_file and current_act to the usr file.
"""
function save()
	stream = open(session.lnr_file,"w")
	println(stream, session.lab_num)		# Save current laboratory
	println(stream, session.current_act)	# Save current activity
	close(stream)
end

end # End of Module Anatta