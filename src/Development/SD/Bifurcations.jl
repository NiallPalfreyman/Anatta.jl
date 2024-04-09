#========================================================================================#
"""
	Bifurcations

Demonstrate a variety of types of bifurcation.

Author: Niall Palfreyman, 05/04/2024.
"""
module Bifurcations

using GLMakie, DynamicalSystems

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	BifurcationModel

A BifurcationModel is a dynamical model that exhibits a particular type of bifurcation.
"""
struct BifurcationModel
	title::String						# Title of this model
	polar::Bool							# Cartesian or polar coordinates?
	initial::Vector{AbstractRange}		# Ranges of initial values of the phase variables
	parameters::AbstractRange			# Range of dynamical parameter for this model
	flow::Function						# Dynamical flow rule for this model
	duration::Float64					# Duration of simulation
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	bifurcation

An array of models demonstrating specific examples of bifurcation.
"""
const bifurcation = [
	BifurcationModel(
		"Saddle-node",								# Title
		false,										# Coordinate type
		[-1.5:0.25:2.0,-1.0:0.25:1.0],				# Initial values
		1.0:-0.05:-1.0,								# Parameter mu
		function (du,u,p,t)							# Flow rule ...
			du[1] = p[1] - u[1]^2
			du[2] = -u[2]
			nothing
		end,
		0.5											# Duration
	),
	BifurcationModel(
		"Transcritical",							# Title
		false,										# Coordinate type
		[-1.5:0.25:2.0,-1.0:0.25:1.0],				# Initial values
		-1.0:0.05:1.0,								# Parameter mu
		function (du,u,p,t)							# Flow rule ...
			du[1] = p[1]*u[1] - u[1]^2
			du[2] = -u[2]
			nothing
		end,
		0.5											# Duration
	),
	BifurcationModel(
		"Pitchfork",								# Title
		false,										# Coordinate type
		[-1.5:0.25:2.0,-1.0:0.25:1.0],				# Initial values
		-1.0:0.05:1.0,								# Parameter mu
		function (du,u,p,t)							# Flow rule ...
			du[1] = p[1]*u[1] - u[1]^3
			du[2] = -u[2]
			nothing
		end,
		0.5											# Duration
	),
	BifurcationModel(
		"Soft Hopf",								# Title
		true,										# Coordinate type
		[0.0:0.25:3.0,0.0:pi/6:2pi],				# Initial values
		-1.0:0.05:1.0,								# Parameter mu
		function (du,u,p,t)							# Flow rule ...
			du[1] = u[1]*(p[1] - u[1]^2)
			du[2] = 1
			nothing
		end,
		2.0											# Duration
	)
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo( n=1)

Run the n-th bifurcation model.
"""
function demo( n=1)
	bif = bifurcation[n]
	title = bif.title*" bifurcation; mu = "
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="x", ylabel="y",	title = string(title, first(bif.parameters)))

	if bif.polar
		lim = last(bif.initial[1])
		limits!( ax, -lim, lim, -lim, lim)
		ax.aspect = AxisAspect(1)
	else
		limits!( ax, first(bif.initial[1]), last(bif.initial[1]),
			first(bif.initial[2]), last(bif.initial[2])
		)
	end

	# Set up and run animation:
	for mu in bif.parameters
		empty!(ax)
		ax.title = string(title, mu)
		for x1 in bif.initial[1], x2 in bif.initial[2]
			u,_ = trajectory( CoupledODEs(bif.flow,[x1,x2],[mu]), bif.duration, Δt = 0.1)

			# Prepare polar or cartesian coordinates for plotting:
			if bif.polar
				x, y = (u[:,1].*cos.(u[:,2]),  u[:,1].*sin.(u[:,2]))
			else
				x, y = (u[:,1], u[:,2])
			end
			lines!( x, y)
			scatter!( [x[end]], [y[end]], markersize=20)
		end
		display(fig)
		sleep(1)
	end

	nothing
end

end