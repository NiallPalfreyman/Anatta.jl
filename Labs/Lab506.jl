#========================================================================================#
#	Laboratory 506
#
# Neutral drift.
#
# Author: Niall Palfreyman (March 2023) and Nick Diercksen (July 2022)
#========================================================================================#
[
	Activity(
		"""
		Welcome to Lab 506: Neutral Drift.

		Neutral drift is the tendency of genetic structure to mutate randomly, even in conditions
		where there is no strong selection pressure from the environment.

		For example, suppose that a particular tribe happens to move to an iron-rich environment
		which makes them grow taller, giving them the selective advantage of being able to reach
		higher-hanging fruit. Of course, if the tribe moves away to an iron-poor environment,
		individuals will no longer have this advantage. However, while they live in the iron-rich
		environment, neutral drift will continue, and competition between individuals will tend to
		favour those individuals that are RELIABLY taller. Consequently, over generations, other
		phenotypic traits will be selected that maintain tallness even when individuals absorb less
		iron from their environment:
			Neutral drift can genetically fix a trait that is induced by the environment!

		Neutral drift of genetic structure therefore plays a hugely important role in evolution. If
		evolutionary change is a ratchet that moves towards increased fitness, neutral drift is the
		pawl that prevents this ratchet from going back to previous, lower-fitness states. Neutral
		drift is the ability of evolutionary systems to cement random variations into a CHOICE.

		Let's look at this now. Run the module NeutralDrift several times and observe its dynamics.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		What you have observed is called a Moran Process: many agents exchange individual decisions
		until they collectively make an irreversible choice. We can interpret this Moran process in
		three different ways - evolutionarily, developmentally or socially:
			-	EVOLUTIONARILY, altruism is genetically determined. Agents have a random genetic
				tendency to act altruistically. In each generation, agents die and are replaced by
				a random nearby individual. They therefore tend to be replaced by the most frequent
				phenotype in their reproductive neighbourhood.
			-	DEVELOPMENTALLY, altruism is physiologically determined. Cells within an organism
				have a random tendency to support altruistic behaviours of the organism. During
				development, cells communicate and modify each others' developmental state. They
				therefore tend to adopt the most common developmental fate in their neighbourhood.
			-	SOCIALLY, altruism is culturally determined. Agents have a random cultural tendency
				to act altruistically. At each moment, agents adopt opinions and behaviours from
				nearby individuals. Over time, they therefore tend to adopt the most common
				behaviour in their social neighbourhood.

		Run NeutralDrift again and estimate how frequently the population makes the decision for
		altruism.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Notice that this decision is NOT deterministic - it can go either way, and the system can
		take quite a while to make the decision.

		Now run NeutralDrift again, but this time raise the cost of altruism. How much cost do you
		need in order to make the population choose consistently against altruistic behaviour?
		""",
		"",
		x -> (3e-5 ≤ x ≤ 5e-5)
	),
	Activity(
		"""
		As you can see, this Moran choosing process is very unstable! Even a cost of just 0.00003
		is sufficient to definitely bias the choice. Nevertheless, this choosing process has all
		the components of biological choice: it is made by the entire system (not just individual
		components), it is not deterministic, but it is also not pure chance. The choice emerges
		from the actions of the entire system.

		The NeutralDrift model is also known in social science as a SCHELLING model, demonstrating
		how populations choose to adopt new technologies and ideas. In this interpretation,
		altruism is an opinion that either spreads through a society or else dies out.

		Now position the agents into two blocks: agents on the left-hand side of the world are all
		altruistic and all agents on the right-hand side are not. Use this configuration to test
		the extent to which spatial configurations influence the choosing process.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Here is another experiment for you to perform. We currently have 2 classes of altruism:
		altruist or not altruist. What happens if we permit different levels of altruism - for
		example [0,0.5,1]? Does the model still make decisions? What if you allow even more levels
		of altruism - 4,5,...?

		Note: You may find it useful to use the following agent colour function:
			acolour( mn::Moran) = spectrum[Int(ceil(mn.altruist*length(spectrum)))]
		""",
		"",
		x -> true
	),
]