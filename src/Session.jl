#========================================================================================#
#	Anatta
#
# This include file defines the structure of Activities and Sessions.
#
# Author: Niall Palfreyman, 7/12/2021
#========================================================================================#
#-----------------------------------------------------------------------------------------
# Concrete types:

#-----------------------------------------------------------------------------------------
"""
	Activity

A single activity to be performed and responded to by the learner.

An Activity is the basic unit of learning in Anatta. It contains ... 

# Fields
* `affordance`	: Text affording an activity to the learner.
* `hint`		: Text suggesting to the learner how to respond to the affordance.
* `success`		: Boolean function that defines the criteria for a successful learner response.

# Notes
* None

# Examples
```julia
julia> act = Activity( "What is 2+3?", "Add the numbers together", x -> x==5)
```
"""
struct Activity
	affordance :: String				# Affordance text
	hint :: String						# A hint to the learner, if she requires one
	success :: Function					# The criterion for a successful response
end

#-----------------------------------------------------------------------------------------
"""
	Session

Current state of a laboratory of learning activities.

A Session maintains the current state of a learning laboratory experience. It contains ... 

# Fields
* `anatta_home :: String`			: Path of the Anatta package
* `anatta_config :: String`			: Contains registration file of the session learner
* `home_dir :: String`				: Home folder of the session learner
* `learner :: String`				: Name of session learner
* `lab_num :: Int`					: Number of the session laboratory
* `is_pluto :: Bool`				: Is the session laboratory a Pluto workshop?
* `current_act :: Int`				: Number of the session activity in the laboratory
* `activities :: Vector{Activity}`	: Complete list of activities in this laboratory

# Notes
* None

# Examples
```julia
julia> sesh = Session()
```
"""
mutable struct Session
	anatta_home :: String				# Anatta home path
	anatta_config :: String				# Anatta configuration directory
	home_dir :: String					# Learner's home directory
	learner :: String					# Name of session learner
	lab_num :: Int						# Number of current lab
	is_pluto :: Bool					# Is this a Pluto session?
	current_act :: Int					# Number of current activity
	activities :: Vector{Activity}		# Set of activities in this session

	# One and only constructor of Sessions:
	Session() = new( "", "", "", "", 1, false, 1, Vector{Activity}())
end

#-----------------------------------------------------------------------------------------
# Methods:

#-----------------------------------------------------------------------------------------
"""
pose( act::Activity)

Present the affordance of the given Activity to the learner.
"""
function pose( act::Activity)
	print( act.affordance)
end

#-----------------------------------------------------------------------------------------
"""
evaluate( act::Activity, response)

Apply the success criterion of the activity to the given response from a learner.
"""
function evaluate( act::Activity, response)
	success = true
	try
		success = act.success(response)
	catch e
		# Response is badly wrong:
		success = false
	end

	if success
		# Success criterion is fulfilled:
		congratulate()
	else
		# Success criterion is not fulfilled:
		commiserate( act)
	end

	success
end

#-----------------------------------------------------------------------------------------
"""
congratulate()

Provide uplifting feedback to a successful learner response.
"""
function congratulate()
	congrats = [
		"Well done - great work!",
		"Great job - well done!",
		"You're doing great - keep it up!",
		"Good job!",
		"Good work!",
		"Nicely done!",
		"Yay! Well done!",
	]

	println()
	print( rand(congrats), " :) ")
end

#-----------------------------------------------------------------------------------------
"""
commiserate( act::Activity)

Provide supportive feedback to an unsuccessful learner response.
"""
function commiserate( act::Activity)
	commiseration = [
		"Not quite right, I'm afraid",
		"No, sorry - not quite right",
		"Oh, hard luck!",
		"No, not quite",
		"Sorry - that's not it",
		"Think again",
		"Nope, sorry",
	]

	println()
	print( rand(commiseration), " - you could try entering hint() at the julia prompt. ")
end

#-----------------------------------------------------------------------------------------
"""
labfile( session_path::String, labnum::Int)

Construct a valid labfile name from the given path and laboratory number.
"""
function labfile( session_path::String, n_lab::Int)
	normpath(
		joinpath(session_path,"..","Labs", "Lab" * lpad("$n_lab",3,'0')[1:3] * ".jl")
	)
end