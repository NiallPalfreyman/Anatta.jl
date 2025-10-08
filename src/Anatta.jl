#========================================================================================#
"""
	Anatta

Anatta: Understanding Nature in terms of processes instead of things.

This is the central switchboard for the Anatta project, which will gradually build up into a
full course in using Julia to understand the world in terms of non-self (anatta).

To get started, simply install and load the Anatta library, then enter:
Anatta.go()

Author: Niall Palfreyman, 01/01/2023
"""
module Anatta

# Externally callable methods of Anatta
export Activity, act, ani, askme, hint, home, home!, lab, act!, lab!, reply, setup

#-----------------------------------------------------------------------------------------
# Module fields:

include("Session.jl")					# Include definitions of Session and Activity types.

session = Session()						# Create the single Anatta session

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	Anatta.go()

Initiate a new Anatta session. First, establish the name of the learner, then look up whether
Ani already possesses persistent registry information on that learner. If not, create a new
registry entry for the learner. In either case, decide which laboratory, current Activity and
Anatta home directory this learner requires, and initialise the session accordingly.

# Examples
```julia
julia> Anatta.go()
Welcome to Anatta: A julian guide to ...
```
"""
function go()
	global session					# We're setting up the global session
	install!(session)				# Ensure file structure fulfills all requirements

	# Personalise the session for this learner:
	println()
	println( "Welcome to Anatta: A julian guide to understanding the world in terms of processes :)\n")
	print( "My name is Ani! What's yours?  ")
	session.learner = readline()
	println( "\nHi ", session.learner, "! Just setting things up for you ...")

	# Ensure session learner file exists:
	lnr_file = joinpath(session.anatta_config,session.learner*".lnr")
	if !(isfile(lnr_file))
		cp( joinpath(session.anatta_config,"Ani.lnr"), lnr_file)
	end

	# Grab information on learner's current progress:
	istream = open(lnr_file)
	session.lab_num = parse(Int,readline(istream))
	session.current_act = parse(Int,readline(istream))
	session.home_dir = readline(istream)
	close(istream)

	# Open the requested labfile:
	home()
	lab!(session.lab_num,session.current_act)
end

#-----------------------------------------------------------------------------------------
"""
	ani()

Ask Ani to display a friendly menu of Anatta commands.
"""
function ani()
	greeting = [
		"Hi, here I am!", "Interesting stuff this, isn't it?", "G'day cobber!",
		"You're doing a grand job!", "You have such lovely eyes!",
		"Salam aleikum!", "Namasté!"
	]

	println( rand(greeting)*" :) Here's a complete list of Anatta commands:")
	println( "   act()                : Display the current activity number")
	println( "   act!(act=next)       : Move to the learning activity 'act'")
	println( "   ani()                : Ask me to display this list of Anatta functions")
	println( "   askme()              : Tell you the current activity")
	println( "   demo()               : Execute any available demo code for the current activity")
	println( "   hint()               : Display a hint for the current activity")
	println( "   home!(dir=pwd())     : Set your Anatta home folder")
	println( "   home()               : Move to your Anatta home folder")
	println( "   lab()                : Display the current laboratory number")
	println( "   lab!(lab=next)       : Move to the laboratory 'lab'")
	println( "   reply(response=skip) : Submit your response to the current activity")
	println( "   setup(library)       : Copy Anatta library to home Development folder")
	println( "   setup()              : Install any new Scripts after updating your Anatta version.")
end

#-----------------------------------------------------------------------------------------
"""
	home!( dir::String=pwd())

Set the learner's home directory.
"""
function home!( dir::String=pwd())
	cd( dir)							# Check that the directory actually exists
	session.home_dir = dir				# Then set new home directory

	setup()								# Setup Scripts and Tools
	save()
	session.home_dir
end

#-----------------------------------------------------------------------------------------
"""
	home()

Move to the learner's home directory.
"""
function home()
	cd(session.home_dir)
	session.home_dir
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
	demo( act::Activity=session.activity[session.current_act])

Execute any available demonstration code for the current activity.
"""
function demo( act::Activity=session.activities[session.current_act])
	eval(act.demo)
end

#-----------------------------------------------------------------------------------------
"""
	askme()

Display the current activity to the learner.
If this activity exists, display it; otherwise move to next laboratory.
"""
function askme()
	if session.current_act ≤ length(session.activities)
		# There are new activities in this lab - go to the next one:
		act()												# Display activity number
		pose(session.activities[session.current_act])		# Display activity text
	else
		# Current activity was the last in the lab - go to next lab:
		lab!()
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
	reply( response=nothing)

Learner replies to the current activity with the given response.
If this response fulfills the current activity's success criterion, move on to the next
activity; otherwise check with learner whether s/he wants to move on or to stay with the
current activity.
"""
function reply( response=nothing)
	if !evaluate(session.activities[session.current_act],response)
		# Response is unsuccessful:
		print("Do you want to try again? ")
		userresponse = lowercase(readline())
		if occursin('y',userresponse) || occursin("hint",userresponse)
			return												# User wishes to proceed
		end
	end

	# Whether response was correct, incorrect or missing, we're moving to the next activity:
	println( "Let's move on ...\n")
	act!()
end

#-----------------------------------------------------------------------------------------
"""
	act!( act::Int = 0)

