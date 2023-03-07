#========================================================================================#
#	Laboratory 505
#
# Flows
#
# Author: Niall Palfreyman (24/04/2022), Dominik Pfister (July 2022)
#========================================================================================#
[
	Activity(
		"""
		Lab 505: Flows.

		This lab focuses on the diffusion and evaporation of a resource "poo" in the environment.
		This poo is produced and consumed by a single turtle that moves around the world, and
		it also diffuses and evaporates. In biology, such flows provide the topological structure
		that guides the development of organism and their behaviours.

		Run the module Flows now and explore the effect of varying the rates of diffusion (dPoo)
		and evaporation (αPoo). What diffusion rate enables you to draw stable lines in the
		environment? 
		""",
		"",
		x -> x==0
	),
	Activity(
		"""
		Can you find diffusion and evaporation rates that generate a movement like a comet and tail
		around the world?
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Can you find diffusion and evaporation rates that generate a relatively stable and even
		distribution of poo across the entire world?
		""",
		"",
		x -> true
	),
	Activity(
		"""
		When ants forage for food, they wander out from the nest in random directions, leaving a
		persistent pheromone trail P that tells them how to return home to the nest. If the search
		takes too long, the ant returns to the nest to feed before going out again to forage. If
		the ant discovers a food source, she carries some back to the nest, while leaving a trail
		of a second (food) pheromone F. Other ants that discover this F-trail follow it to the
		food source and fetch food to the nest, again leaving a trail of F. Over time, the ant
		colony will develop a highly efficient (i.e. straight) communal F-trail between nest and
		food source.

		If we built an ABM of this ant-foraging system, what might be suitable outcome-patterns
		for testing the validity of the model?
		""",
		"What emerging patterns would indicate that your ant-agents are behaving correctly?",
		x -> occursin("straight",lowercase(x)) && occursin("trail",lowercase(x))
	),
	Activity(
		"""
		Develop your own ABM of ant foraging to discover what behaviours are required by ants in
		order for them to construct this efficient route.

		IMPORTANT: Nature is always parsimonious! Simplicity and modularity are crucial features
		of any successful ABM. Make sure that your model is as simple and as modular as possible
		in order to achieve the required behaviour.
		""",
		"",
		x -> true
	),
]