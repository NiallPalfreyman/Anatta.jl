#========================================================================================#
"""
	CellularCognition

Module CellularCognition: This module develops a simple Michaelis-Menten model of lactose
breakdown into a Hill model of genetic regulation.

Author: Niall Palfreyman, 03/04/2024
"""
module CellularCognition

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

An array of models successively developed into a Hill model of genetic switching.
"""
const model = [
	KineticModel(
		"Lactose breakdown",							# Title
		["G_Y", "X", "X-G_Y", "Y"],						# Variables
		[0.5,    8.0, 0.0,    0.0],						# Initial values
		[2.0, 1.0, 1.5],								# Parameters kfwd, kbwd, kcat
		function (du,u,p,t)								# Flow rule ...
			xgy_formation = p[1]*u[1]*u[2] - p[2]*u[3]	# Binding rate - dissociation rate
			y_catalysis = p[3] * u[3]					# Catalytic conversion rate
			du[1] = -xgy_formation + y_catalysis
			du[2] = -xgy_formation
			du[3] =  xgy_formation - y_catalysis
			du[4] =  y_catalysis
			nothing
		end,
		5												# Duration
	),
	KineticModel(
		"GFP",											# Title
		["A", "B", "C"],								# Variables
		[1.0, 0.0, 0.0],								# Initial values
#		[0.1, 1.0, -2.0, 3.0],							# Parameters alpha, beta, K, n
		[0.5, 1.0, -2.0, 3.0],							# Damped oscillations
#		[0.01, 1.0, -2.0, 3.0],							# High amplitude oscillations
#		[0.0001, 1.0, -2.0, 3.0],						# Catastrophe
#		[0.01, 1.0, -2.0, 1.0],							# No oscillation
		function (du,u,p,t)								# Flow rule ...
			a,b,c = u
			α,β,K,n = p
			du[1] = β*hill( c, K, n) - α*a
			du[2] = β*hill( a, K, n) - α*b
			du[3] = β*hill( b, K, n) - α*c
			nothing
		end,
		100												# Duration
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