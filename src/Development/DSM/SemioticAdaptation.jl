#========================================================================================#
"""
	Semiotic Adaptation

A simulation to evaluate Kull's proposal that development, rather than mutation,
drives evolution.
	
Author: Niall Palfreyman (March 2023), Emilio Borrelli (May 2022).
"""
module SemioticAdaptation

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Turtle

Turtles chase around the world looking for food. They cannot survive without it, but all food is
concentrated within tiny feeding discs centred on integer-valued locations. In order to survive,
turtles must first learn to stop within one of these discs to feed. This learning occurs both
genetically and developmentally (model reaction_norm modifies their relationship).
"""
@agent Turtle ContinuousAgent{2} begin
	energy::Float64							# Current energy of the Turtle
	sniffing::Bool							# Is Turtle currently stationary: sniffing for food?
	feeding::Bool							# Is the Turtle currently feeding: gaining energy?
	genetic_radius::Float64					# Genetic determinant of feeding radius
	develop_radius::Float64					# Phenotypically developed feeding radius
	exploitation::Symbol					# How effectively does phenotype exploit resources?
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	semiotic_adaptation()

Initialise the Semiotic Adaptation simulation.
"""
function semiotic_adaptation(;
	life_energy		= 10.0,
	birth_cost		= 0.7,					# 0.5
	living_cost		= 0.1,
	food_benefit	= 3.0,					# 0.09
	search_speed	= 1.0,
	mu_rate			= 0.05,
	mu_extent		= 0.1,
	feeding_radius	= 1e-5,
	reaction_norm	= 0.2,					# 0.5
)
	pPop = 0.2								# Probability of a cell becoming populated
	width = 40								# Width of the world

	properties = Dict(
		:life_energy => life_energy,
		:birth_cost => birth_cost,
		:living_cost => living_cost,
		:food_benefit => food_benefit,
		:search_speed => search_speed,
		:mu_rate => mu_rate,
		:mu_extent => mu_extent,
		:feeding_radius => feeding_radius,
		:reaction_norm => reaction_norm,
		:max_pop => pPop*width*width,
	)

	kull = ABM( Turtle, ContinuousSpace((width,width)); properties, scheduler=Schedulers.randomly)

	for _ in 1:properties[:max_pop]
		θ = 2π * rand()
		search_radius = rand()
		lilith = add_agent!( kull, (cos(θ),sin(θ)),		# Ur-Turtle has ...
			rand()*life_energy,							# Random initial energy up to maximum
			false, false,								# Not (yet) sniffing or feeding
			search_radius, search_radius,				# equal genetic and developmental radius
			:white,										# temporary exploitation
		)
		set_exploitation!(lilith,kull)
	end

	kull
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( turtle, kull)

One step in the life of a Turtle in Kull's model of semiotic adaptation.
"""
function agent_step!( turtle::Turtle, kull)
	walk!( turtle, kull)
	feed!( turtle, kull)
	give_birth( turtle, kull)
	
	if turtle.energy < 0
		kill_agent!(turtle, kull)
	end
end

#-----------------------------------------------------------------------------------------
"""
	walk!( turtle, kull)

Unless turtle is feeding, walk approximately forwards with speed up to the maximum specified by
the model parameter search_speed. Age by one energy unit.
"""
function walk!( turtle::Turtle, kull)
	if !turtle.feeding
		turn!(turtle,(rand()-0.5))
		move_agent!(turtle,kull,rand()*kull.search_speed)
	end
	turtle.energy -= kull.living_cost * kull.life_energy
end

#-----------------------------------------------------------------------------------------
"""
	feed( turtle, kull)

