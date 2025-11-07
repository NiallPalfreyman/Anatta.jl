#========================================================================================#
"""
	Cooperation

Module Cooperation: A model of players interacting, using strategies of varying cooperation.

This program investigates the following research question:
	By what route can altruistic cooperation infiltrate a thoroughly exploitative population?

Author: Niall Palfreyman, 05/11/2025
"""
module Cooperation

using Random, CairoMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Players

A simulation of evolutionary game strategies for PD interactions in a population of nStrategies.
"""
mutable struct Players
	payoff::Matrix{Float64}			# Payoff matrix
	strategies::Vector{Vector}		# Strategies of current population
	x::Vector{Float64}				# Current frequency of strategies
	novak::Matrix{Float64}			# Novak's matrix of expected payoffs

	"""
		Players( payoff, nstrategies)

	The one-and-only Players constructor: Create a Players population of size nstrategies that will
	interact using the given payoff matrix.
	"""
 	function Players( A::Matrix=[4 0;5 1], nstrategies=10)
		new(
			Float64.(A),							# Payoff matrix
			[rand(2) for _ in 1:nstrategies],		# p and q strategy parameters
			ones(nstrategies)/nstrategies,			# Uniform strategy distribution
			zeros(Float64,2,2),						# Initial novak matrix
		)
	end
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	mutate!( players, mu)

Replace the least fit fraction mu of the current strategies by new, randomly selected strategies,
and adjust frequencies accordingly.
"""
function mutate!( players::Players, mu::Float64=0.2)
	# Dummy code
end

#-----------------------------------------------------------------------------------------
"""
	set!( players, strategy)

Set all current strategies to the given strategy with random variation epsilon.
"""
function set!( players::Players, strategy::Vector{Float64}, epsilon=0.01)
	nstrategies = length(players.x)
	strategies = [copy(strategy) + epsilon*(2*rand(2).-1) for _ in 1:nstrategies]
	players.strategies = map(strategies) do strat
		# Ensure strategy lies within the interval (0,1):
		max.(epsilon,min.(1-epsilon,strat))
	end
	players.x .= 1/nstrategies
end

#-----------------------------------------------------------------------------------------
"""
	simulate!( players, ngenerations)

Simulate the Players dynamics for ngenerations, starting from initial state x0.
"""
function simulate!( players::Players, ngenerations::Int=1)
	# Dummy code
end

#-----------------------------------------------------------------------------------------
"""
	novak!( players)

Recalculate Novak's expected payoff from current strategies and payoff matrix.
"""
function novak!( players::Players)
	# Dummy code
end

#-----------------------------------------------------------------------------------------
"""
	avgstrategy( players)

Return average strategy across current population.
"""
function avgstrategy( players::Players)
	players.x'*players.strategies
end

#-----------------------------------------------------------------------------------------
# Display methods:
#-----------------------------------------------------------------------------------------
"""
	behaviour( p::Float64, q::Float64)

Return 4-char string classifying the strategy S(p,q) according to cooperating/defecting
behavioural type:

	(0.0,0.0) : AllD - Always defect
	(0.0,0.5) : Xplt - Exploiting
	(0.0,1.0) : AlDG - Always disagree
	(0.5,0.0) : STFT - Selfish TFT
	(0.5,0.5) : Dthr - Dithering
	(0.5,1.0) : Plac - Placating
	(1.0,0.0) :  TFT - Tit-for-tat
	(1.0,0.5) : GTFT - Generous TFT
	(1.0,1.0) : AllC - Always cooperate
"""
function behaviour( strategy::Vector)
	cutoff = 0.2				# Strategy classification cutoff
	p,q = strategy
	
	if q > 1-cutoff
		return (p<cutoff) ? "AlDG" : ((p<1-cutoff) ? "Plac" : "AllC")
	elseif q > cutoff
		return (p<cutoff) ? "Xplt" : ((p<1-cutoff) ? "Dthr" : "GTFT")
	else
		return (p<cutoff) ? "AllD" : ((p<1-cutoff) ? "STFT" : " TFT")
	end
end

#-----------------------------------------------------------------------------------------
"""
	show( players, bpause)

Display the current Players frequencies at the console in descending frequency order.
"""
function show( players::Players, proportion=1, bpause::Bool=false)
	proportion = max(0,min(1,proportion))
	ntoshow = ceil(Int,proportion*length(players.x))
	toshow = sortperm(players.x,rev=true)[1:ntoshow]
	for i in 1:ntoshow
		println("$(behaviour(players.strategies[toshow[i]])): $(players.x[toshow[i]])")
	end
	println()
	if bpause
		# Pause to allow user to digest output
		readline()
	end
