#========================================================================================#
#	Laboratory 505
#
# Flow dynamics, wave sources and pedagogical simulation.
#
# Author: Niall Palfreyman (7/3/2023)
#========================================================================================#
[
	Activity(
		"""
		Lab 505: Flow dynamics and pedagogical simulation.

		Flows are not only produced and utilised by agents; they also possess their own dynamics.
		In fact, ALL biological systems contain two essential features: An agent structure that
		generates and consumes flows LOCALLY, and a set of dynamical flows that interact NONLOCALLY
		and influence the changes of state of the agent structure. The structures may be organisms,
		cells, neurons or genomes, and the flows may be food resources, cell-signalling proteins,
		neurotransmitters or genetic transcription factors.

		In this lab, we first model the nonlocal flow dynamics of wave phenomena, then we look at
		how we can use this model to demonstrate a process that beginning students often find
		difficult to visualise. This pedagogical use of agent-based simulation has become
		increasingly important in computer-aided instruction applications.
		
		Run the module WaveDynamics. What is the correct name for the interaction that you observe
		between the two sets of waves?
		""",
		"",
		x -> occursin("interference",lowercase(x))
	),
	Activity(
		"""
		I have used the parameter "attenuation" to ensure that the wave pattern is not complicated
		by waves that flow over the edge of the model's world. Adjust the value of attenuation to
		notice its effect on the pattern, and then return it to its original value.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		I have set the value of wm.dt to 0.001 to slow down the simulation and let you see what is
		happening. Set the value now to a more reasonable one of 0.1, then use the "sleep" slider
		to slow down the simulation to a comfortable level.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Bragg's formula for interference maxima states that:
			n λ = d sin(θ_n) ,
		
		where n is the order of the interference maximum, λ is the wavelength of the waves, d is
		the spacing between the sources and θ_n is the angle between the maxima and a normal to
		the line through the sources. ???
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Experiment with other source configurations
		""",
		"",
		x -> true
	),
	Activity(
		"""
		??? Study how the wave equation works (in model_step!)
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Implement stonewalling at boundary?
		""",
		"",
		x -> true
	),
	Activity(
		"""
		""",
		"",
		x -> true
	),
	Activity(
		"""
		""",
		"",
		x -> true
	),
	Activity(
		"""
		""",
		"",
		x -> true
	),
	Activity(
		"""
		""",
		"",
		x -> true
	),
	Activity(
		"""
		""",
		"",
		x -> true
	),
]