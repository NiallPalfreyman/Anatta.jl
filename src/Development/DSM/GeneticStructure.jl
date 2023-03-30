#========================================================================================#
"""
	Genetic structure

A simulation to investigate the use of genetic structure in agents to help them solve problems.
	
Author: Niall Palfreyman (March 2023).
"""
module GeneticStructure

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools
using Statistics:mean
using Statistics:std

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Turtle

Turtles chase around the world looking for a partner to reproduce with. They only survive as long
as they have positive energy, and their initial energy depends on how well they solve a particular
objective function.
"""
@agent Turtle ContinuousAgent{2} begin
	genome::Vector{Char}			# Turtle's character genome
	energy::Float64					# Current energy of the Turtle
	dissonance::Float64				# Dissonance of the Turtle with its environment
	colour::Symbol					# Colour indicating turtle's energy status
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	genetic_structure()

Initialise the Genetic Structure simulation.
"""
function genetic_structure()
	pPop = 0.2								# Probability of a cell becoming populated
	width = 40								# Width of the world
	properties = Dict(
		:life_energy	=> 10.0,
		:living_cost	=> 0.1,
		:search_speed	=> 1.0,
		:mu_rate		=> 1e-3,
		:elitism		=> -1,
		:target			=> collect(
								"'Twas brillig and the slithy toves did gyre and " *
								"gimble in the wabe!"
							),
		:alphabet		=> Char.(32:122),
		:max_pop 		=> pPop*width*width,
		:mean			=> 1.0,						# Mean dissonance of population
		:sigma			=> 0.0,						# Standard deviation of dissonance
	)

	gs = ABM( Turtle, ContinuousSpace((width,width)); properties)
	genome_length = length(gs.target)
	for _ in 1:gs.max_pop/2
		θ = 2π * rand()
		lilith = add_agent!( gs, (cos(θ),sin(θ)),	# Ur-Turtle has ...
			rand( gs.alphabet, genome_length),		# Genome (candidate Vector{Char})
			1.0, 1.0,								# Provisional energy and dissonance
			:white,									# Provisional fitness type
		)
		set_fitness!( lilith, gs)					# Set lilith's fitness/colour
	end

	gs
end

#-----------------------------------------------------------------------------------------
"""
	model_step!( gs)

Calculate current mean and standard deviation dissonance to enable fitness calculations.
"""
function model_step!( gs::ABM)
	dissonances = (ag->ag.dissonance).(allagents(gs))
	gs.sigma = std(dissonances)
	gs.mean = mean(dissonances)

#	energies = (ag->ag.energy).(allagents(gs))
#	println( "$(length(energies)) agents with mean energy: $(mean(energies))")
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( turtle, gs)

One step in the life of a Turtle with genetic structure.
"""
function agent_step!( turtle::Turtle, gs)
	walk!( turtle, gs)
	give_birth( turtle, gs)
	
	if turtle.energy < 0
		kill_agent!(turtle, gs)
	end
end

#-----------------------------------------------------------------------------------------
"""
	walk!( turtle, gs)

Walk approximately forwards with speed up to the maximum, and age by one cost of living unit.
"""
function walk!( turtle::Turtle, gs)
	turn!(turtle,(rand()-0.5))
	move_agent!(turtle,gs,rand()*gs.search_speed)
	turtle.energy -= gs.living_cost * gs.life_energy
end

#-----------------------------------------------------------------------------------------
"""
	give_birth( turtle, kull)

Have a baby with similar attributes to self, but possibly genetically mutated with probability
kull.mu_rate.
"""
function give_birth( mummy::Turtle, gs)
	birth_cost = gs.living_cost * gs.life_energy
	if nagents(gs) < gs.max_pop && mummy.energy > birth_cost
		# I've got enough energy and there's sufficient space to have kids:
		daddy = random_nearby_agent(mummy,gs)
		if daddy !== nothing && daddy.energy > birth_cost
			# Let's mate! Start with crossover ...
			len = length(mummy.genome)
			xpt = rand(1:len-1)											# Crossover point
			billy = vcat(daddy.genome[1:xpt],mummy.genome[xpt+1:end])	# Baby Billy's genome
			sally = vcat(mummy.genome[1:xpt],daddy.genome[xpt+1:end])	# Baby Sally's genome

			# ... then mutate ...
			mutated_loci = rand(len).<gs.mu_rate
			billy[mutated_loci] = rand(gs.alphabet,count(mutated_loci))
			mutated_loci = rand(len).<gs.mu_rate
			sally[mutated_loci] = rand(gs.alphabet,count(mutated_loci))

			# ... construct children Billy and Sally ...
			θ,ϕ = 2π*rand(2)
			set_fitness!( add_agent!( gs, (cos(θ),sin(θ)), billy, 1.0, 1.0, :white), gs)
			set_fitness!( add_agent!( gs, (cos(ϕ),sin(ϕ)), sally, 1.0, 1.0, :white), gs)

			# ... and deplete parents:
			mummy.energy -= birth_cost
			daddy.energy -= birth_cost
		end
	end
end

#-----------------------------------------------------------------------------------------
"""
	set_fitness!( turtle, gs)

Set turtle's initial energy and its colour to reflect its Manhattan distance from gs model's
target string.
"""
function set_fitness!( turtle::Turtle, gs)
	turtle.dissonance = sum(abs.(turtle.genome - gs.target))/length(gs.target)				# Scaled Manhattan
	fitness =
		(gs.sigma==0) ? 1.0 : (gs.mean - turtle.dissonance)/(gs.sigma) - gs.elitism		# Sigma-scaling
	fitness = max(0,fitness)												# Drop lowest percentile

	turtle.energy = fitness * gs.life_energy

	if turtle.dissonance > 2.0
		turtle.colour = :black
	elseif turtle.dissonance > 1.0
		turtle.colour = :blue
	elseif turtle.dissonance > 0.5
		turtle.colour = :red
	elseif turtle.dissonance > 0.2
		turtle.colour = :orange
	else
		turtle.colour = :yellow
	end
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate a simple genetic algorithm.
"""
function demo()
	gs = genetic_structure()
	params = Dict(
		:mu_rate => 0:0.001:0.9,
		:elitism => -3:3,
	)
	plotkwargs = (
		ac=(turtle->turtle.colour),
		as=30,
		mdata = [
			(m->mean(turtle->(turtle.dissonance),allagents(m))),
			(m->minimum(turtle->(turtle.dissonance),allagents(m))),
		],
		mlabels = ["Mean dissonance","Minimum dissonance"],
	)

	playground, = abmplayground( gs, genetic_structure;
		agent_step!, model_step!, params, plotkwargs...
	)

	playground
end

end