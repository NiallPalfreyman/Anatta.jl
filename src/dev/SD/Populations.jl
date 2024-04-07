#========================================================================================#
"""
	Populations

Module Populations: This module demonstrates how to simulate the interactions between different
populations.

Author: Niall Palfreyman, 18/03/2024
"""
module Populations

using DynamicalSystems, GLMakie, Observables

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
		duration	= 100,
		flow		= function (du,u,p,t)
			du[1] = p[1] * u[1] * (1 - u[1]/p[2])	# Logistic growth equation
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
		variables	= ["x", "y", "N"],
		initial		= [0.1, 0.1, 2.5],				# Population x, y and N
		parameters	= [1.0,0.2,7.0,6/7,1.0],		# r1, r2, k, w, d
		duration	= 50,
		flow		= function (du,u,p,t)
			prey_growth = p[1]*u[1]*(1 - u[1]/p[3])
			predator_growth = p[2]*u[2]*(1 - u[3]*u[2]/u[1])
			saturated_predation = p[4]*u[1]*u[2]/(p[5] + u[1])
			du[1] = prey_growth - saturated_predation
			du[2] = predator_growth
			nothing
		end
	)
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo( m)

Demonstrate how to run the m-th model.
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

#-----------------------------------------------------------------------------------------
"""
	holling()

Traverse the Holling-Tanner bifurcation in N.
"""
function holling()
	ht = model[3]
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="x", ylabel="y", title=ht.title)
	limits!( ax, 0, 7, 0, 6)

	# Set up and run animation:
	for N in 2.5:-0.05:0.5
		empty!(ax)
		for x in [0.5,7.0], y in 0.5:1.0:5.5
			u,_ = trajectory( CoupledODEs(ht.flow,[x,y,N],ht.parameters), 50, Δt = 0.1)
			lines!( u[:,1], u[:,2])
		end
		for x in 1.0:1.0:7.0, y in [0.5,5.5]
			u,_ = trajectory( CoupledODEs(ht.flow,[x,y,N],ht.parameters), 50, Δt = 0.1)
			lines!( u[:,1], u[:,2])
		end
		for x in 0.5:0.5:2.0, y in 2.0:0.5:3.0
			u,_ = trajectory( CoupledODEs(ht.flow,[x,y,N],ht.parameters), 50, Δt = 0.1)
			lines!( u[:,1], u[:,2])
		end
		text!( string( "N = ", N), position=(5.0,5.0), fontsize=30, align=(:left,:center))
		display(fig)
		sleep(0.1)
	end

	nothing
end

end