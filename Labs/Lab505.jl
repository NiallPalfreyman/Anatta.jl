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
		happening. Now set wm.dt to a more reasonable value of 0.1, and instead use the "sleep"
		slider to slow down the simulation to a speed that you can view comfortably.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Bragg's formula for interference maxima from crystal structures states that:
			n λ = d sin(θ_n) ,
		
		where n is the order of the interference maximum, λ is the wavelength of the waves, d is
		the spacing between the sources and θ_n is the angle between the maxima and a normal to
		the line through the sources. Vary the values of n, λ, d and θ_n to test the validity of
		Bragg's formula.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		Diffraction from crystals is much more clearly defined than our 2-source model, because a
		row of n equally spaced sources sharpens the pattern. Verify this by creating a model
		containing several equally-spaced sources and viewing the resulting interference pattern.
		""",
		"",
		x -> true
	),
	Activity(
		"""
		If you study the method model_step!(), you will see it simulates wave behaviour by using
		Euler's method with two dynamical equations for the phase variables E and B (electric
		and magnetic field). In fact, model_step!() develops a numerical solution of the wave
		equation:
			d^2E/dt^2 = c^2 * ∂^2(E)/∂^2

		As you can see, the spatial curvature on the right-hand side of wave equation specifies not
		the rate of change of E, but instead the acceleration of E (the SECOND time derivative of E).
		This means that the wave always overshoots and 'swings back' to its neutral position,
		creating the oscillatory motion of a wave.
		
		The wave equation is very similar to the heat equation, which describes the flow of
		temperature through a medium:
			dE/dt = c^2 * ∂^2(E)/∂^2

		However, in the heat equation, the spatial curvature of temperature specifies directly the
		rate of change of E, so there is no more overshoot, but just heat flow. Change my model to
		a model of heat flow by modifying line 108 of WaveDynamics.jl.

		""",
		"I suggest that you make a copy of line 108, so you can reverse your change afterwards!",
		x -> true
	),
	Activity(
		"""
		Can you find a way of implementing constant flux boundary conditions, in which the waves
		simply pass out of the edge of the model and disappear? The Agents package offers a way of
		specifying nonperiodic boundary conditions, but you will need a little extra work to make
		sure the waves behave appropriately close to the boundary.

		Remember: Always use SIMPLE, ELEGANT solutions!
		""",
		"",
		x -> true
	),
]