#========================================================================================#
"""
	Pendulum

Module Pendulum: Here we simulate the transition into chaos of a driven pendulum.

Author: Niall Palfreyman, 26/03/2024
"""
module Pendulum

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	model

Model of a driven, damped pendulum.
"""
const model = (
	title		= "Archie",
	variables	= ["theta","theta_dot"],
	initial		= [0.0,1.0],					# theta, theta_dot
	parameters	= [0.0,0.0,0.694],				# alpha, beta, omega
	duration	= 10,
	flow		= function (du,u,p,t)
		du[1]	= u[2]
		du[2]	= -u[1]
		nothing
	end
)

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	orient()

Convert a general angle to the range (-pi,pi]
"""
function orient( angle::Real=0.0)
	mod(angle + pi, 2pi) - pi
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate how to run the model.
"""
function demo()
	du = CoupledODEs(model.flow,model.initial,model.parameters)
	u,t = trajectory( du, model.duration, Δt = 0.1)

	fig = Figure(fontsize=30,linewidth=5,title=model.title)
	ax = Axis(fig[1,1], title="BOTG", xlabel="time")
	lines!( t, u[:,1], label=model.variables[1])
	lines!( t, u[:,2], label=model.variables[2])

	Axis(fig[2, 1], title="Phase plot",
		xlabel=model.variables[1], ylabel=model.variables[2],
		aspect=1
	)
	scatterlines!( u[:,1], u[:,2])

	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end