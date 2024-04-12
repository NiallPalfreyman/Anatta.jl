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
	initial		= [0.8,0.8],					# theta, theta_dot
	parameters	= [0.0,0.2,0.694],				# alpha, beta, omega
#	parameters	= [0.52,0.2,0.694],				# alpha, beta, omega
#	parameters	= [0.6,0.1,0.694],				# alpha, beta, omega
	duration	= 30,
#	duration	= 500,
	flow		= function (du,u,p,t)
		du[1]	= u[2]
		du[2]	= p[1]*cos(p[3]*t) - p[2]*u[2] - sin(u[1])
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
#	u,t = trajectory( du, model.duration, Δt = 0.1, Ttr = 100)

	fig = Figure(fontsize=30,linewidth=3,title=model.title)
	ax = Axis(fig[1,1], title="BOTG", xlabel="time")
	lines!( t, u[:,1], label=model.variables[1])
#	lines!( t, orient.(u[:,1]), label=model.variables[1])
	lines!( t, u[:,2], label=model.variables[2])

	Axis(fig[2, 1], title="Phase plot", aspect=1,
		xlabel=model.variables[1], ylabel=model.variables[2]
	)
	lines!( u[:,1], u[:,2])
#	lines!( orient.(u[:,1]), u[:,2])
#	psect,_ = trajectory( du, model.duration, Δt = 9.0535735, Ttr = 100)
#	psect,_ = trajectory( du, 100_000, Δt = 9.0535735, Ttr = 100)
#	scatter!(orient.(psect[:,1]),psect[:,2],markersize=5)

	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end