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

Model of a simple logistic population.
"""
const model = (
	title		= "Populations",
	variables	= ["x"],
	initial		= [0.01],						# Population x
	parameters	= [0.2,50],						# r, K
	duration	= 20,
	flow		= function (du,u,p,t)
		du[1] = p[1] * u[1] * (1-u[1]/p[2])		# Logistic growth equation
		nothing
	end
)

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate how to run the model.
"""
function demo()
	u,t = trajectory(
		CoupledODEs(model.flow,model.initial,model.parameters),
		model.duration,
		Δt = 0.1
	)

	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title=model.title)
	for variable in 1:N
		lines!( t, u[:,variable], label=model.variables[variable])
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end