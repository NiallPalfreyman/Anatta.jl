#========================================================================================#
"""
	ReactionKinetics

Module ReactionKinetics: This module demonstrates a simple one-step chemical reaction in
which Na and Cl combine to form NaCl.

Author: Niall Palfreyman, 07/03/2024
"""
module ReactionKinetics

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
const model = (
	title		= "Salt formation",
	variables	= ["Na","Cl","NaCl"],
	duration	= 60,
	initial		= [0.0,0.0,0.0],				# Na, Cl, NaCl
	parameters	= [0.0],						# Reaction constant k
	flow		= function (du,u,p,t)
		reaction_rate = p[1] * u[1] * u[2]		# Simple, one-step reaction
		du[1] = -reaction_rate					# Na decreases
		du[2] = -reaction_rate					# Cl decreases
		du[3] =  reaction_rate					# NaCl increases
		nothing
	end
)

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstration of the six SD behavioural archetypes.
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