If turtle is within its own develop_radius of the world's centre, stay here sniffing, but only
gain food energy benefit if it is withing model feeding_radius.
"""
function feed!( turtle::Turtle, kull)
	if !turtle.sniffing
		# Still moving - check if I'm within my developmental search radius of a food source:
		d = food_proximity(turtle.pos)
		if d < turtle.develop_radius
			# Stop inside developmental search radius from feeding position:
			turtle.sniffing = true
			if d <= kull.feeding_radius
				# I'm also inside the food radius - I actually get something to eat!
				turtle.feeding = true
			end
		end
	end
	if turtle.feeding
		turtle.energy += kull.food_benefit * kull.life_energy
	end
end

#-----------------------------------------------------------------------------------------
"""
	give_birth( turtle, kull)

Have a baby with similar attributes to self, but possibly genetically mutated with probability
kull.mu_rate.
"""
function give_birth( turtle::Turtle, kull)
	if turtle.energy > kull.birth_cost*kull.life_energy && nagents(kull) < kull.max_pop
		# I've got enough energy and there's sufficient space to have kids:
		θ = 2π * rand()
		baby = add_agent!( kull,					# Create baby Turtle with ...
			(cos(θ),sin(θ)),						# new heading
			kull.life_energy,						# full life energy
			false, false,							# not (yet) sniffing or feeding
			turtle.genetic_radius,					# parental genetic_radius (provisional)
			turtle.genetic_radius,					# parental genetic_radius (provisional)
			turtle.exploitation,					# parental exploitation (provisional)
		)

		if rand() < kull.mu_rate
			# Baby mutates parental genetic_radius (clamped at width of world):
			baby.genetic_radius += (2rand()-1) * kull.mu_extent * baby.genetic_radius
			baby.genetic_radius = clamp( baby.genetic_radius, 0.0, 1.0)
		end

		if kull.reaction_norm == 0.0
			# Baby has no developmental plasticity:
			baby.develop_radius = baby.genetic_radius
		elseif kull.reaction_norm == 1.0
			# Baby has no genetic determination:
			baby.develop_radius = rand()
		else
			# Environmental factors distribute baby's development normally from genetic_radius:
			baby.develop_radius = baby.genetic_radius * (1 + randn()*kull.reaction_norm)
			baby.develop_radius = clamp( baby.develop_radius, 0, 1)
		end

		# Mark visually the quality of baby's exploitation of food resources:
		set_exploitation!( baby, kull)
		turtle.energy -= kull.birth_cost*kull.life_energy			# Post-partum exhaustion :)
	end
end

#-----------------------------------------------------------------------------------------
"""
	set_exploitation!( turtle, kull)

Set turtle's colour to indicate its quality of food exploitation, as measuree by the radius
it uses to assess the presence of food resources.
"""
function set_exploitation!( turtle::Turtle, kull)
	if turtle.genetic_radius < kull.feeding_radius
		turtle.exploitation = :lime							# Genetically secured exploitation
	elseif turtle.develop_radius < kull.feeding_radius
		turtle.exploitation = :orange						# Purely developmental exploitation
	elseif turtle.develop_radius < 5kull.feeding_radius
		turtle.exploitation = :blue							# Moderate developmental exploitation
	else
		turtle.exploitation = :black						# Really crappy exploitation
	end
end

#-----------------------------------------------------------------------------------------
"""
	food_proximity( pos)

Calculate distance of current pos from nearest feeding position on integer-valued coordinates.
"""
function food_proximity( pos::Tuple)
	sqrt( sum((pos .- round.(pos)).^2))
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate Kull's SemioticAdaptation process.
"""
function demo()
	kull = semiotic_adaptation()
	params = Dict(
		:feeding_radius => 1e-5:1e-5:1e-3,
		:reaction_norm => 0:0.01:1,
		:food_benefit => 0:0.1:5.0,
	)
	plotkwargs = (
		ac=(turtle->turtle.exploitation),
		as=30,
		mdata = [
			(m->count(ag->(ag.genetic_radius<m.feeding_radius),allagents(m))),
			(m->count(ag->(ag.develop_radius<m.feeding_radius),allagents(m))),
		],
		mlabels = ["Genetic success","Developmental success"],
	)

	playground, = abmplayground( kull, semiotic_adaptation;
		agent_step!, params, plotkwargs...
	)

	playground
end

end