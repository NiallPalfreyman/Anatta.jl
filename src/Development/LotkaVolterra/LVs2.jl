#========================================================================================#
"""
	LVs - Version 2

A system of two interacting predator-prey species.
Version 2 implements run() to generate and display Euler data for the rabbit-lynx system.

Author: Niall Palfreyman, 31/05/2022.
"""
module LVs

using GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	LV

A Lotka-Volterra system containing two species interacting with each other.
"""
struct LV
	rx							# Reproduction rate of species x
	kx							# Carrying capacity of species x
	ry							# Reproduction rate of species y
	ky							# Carrying capacity of species y
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	run( lv::LV)

Run a simulation of the given LV system over the time-duration nsteps * dt.
"""
function run( lv::LV, x0::Float64, y0::Float64, dt::Float64=0.1, nsteps::Int=2000)
	t = 0 : dt : nsteps*dt
	x = [[0.0,0.0] for _ in 1:length(t)]

	# Initialisation: The very first values of x in our simulated trajectory:
	x[1] = [x0,y0]

	# Simulation using Euler's method. Remember: x[n] is a Vector of number pairs representing
	# respectively the number of rabbits and the number of lynxes:
	for n = 1:nsteps
		x[n+1][1] = x[n][1] + dt * (lv.rx*x[n][1]*(1 - x[n][2]/lv.ky))
		x[n+1][2] = x[n][2] - dt * (lv.ry*x[n][2]*(1 - x[n][1]/lv.kx))
	end

	(t,x)
end

#-----------------------------------------------------------------------------------------
"""
	visualise( t, x)

Visualise the run data (t,x) on the screen as a simple GLMakie plot.
"""
function visualise( t, x)
	# Prepare the graphics axes:
	fig = Figure(resolution=(1200, 600))
	ax = Axis(fig[1, 1], xlabel = "t", ylabel = "x", title = "Predator-prey system")

	prey = map( v->v[1],x)
	pred = map( v->v[2],x)
	maxvertical = 1.1max( findmax(prey)[1], findmax(pred)[1])
	limits!(ax, 0, t[end], 0, maxvertical)

	# Plot two curves of x against t:
	lines!( ax, t, prey, linewidth = 5, color = :blue)
	lines!( ax, t, pred, linewidth = 5, color = :red)

	# Insert some explanatory text:
	text!( "This is a simple Predator-prey system",
		position=(20,round(0.95maxvertical)), fontsize=30, align=(:left,:center)
	)

	# Display the results:
	display(fig)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

This use-case method describes everything I want to do in the final program: Demonstrate
simulation of a simple 2-species Lotka-Volterra system in a simple 3-step use-case.
"""
function demo()
	# Build the Lotka-Volterra system:
	lv = LV( 0.05, 1000, 0.1, 100)						# A simple rabbit-lynx system
	
	# Calculate the simulation data with initial conditions 200 rabbits and 50 lynx:
	(t,x) = run( lv, 200.0, 50.0)

	# Run the animation:
	visualise( t, x)
end

end		# of LVs