end

#-----------------------------------------------------------------------------------------
"""
	present(history::Vector)

Present the results of a Players run.
"""
function present( history::Vector)
	fig = Figure(fontsize=16, regular="Helvetica", linewidth=5, size=(1412,1000))

	present_title!(fig)
	present_context!(fig)
	present_problem!(fig)
	present_method!(fig)
	present_results!(fig)
	present_implications!(fig)
	present_references!(fig)

	# Plot trajectory of forgiveness against reciprocation:
	axis = Axis( fig[4:5, 2],
		title = "Trajectory of Forgiveness against Reciprocation over time",
		xlabel = "Reciprocation", ylabel = "Forgiveness",
		xgridvisible = true, ygridvisible = true,
		xticks = 0:0.1:1, yticks = 0:0.1:0.7,
		backgroundcolor=(:green, 0.1)
	)
	scatterlines!( axis, getindex.(history,1), getindex.(history,2),
		color=:blue,
		markercolor=:red, markersize=10
	)
	xlims!(axis, 0, 1)
	ylims!(axis, 0, 0.6)

	save("CooperationInfoSheet.pdf",fig)
	nothing
end

#-----------------------------------------------------------------------------------------
"""
	present_title!( fig)

In the given figure, describe the relevance of the Cooperation model in the context of current
scientific debate.
"""
function present_title!( fig)
	Label(fig[1, 1:2], fontsize = 30, justification=:left, halign=:left, color=:darkgreen, font=:bold,
		text = "Is group selection essential to the evolution of cooperation?"
	)
	Label(fig[2, 1:2], fontsize = 20, justification=:left, halign=:left, color=:darkgreen, font=:italic,
		text = "A computational game dynamics study in evolutionary biology\n" *
			"Niall Palfreyman, Weihenstephan-Triesdorf University of Applied Sciences, 3.11.2025"
	)
end

#-----------------------------------------------------------------------------------------
"""
	present_context!( fig)

In the given figure, describe the relevance of the Cooperation model in the context of current
scientific debate.
"""
function present_context!( fig)
	Box(fig[1:2,3], cornerradius=10, color=:darkgreen, strokecolor=:darkgreen, strokewidth=2)
	Label(fig[1:2,3], justification=:left, halign=:left, padding=10, color=:white,
		text = "Context:\n" *
			"Wilson & Wilson (2007) argue that group\n" *
			"selection drives evolution of cooperative\n" *
			"behaviour. However, many theorists claim\n" *
			"group selection is irrelevant to evolution."
	)
end

#-----------------------------------------------------------------------------------------
"""
	present_problem!( fig)

In the given figure, describe the specific problem that the Cooperation model addresses in current
scientific debate.
"""
function present_problem!( fig)
	Box(fig[3,1], cornerradius=10, color=:blue, strokecolor=:darkgreen, strokewidth=2)
	Label(fig[3,1], justification=:left, halign=:left, padding=10, color=:white,
		text = "Problem:\n" *
			"We observe cooperative behaviour\n" *
			"in the biological world; however, in\n" *
			"such examples, it is often unclear\n" *
			"whether these behaviours originally\n" *
			"evolved through group selection."
	)
end

#-----------------------------------------------------------------------------------------
"""
	present_method!( fig)

In the given figure, describe the exact, algorithmic sequence of steps and measurements that others
scientists must use in order to reproduce your findings.
"""
function present_method!( fig)
	Box(fig[3,2:3], cornerradius=10, color=:blue, strokecolor=:darkgreen, strokewidth=2)
	Label(fig[3,2:3], justification=:left, halign=:left, padding=10, color=:white,
		text = "Method:\n" *
			"Group selection presupposes that the subjects of evolution are niche-" *
			"constructing (Laland 2024) developmental (Puentedura 2007)\n" *
			"processes (evo-eco-devo). Here, we simulate computationally (Nowak 2006)" *
			"a population of Prisoner’s Dilemma (PD) processes whose\n" *
			"strategy can mutate arbitrarily with low probability. Strategies are selectively " *
			"punished for exhibiting (with probability q) the cooperative\n" *
			"behaviour of forgiveness, unless this forgiveness is reciprocated " *
			"(with probability p) by other players. In this case, selection rewards the\n" *
			"mutual interaction between forgiveness and reciprocation.\n" *
			"We discuss whether this dynamical system demonstrates that group selection is " *
			"essential to the evolution of cooperation."
	)
