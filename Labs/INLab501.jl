#========================================================================================#
#	Laboratory 501
#
# A first look at dynamical systems modelling with a simple Ecosystem.
#
# Author: Niall Palfreyman (24/04/2022), Dominik Pfister (July 2022)
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 501!

		Now we understand the general structure of ABMs, we will turn from physics to a more
		biological example: Organisms interacting with each other in an ecosystem.

		The file Ecosystem.jl implements a model of a world in which turtles walk around and gain
		energy from eating algae, if they can find some. If a turtle gains enough energy, it will
		reproduce, and if its energy falls to zero, it will die. Algae that have been eaten by the
		turtles will also regrow with a certain specified regrowth probability.
		
		Again, I started developing this model by simply copying IdealGas.jl, then stripping out
		the functionality I wanted to change.

		One reference mode for this system is that it is sustainable: that the turtles survive and
		the algae can regrow. Run Ecosystem.demo() to verify whether it does indeed fulfil this
		reference mode.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		We will use this simple Ecosystem model to learn a bit more about how to create Agents, and
		also some useful ways of representing Agents on the screen.

		First, run the video clip a few times to get a feeling for what's happening. You can't see
		the algae yet, but you can verify that they are there by experimenting with the value of
		the model property prob_regrowth in the initialisation method ecosys(). Notice its effect
		on the turtle population.
		""",
		"prob_regrowth=0 prevents algae from regrowing; prob_regrowth=1 will probably explode!",
		x -> true
	),
	Activity(
		"""
		At the beginning of a run, you may notice that sometimes a string of turtles appears that
		are moving together in a line that then breaks up. Think carefully about how this might
		be happening, then tell me which method is causing it:
		""",
		"Investigate how new turtles are born",
		x -> occursin("repr",lowercase(x))
	),
	Activity(
		"""
		The circles representing the turtles don't show us which way the turtles are facing (vel),
		so it would be nice to change their representation accordingly. You can achieve this by
		doing the following:
			- include() the file AgentTools.jl from the DSM folder;
			- In demo(), specifiy agent marker `AgentTools.wedge`;
			- Specify also agent colour `:red` and agent size 10;
			- Recompile and run Ecosystem.jl.

		Which kwarg specifies the agent marker?
		""",
		"",
		x -> x=="am"
	),
	Activity(
		"""
		It would be helpful if we could see the algae and their reaction to the presence of
		turtles. In order to visualise them, we shall add them in as a "heatarray" (this is
		abmvideo's rather strange name for a background field). The values of the algae are
		already contained in the Ecosystem model property :algae, and we can easily include these
		values in the video by inserting into abmvideo() the following kwargs:
			heatarray=(model->model.algae), 						# Background map of algae
			heatkwargs=(colormap=[:black,:lime],colorrange=(0,1)),	# Algae's colours
			add_colorbar=false,										# No need for algae colour bar

		Do this now, then tell me the colour of the algae:
		""",
		"",
		x -> x==:lime
	),
	Activity(
		"""
		Before proceeding with this lab, you may first like to experiment with different colours
		for the heatmap. You can find a full list of colorschemes here: ???
			https://docs.juliaplots.org/latest/generated/colorschemes/
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Notice how the number of arguments in the call to abmvideo() is getting rather large
		and difficult to understand. In such situations it is useful to pull out the relevant
		keyword arguments into a separate variable - for example called plotkwargs = and then to
		insert this variable into the call to abmvideo() like this:
			abmvideo(
				"Ecosys.mp4", ecosys, agent_step!, model_step!;
				framerate = 50, frames = 2000,
				plotkwargs...
			)
	
		Do this now, and ensure that your simulation is still working correctly.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		In order to understand our Ecosystem better, it would be nice to be able to work more
		interactively with it, changing parameters and immediately seeing the results. For this
		reason, we will now replace our call to abmvideo() by a call to abmexploration(). This
		method builds an exploratory playground around the Ecosystem model. Do this now:
			playground, = abmexploration( ecosys;
				agent_step!, model_step!,
				plotkwargs...
			)

		Then make sure that Ecosystem.demo() returns the Figure `playground`, so that you can
		view and use the resulting app. Which slider bar enables you to reduce the speed of the
		simulation?
		""",
		"",
		x -> occursin("sleep",lowercase(x))
	),
	Activity(
		"""
		Now we will install our own slider bars for the model parameters that we wish to experiment
		with. Make the following changes to Ecosystem.demo(), then run it again to make sure your
		new sliders are working correctly. Note that it is important that your variable is named
		'params', since that is the correct keyword for calling abmexploration():
			params = Dict(
				:n_turtles		=> 1:200,
				:turtle_speed	=> 0.1:0.1:3.0,
				:prob_regrowth	=> 0:0.0001:0.01,
				:initial_energy	=> 10.0:200.0,
				:Δenergy		=> 0:0.1:5.0,
			)
		
			playground, = abmexploration( ecosys;
				agent_step!, model_step!, params,
				plotkwargs...
			)
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Finally, I would like to investigate some time-series statistics in the output: I'd like to
		view the ongoing numbers of turtles and algae. To do this, please insert the following two
		extra lines of arguments into plotkwargs and rerun your simulation:
			adata=[(a->isa(a,Turtle),count)], alabels=["Turtles"],
			mdata=[(m->sum(m.algae))], mlabels=["Algae"],
		""",
		"",
		x -> true
	),
	Activity(
		"""
		You should observe that for certain values of `prob_regrowth`, the numbers of turtles and
		algae converge reliably towards oscillations around a more-or-less constant value. Now,
		this may not yet seem very special to you, but it actually underlies our understanding of
		how life works. This 'decision' to converge is not made by any individual turtle, nor even
		by the population of turtles, but by the entire Ecosystem of turtles+algae. In system
		dynamics, we say that the system's "structure determines behaviour".

		There are two different kinds of system-level, structurally determined behaviour:
		"collective" and "emergent" behaviour. The oscillations of our Ecosystem are an example of
		collective behaviour: they are _determined_, but not _chosen_, by the system. "Collective"
		behaviour arises from the behaviour of many interacting individuals, but the system itself
		does not yet select between different possible individual behaviours. "Emergent" behaviour
		is less easy to define, but we will look more closely at it in the next lab. Emergence
		describes well the fact that we cannot predict YOUR behaviour based only on your individual
		component cells.

		We would like to test how reliable this collective oscillation of the Ecosystem model is, but
		at the moment it is difficult to test this because the Reset button of abmexploration()
		doesn't reinitialise the model. Try this out now: rerun the model several times and notice
		that the initial configuration of the agents is always the same...
		""",
		"",
		x -> true
	),
	Activity(
		"""
		The AgentTools function abmplayground() enforces complete initialisation of our ABM models,
		and we will mostly use abmplayground() in this course. It requires the initialiser function
		ecosystem() as an argument, but all other arguments are simply passed to abmexploration().

		In your Ecosystem model, replace the call to abmexploration() by a call to abmplayground().
		Leave all the arguments the same, but insert the name of the initialiser function
		"ecosystem" as a second argument between the model name "ecosys" and the semicolon
		indicating the start of the keyword arguments - like this:
			playground, = abmplayground( ecosys, ecosystem;
				agent_step!, model_step!, params,
				plotkwargs...
			)

		Now run the model again and confirm that the collectively determined oscillations occur
		reliably for all initial configurations of turtles in the Ecosystem ...
		""",
		"",
		x -> true
	),
]