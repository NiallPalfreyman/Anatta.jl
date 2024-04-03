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
	)
]

#-----------------------------------------------------------------------------------------
# Module methods:
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