Move to the next activity.
If act is provided, move to that number activity, otherwise move to the next activity in
this lab. If that takes you beyond the end of this lab, move to the beginning of the next lab.
"""
function act!( act::Int = 0)
	if act ≤ 0
		# act is not an activity, but a step forward (=0) or backward (<0):
		act = max( 1, session.current_act + (iszero(act) ? 1 : act))
	end

	if act ≤ length(session.activities)
		# act is a valied activity - go to it:
		session.current_act = act
		save()
		askme()
	else
		# We've completed last activity - go to next lab:
		println( "That's the end of lab ", session.lab_num, ". Just preparing the next lab ...")
		lab!()
	end
end

#-----------------------------------------------------------------------------------------
"""
	lab!( lab_num::Int = -1, current_act::Int = 1)

Move to the beginning of the next lab.
If lab_num is specified, move to that number lab, otherwise move to the next lab. If that takes
you beyond the end of the available labs, stay where you are and inform the learner.
"""
function lab!( lab_num::Int = -1, current_act::Int = 1)
	if lab_num < 0
		# No lab given - default to next lab after the current one:
		lab_num = session.lab_num + 1
	end

	# Check validity of lab_file, then open it:
	lab_file = labfile(session.anatta_home,lab_num)
	if !isfile(lab_file)
		# The new lab_file is not available in the lab directory:
		println("Sorry: Lab number $(lab_num) is unavailable.")
		return
	end
	session.activities = include(lab_file)
	
	# Update session information for the new laboratory:
	session.lab_num = lab_num
	session.current_act = current_act
	save()

	# Display welcome message to the new laboratory.
	println()
	println( "Great - I've set up the laboratory. Please note that if you have just completed")
	println( "another lab in this Julia console, name conflicts may arise. You can clear these")
	println( "by simply restarting the console and restarting Anatta.\n")
	println( "Remember: your two most important commands are ...")
	println( "    Enter askme() whenever you want to see the current learning activity")
	println( "    Enter ani() at any time to ask me about your available options.")
	println( "Have fun! :)\n")

	# Display the new laboratory number:
	lab()
end

#-----------------------------------------------------------------------------------------
"""
	save()

Save the status of the current session to the learner's registry file.
Write lab_file and current_act to the usr file.
"""
function save()
	# Open learner registry file.
	os = open(joinpath(session.anatta_config,session.learner*".lnr"),"w")
	println(os, session.lab_num)		# Save current laboratory
	println(os, session.current_act)	# Save current activity
	println(os, session.home_dir)		# Save learner's home folder
	close(os)
end

#-----------------------------------------------------------------------------------------
"""
	setup( library::String; force=false)

Set up the named library within the learner's home directory, forcing overwrite if requested.
"""
function setup( library::String; force=false)
	# Check existence of the library code:
	frompath = joinpath( session.anatta_home, "Development", library)
	if !isdir(frompath)
		println(frompath)
		println("Sorry: The library $(library) is unavailable.")
		return
	end

	# Check we're not accidentally overwriting an existing library:
	development_path = joinpath(session.home_dir,"Development")
	topath = joinpath(development_path,library)

	# Only overwrite existing topath if learner insists:
	if isdir(topath) && !force
		println("Local library $(library) already exists. Specify force=true to overwrite.")
		return
	end

	# Ensure Development directory exists:
	if !isdir(development_path)
		mkdir(development_path)
	end

	# Copy the development library across, then ensure Tools and Scripts are up to date:
	cp( frompath, topath, force=true)
	setup()
	library
end

#-----------------------------------------------------------------------------------------
"""
	setup()

Set up the Tools and Scripts in the home directory.
"""
function setup()
	# Ensure tools are set up:
#	tool_path = joinpath(session.home_dir,"Tools")
#	cp( joinpath( session.anatta_home, "Tools"), tool_path, force=true)
	# Ensure scripts are set up:
	scripts_path = joinpath(session.home_dir,"Scripts")
	cp( joinpath( session.anatta_home, "../Scripts"), scripts_path, force=true)
end

#-----------------------------------------------------------------------------------------
"""
	install!(session)

First-time installation and check of the Anatta environment, installing any missing files.
"""
function install!(session::Session)
	# Create path to Anatta labs registry:
	session.anatta_home = dirname(@__FILE__)
	session.anatta_config = joinpath(DEPOT_PATH[1],"Anatta")
	session.learner = "Ani"

	# Ensure Anatta config directory exists:
	if !isdir(session.anatta_config)
		mkdir(session.anatta_config)
	end

	# Initialise session learner data:
	lnr_file = joinpath(session.anatta_config,session.learner*".lnr")
	if !(isfile(lnr_file))
		# Register info for new learner:
		ostream = open(lnr_file,"w")
		println(ostream, "0")		# Initial laboratory
		println(ostream, "1")		# Initial activity
		println(ostream, tempdir())
		close(ostream)
	end

	# Grab information on learner's current progress:
	istream = open(lnr_file)
	session.lab_num = parse(Int,readline(istream))
	session.current_act = parse(Int,readline(istream))
	session.home_dir = readline(istream)
	close(istream)
end

end # End of module Anatta