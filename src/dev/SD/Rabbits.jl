#========================================================================================#
"""
	Rabbits

Module Rabbits: This module demonstrates how to use the library DynamicalSystems to explore
a simple Stock-and-Flow structure.

Author: Niall Palfreyman, 04/12/2023
"""
module Rabbits

using DynamicalSystems, GLMakie
#-----------------------------------------------------------------------------------------
# Methods:
#-----------------------------------------------------------------------------------------
"""
	births( u, p)

Birth rule for rabbits.
"""
function births( u, p)
	return p[1] * u[1]
end

#-----------------------------------------------------------------------------------------
"""
	deaths( u, p)

Death rule for rabbits.
"""
function deaths( u, p)
	return u[1] / p[2]
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstration use-case for building a DynamicalSystems model.
"""
function demo()
	println("\n============ Rabbit Dynamics demo: ===============")
	u0 = [									# Stock initial values:
		1000.0								# Number of rabbits
	]
	p = [									# Constant parameter values:
		0.0416667							# Specific rabbit birth-rate
		48									# Average rabbit lifespan
	]
	flows! = function (du,u,p,t)			# Dynamical update rule - sets all flows du
		du[1] = births(u,p) - deaths(u,p)
		nothing
	end
	duration = 96							# Duration of model run
	Δt = 0.5								# Simulation time-step

	rabbits = CoupledODEs(flows!, u0, p)
	println("Here is the dynamical model's initial state:")
	display(rabbits)
	println()

	u,t = trajectory(rabbits, duration; Δt)
	println("Here is the time coordinate:")
	display(t)
	println( "Here are the first 5 values of u:")
	display(u[1:5,1])
	println( "... and here is the final of u:")
	display(u[end][1])
	println()

	println("Finally, here is a BOTG of the $duration-month trajectory ...")
	fig,_ = lines(t, u[:,1])
	fig
end

end