#========================================================================================#
"""
	Roesslers

Module Roesslers: This module demonstrates Roessler's hypothetical chaotic chemical reaction.

Author: Niall Palfreyman, 11/04/2024
"""
module Roesslers

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Roessler

A Roessler is a dynamical model demonstrating Roessler's hypothetical chaotic chemical reaction.
"""
struct Roessler
	variables::Vector{String}		# Names of phase variables
	parameters::Vector{Float64}		# Parameter values for this model
	trajectory::StateSpaceSet		# Trajectory time-series
	timeline::Vector{Float64}		# Trajectory time values

	function Roessler( T=200.0, initial=[1.0,1.0,1.0]; a=0.2, b=0.2, c=2.5, transient=0.0)
		variables	= ["x", "y", "z"]
		parameters	= [a,b,c]
		odes = CoupledODEs(
			function (du,u,p,t)
				autocatalysis	= u[1] + p[1]*u[2]
				infusion		= p[2]
				eliminating		= p[3]*u[3]
				degrading		= u[2] + u[3]
				transcription	= u[1]*u[3]
				du[1] = -degrading
				du[2] = autocatalysis
				du[3] = infusion + transcription - eliminating
				nothing
			end,
			initial,
			parameters
		)
		u,t = trajectory( odes, T, Δt = 0.01, Ttr = transient)
		new(variables,parameters,u,t)
	end
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate how to create and run a Roessler model.
"""
function demo()
	r = Roessler()

	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title="Roessler BOTG")
	for phasevar in 1:3
		lines!( r.timeline, r.trajectory[:,phasevar], label=r.variables[phasevar])
	end
	Legend( fig[1,2], ax)

	Axis(fig[2, 1], title="Roessler x-y phase plot", 
		xlabel=r.variables[1], ylabel=r.variables[2],
		aspect=1
	)
	lines!( r.trajectory[:,1], r.trajectory[:,2])

	display(fig)
	nothing
end

#-----------------------------------------------------------------------------------------
"""
	experiment()

Perform the Roessler experiments suggested in the corresponding laboratory.
"""
function experiment(axis3=false)
	b = reshape( [2.0,1.0,0.8,0.73,0.6,0.5,0.35,0.3,0.2,0.1,0.05,0.01], (3,4))
	fig = Figure(fontsize=30,linewidth=2, title="Roessler phase plots (a=0.2,c=5.7)")

	for i in 1:3, j in 1:4
		r = Roessler(300,transient=100,c=5.7,b=b[i,j])
		if axis3
			# Plot all three phase variables:
			Axis3( fig[i,j], title="b = $(b[i,j])", aspect=:equal,
				xlabel=r.variables[1], ylabel=r.variables[2], zlabel=r.variables[3]
			)
			lines!( r.trajectory[:,1], r.trajectory[:,2], r.trajectory[:,3])
		else
			# Plot only x and y:
			Axis( fig[i,j], title="b = $(b[i,j])", aspect=1,
				xlabel=r.variables[1], ylabel=r.variables[2]
			)
			lines!( r.trajectory[:,1], r.trajectory[:,2])
		end
	end

	display(fig)
	nothing
end

end