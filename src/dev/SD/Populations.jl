#========================================================================================#
"""
	Populations

Module Populations: This module demonstrates how to simulate the interactions between different
populations.

Author: Niall Palfreyman, 18/03/2024
"""
module Populations

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	model

An array of population models.
"""
const model = [
	(
		title		= "Logistic",
		variables	= ["x"],
		initial		= [0.01],						# Population x
		parameters	= [0.2,50],						# r, K
		duration	= 20,
		flow		= function (du,u,p,t)
			du[1] = p[1] * u[1] * (1-u[1]/p[2])		# Logistic growth equation
			nothing
		end
	),
	(
		title		= "Kermack-McKendrick",
		variables	= ["S","I","R"],
		initial		= [2_000.0,20.0,2.0],
		parameters	= [7e-4,12e-3,0.5,70.0],		# a, b, c, lifespan
													# Australia: b=12/1000; Nigeria: b=36/1000
		duration	= 500,
		flow		= function (du,u,p,t)
			birth		= p[2]*u[1]
			infection	= p[1]*u[1]*u[2]
			removal		= p[3]*u[2]
			death		= u[3]/p[4]
			du[1]		= birth - infection
			du[2]		= infection - removal
			du[3]		= removal - death
			nothing
		end
	),
	(
		title		= "Holling-Tanner",
		variables	= ["x"],
		initial		= [0.01],						# Population x
		parameters	= [0.2,50],						# alpha, K
		duration	= 20,
		flow		= function (du,u,p,t)
			du[1] = p[1] * u[1] * (1-u[1]/p[2])		# Logistic growth equation
			nothing
		end
	)
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate how to run the model.
"""
function demo( m::Int=1)
	u,t = trajectory(
		CoupledODEs(model[m].flow,model[m].initial,model[m].parameters),
		model[m].duration,
		Δt = 0.1
	)

	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title=model[m].title)
	for variable in 1:N
		lines!( t, u[:,variable], label=model[m].variables[variable])
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end