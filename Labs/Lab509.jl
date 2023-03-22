#========================================================================================#
#	Laboratory 509
#
# Suboptimisation
#
# Author: Niall Palfreyman (March 2023), Stefan Hausner (June 2022)
#========================================================================================#
[	
	Activity(
		"""
		Welcome to Lab 509: Suboptimisation.

		Most major problems that we wish to solve using computers can be reformulated as
		MINIMISATION problems - that is, the problem of searching for the minimum value of
		some OBJECTIVE function like the length of a route between two cities or the amount of fuel
		needed to travel to Mars. The Suboptimisation model demonstrates how we might use a swarm
		of Scouts to search for this minimum value, but it also illustrates the major difficulty of
		all minimisation methods: SUBOPTIMISATION.

		There are two minimisation problems in this lab: an easy problem of three valleys and a
		more difficult function chosen from the famous DeJong test suite of objective functions.
		For now, run the Suboptimisation model with the parameter "difficult" set to FALSE; this
		works with the valleys function. In which direction do Scouts move in order to find the
		minima of this objective function?
		"""
		"In which direction would you walk to find a valley in the mountains?",
		x -> occursin("down",lowercase(x))
	),
	Activity(
		"""
		This kind of search is called "gradient descent", because the Scouts follow the negative
		gradient of the objective function. Find the function that calculates this gradient and
		tell me what value of stepsize I am using to calculate the gradient:
		"""
		"The symbol for stepsize is h",
		x -> x==1.0
	),
	Activity(
		"""
		You can see that the search is quite slow at points where the gradient of the objective
		function is almost zero. Why? What field of the Scouts is determined by this gradient?
		"""
		"",
		x -> x=="vel"
	),
	Activity(
		"""
		You can accelerate this search by taking the sign() of the gradient. Modify the code of
		the appropriate Scout method to do this, then test your code.
		"""
		"",
		x -> true
	),
	Activity(
		"""
		The suboptimisation problem is this: You see that the Scouts stream towards the appropriate
		valleys - they even do a great job as a swarm of detecting all three valleys. However, they
		cannot do any more than that. They have no way of telling us which valley is the deepest:
		the GLOBAL minimum. Instead, they only find suboptima.

		What mechanism does evolution use to get out of suboptimal solutions to the problem of
		species survival?
		"""
		"",
		x -> occursin("mutat",lowercase(x))
	),
	Activity(
		"""
		Now, this might not seem like a great problem yo you: Surely the Scouts have already
		narrowed down the search sufficiently for us to simply check through the three valleys and
		find the lowest. But now switch the parameter "difficult" to TRUE and let the Scouts
		search for a minimum value. The problem now is that the De Jong 2 function contains so
		many local ?____________? that the Scouts find too many suboptimal solutions.
		"""
		"",
		x -> occursin("minim", lowercase(x))
	),
	Activity(
		"""
		What you have just seen is THE biggest problem of computing today: We can easily program a
		computer to find optimal solutions, but how do we find the GLOBAL optimum? Typically, the
		problem of finding global optima is NP-complete. That is, solving this problem will take
		exponential amounts of time and resources. We will study this issue closer in the next
		few labs.

		In the meantime, I have another little exercise for you. If you look at the flow-map of the
		De Jong 2 function (or indeed any of our flow-maps so far), you will see that there is a
		white rim along the bottom and left edges of the map. This arises because the map is drawn
		from a matrix with indices 1:n, whereas the axes are drawn with coordinates 0:n.
		
		If you look back at the WaveDynamics module, you will see that the same problem arose there
		when I wanted to implement the waves emitted by the Sources. In the method model_step!(), I
		gathered the coordinates of the Source agents, but then I had to subtract 1 from these
		coordinates in order to match the find the correct spatial indices in order to implement
		the wave equation. You would be doing me a great favour if you could find a simple, elegant
		way of solving this problem generally. :)
		"""
		"",
		x -> true
	),
]