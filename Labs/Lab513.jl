#========================================================================================#
#	Laboratory 513
#
# Niche-construction and ant algorithms
#
# Author: Niall Palfreyman (April 2023).
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 513: Selection of flows that focus problem-solving behaviour.

		In this simulation, a colony of ants forages for food. Although each ant follows a set of
		simple rules, the colony as a whole acts in an emergent, goal-oriented way. This
		implementation is derived from:
			Uri Wilensky (1997). http://ccl.northwestern.edu/netlogo/models/Ants

		When an ant finds a food source, it carries food, following a nest_pheromone back to the
		nest, and secreting a carry_pheromone along the route. When other ants smell the pheromone,
		they follow it towards the food. As more ants carry food to the nest, they reinforce the
		pheromone trail.

		Run the simulation now - you will see a black nest in the middle and three green food
		sources of varying capacity and distance from the nest. Pheromone is displayed in a
		black-blue-white gradient.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		As you see, the colony usually chooses to exploit the food source in the lower half of the
		world. Which food source property causes the ants to prefer this source over the one on the
		left-hand side of the world?
		""",
		"Move your mouse cursor over the food sources to find out their properties",
		x -> occursin("capacity",lowercase(x))
	),
	Activity(
		"""
		Which aspect of the food source in the upper-right corner of the world causes the ants to
		(usually) decide against it, even though its capacity equals that of the lower source?
		""",
		"Think about what happens to the carry_pheromone trail after the ant has moved on",
		x -> occursin("capacity",lowercase(x))
	),
	Activity(
		"""
		You can change several values here - let's start with the diffusion and evaporation rates
		of the carry-pheromone. Which of these two can you change to make the colony more decisive
		in its preferred choice of food source?
		""",
		"Move each slider individually a little higher or a little lower to investigate them",
		x -> occursin("diff",lowercase(x))
	),
	Activity(
		"""
		Investigate what happens to the ants' behaviour if you lower or raise the evaporation rate
		of the carry_pheromone. Can you explain each of these different behaviours?
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Now increase the capacity of the upper-right food source to 4.0. Does this raise or lower
		the likelihood that the colony will choose to exploit it?
		""",
		"",
		x -> occursin("rais",lowercase(x))
	),
	Activity(
		"""
		The ant colony generally chooses the food source that can most easily be exploited, either
		because it is closer, or because its capapcity is high. It is more difficult for the ants
		to form a stable trail to more distant or low-capacity food, since the chemical trail has
		more time to evaporate and diffuse before being reinforced.
		
		Try different placements for the food sources. What happens if two food sources of equal
		capacity are equally far from the nest? When that happens in the real world, ant colonies
		typically exploit one source then the other (not at the same time). Is that true in our
		simulation?
		""",
		"",
		x -> occursin('y',lowercase(x))
	),
	Activity(
		"""
		The ants only respond to chemical levels between the tolerance levels 0.05 and 2. The
		lower bound makes sure the ants aren't infinitely sensitive. Try removing this lower
		bound - what happens? Can you explain it?
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Now try instead removing the upper bound (2.0). What happens? Can you explain this?
		""",
		"",
		x -> true
	),
	Activity(
		"""
		This simulation is a good example of how to include several different types of agent
		within one model. Julia offers multiple dispatch as a particularly useful way of handling
		these various agent types. Find the place in the simulation where I make heavy use of
		multiple dispatch for this purpose. What is the name of the first method in this sequence
		of polymorphic functions?
		""",
		"",
		x -> occursin("ashape",lowercase(x))
	),
	Activity(
		"""
		When our ants are following either pheromone (nest or carrying), they use a technique
		called "tumbling" that is also used by bacteria. That is, when they notice that the
		pheromone concentration ahead is lower than where they are, they simply change direction
		randomly.
		
		However, real ants are capable of more intelligent trail-following: they 'sniff' ahead,
		ahead-left and ahead-right, then choose the highest concentration amongst these three
		directions. Implement this more realistic trail-following technique, remembering that you
		will need to use it twice for following the two different pheromone trails.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		In our simulation, the ants find their way back to the nest by following the nest_pheromone.
		Real ants use a variety of different approaches to find their way back to the nest. Look up
		how these alternative strategies work - it is important to know when it is useful or
		unuseful to simplify real-world methods.
		""",
		"",
		x -> true
	),
]