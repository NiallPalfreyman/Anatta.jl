#========================================================================================#
"""
	Multistability

Module Multistability: This module models two systems - the Griffith switch and spruce-
budworm dynamics.

Author: Niall Palfreyman, 18/04/2024
"""
module Multistability

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	KineticModel

A KineticModel represents one way of modelling the kinetics of a chemical reaction.
"""
struct KineticModel
	title::String						# Title of this model
	variables::Vector{String}			# Names(s) of the phase variables
	initial::Vector{Float64}			# Initial values of the phase variables
	parameters::Vector{Float64}			# Dynamical parameters for this model
	flow::Function						# Dynamical flow rule for this model
	duration::Float64					# Duration of simulation
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	model

An array of models relating to multistability.
"""
const model = [
	KineticModel(
		"Griffith switch",								# Title
		["Protein","RNA"],								# Stock names
		[0.1,0.1],										# Example: Griffith switch (αP_c = 1/2αR)
		[0.2,2.0],										# αP: P breakdown; αR: RNA breakdown rate
		function (du,u,p,t)								# Flow rule ...
			P,R = u
			αP,αR = p
			injection = (abs(t-10)<1) ? 0.4 : 0.0		# Micro-inject P around t=10

			du[1] = R - αP*P + injection				# RNA expresses P, which then breaks down
			du[2] = hill(P,1,2) - αR*R					# P up-regulates RNA, which also degrades
			nothing
		end,
		60												# Duration
	),
	KineticModel(
		"Spruce-budworm dynamics",						# Title
		["Protein","RNA"],								# Stock names
		[0.1,0.1],										# Example: Griffith switch (αP_c = 1/2αR)
		[0.2,2.0],										# αP: P breakdown; αR: RNA breakdown rate
		function (du,u,p,t)								# Flow rule ...
			P,R = u
			αP,αR = p
			injection = (abs(t-10)<1) ? 0.4 : 0.0		# Micro-inject P around t=10

			du[1] = R - αP*P + injection				# RNA expresses P, which then breaks down
			du[2] = hill(P,1,2) - αR*R					# P up-regulates RNA, which also degrades
			nothing
		end,
		60												# Duration
	),
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	hill( s::Real, K=1.0, n=1.0)

Return the Hill saturation function corresponding to a signal s, half-response K and cooperation n.
"""
function hill( s, K::Real=1.0, n::Real=1.0)
	if K == 0
		return 0.5
	end

	abs_K = abs(K)
	if n != 1
		n = float(n)
		abs_K = abs_K^n
		s = s.^n
	end

	abs_hill = abs_K ./ (abs_K .+ s)
	
	K < 0 ? abs_hill : 1 - abs_hill
end

#-----------------------------------------------------------------------------------------
"""
	demo( n=1)

Run the n-th kinetic model.
"""
function demo( n=1)
	u,t = trajectory(
		CoupledODEs(model[n].flow,model[n].initial,model[n].parameters),
		model[n].duration,
		Δt = 0.05
	)

	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title=model[n].title)
	for i in 1:N
		lines!( t, u[:,i], label=model[n].variables[i])
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end