end

#-----------------------------------------------------------------------------------------
"""
	present_results!( fig)

In the given figure, describe the precise, uninterpreted and error-prone empirical data that
arose from implementing the method.
"""
function present_results!( fig)
	Box(fig[4,1], cornerradius=10, color=:red, strokecolor=:darkgreen, strokewidth=2)
	Label(fig[4,1], justification=:left, halign=:left, padding=10, color=:white,
		text = "Results:\n" *
			"In the graph, cooperation evolves in\n" *
			"a mutating population of PD defectors.\n" *
			"Initially, forgiving behaviour is\n" *
			"penalised: its representation in the\n" *
			"population falls as reciprocating rises.\n" *
			"Subsequently, forgiving rises to q≈0.6\n" *
			"and reciprocating rises towards p≈1.0."
	)
end

#-----------------------------------------------------------------------------------------
"""
	present_implications!( fig)

In the given figure, describe the meaning and implications of your results in relation to the
previous description of the problem and its context.
"""
function present_implications!( fig)
	Box(fig[5,1], cornerradius=10, color=:red, strokecolor=:darkgreen, strokewidth=2)
	Label(fig[5,1], justification=:left, halign=:left, padding=10, color=:white,
		text = "Implications:\n" *
			"Cooperation evolves as defectors\n" *
			"construct around themselves a\n" *
			"mutually reciprocating niche of\n" *
			"players that reward forgiveness.\n" *
			"Since this niche is selected due to\n" *
			"its group property of reciprocating\n" *
			"behaviour between its members,\n" *
			"our results suggest that selection of\n" *
			"groups is important for the evolution\n" *
			"of cooperation."
	)
end

#-----------------------------------------------------------------------------------------
"""
	present_references!( fig)

In the given figure, list all sources of information cited all the above descriptions. The journal
Constructivist Foundations requires references to be in Times New Roman font.
"""
function present_references!( fig)
	Box(fig[4:5,3], cornerradius=10, color=(:lime, 0.5), strokecolor=:darkgreen, strokewidth=2)
	Label(fig[4:5,3], font="Times New Roman", fontsize=20, justification=:left, halign=:left,
		padding=10, color=:black,
		text="References:\n" *
			"•   Laland, K. (2024) DIY evolution.\n    New Scientist 264(3520): 26–29.\n" *
			"•   Nowak, M.A (2006) Evolutionary\n    dynamics. Harvard University\n    Press.\n" *
			"•   Puentedura, R.R. (2007) The\n    Baldwin effect in the age of\n    computation. " *
			"In: Weber, B.H. &\n    Depew, D.J. (eds): Evolution and\n    learning. MIT Press.\n" *
			"•   Wilson D.S. & Wilson, E.O. (2007)\n    Evolution: Survival of the selfless.\n" *
			"    New Scientist 196(2628): 42–46."
	)
end

#-----------------------------------------------------------------------------------------
# Demo methods:
#-----------------------------------------------------------------------------------------
"""
	demo(ntrials=50)

Use PD dynamics to investigate the following research question:
By what route can altruism infiltrate a thoroughly exploitative population?
"""
function demo(ntrials=50)
	# Initialisation:
	Apd = [4 0; 5 1]									# Prisoners' Dilemma payoff matrix
	nStrategies = 50									# How many strategy types?
	nMutations = 1000									# How many mutation events occur?
	nGenerations = 70									# How many generations between mutations?
	
	players = Players( Apd, nStrategies)				# n-stplayeregy population using Apd.
	avghistory = [[0.0,0.0] for _ in 1:nMutations+1]	# History averaged over ntrials.

	set!(players,[0.075,0.075],0.025)					# Set up initial exploitative population
	println("Initial population:")
	show(players, 0.1)									# Show initial population
	for _ in 1:ntrials
		# Perform a single trial simulation:
		set!(players,[0.075,0.075],0.025)				# Reset initial exploitative population
		avghistory[1] += avgstrategy(players)

		for mut in 1:nMutations
			# Mutate then simulate nGeneplayerions:
			mutate!(players,0.001)						# Replace current weakest fraction of strategies
			simulate!( players, nGenerations)			# Iterate PD interactions
			avghistory[mut+1] += avgstrategy(players)	# Accumulate new simulation results
		end
	end
	println("Final population:")
	show(players, 0.1)									# Show final population
	present(avghistory/ntrials)							# Calculate and present averaged history
end

end		# ... of module Players