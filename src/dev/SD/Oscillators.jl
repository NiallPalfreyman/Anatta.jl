#========================================================================================#
"""
	Oscillators

Module Oscillators: This module models three relaxation oscillators - Rayleigh, van der Pol
and Kelso.

Author: Niall Palfreyman, 25/04/2024
"""
module Oscillators

using DynamicalSystems, GLMakie, FFTW

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Oscillator

An Oscillator represents a single model of a relaxation oscillator.
"""
struct Oscillator
	title::String						# Title of this model
	variables::Vector{String}			# Names(s) of the phase variables
	initial::Vector{Float64}			# Initial values of the phase variables
	parameters::Vector{Float64}			# Dynamical parameters for this model
	flow::Function						# Dynamical flow rule for this model
	duration::Float64					# Duration of simulation
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	oscillator

An array of Oscillator models.
"""
const oscillator = [
	Oscillator(
		"Rayleigh",							# Oscillator type
		["x","v"],							# Phase variables
		[1.0,0.0],							# Initial displacement and velocity
		[1.0,1.0],							# Epsilon (ϵ), omega (ω)
		function (du,u,p,t)					# Flow rule ...
			x, v = u
			ϵ, ω = p

			du[1] = v						# Velocity causes change in displacement
			du[2] = -ϵ*(v^2 - 1)*v - ω^2*x 	# Checkpoint damping + restoration
			nothing
		end,
		20									# Duration
	),
	Oscillator(
		"van der Pol",						# Oscillator type
		["x","v"],							# Phase variables
		[1.0,0.0],							# Initial displacement and velocity
		[1.0,1.0],							# Epsilon (ϵ), omega (ω)
		function (du,u,p,t)					# Flow rule ...
			x, v = u
			ϵ, ω = p

			du[1] = v						# Velocity causes change in displacement
			du[2] = -ϵ*(x^2 - 1)*v - ω^2*x 	# Checkpoint damping + restoration
			nothing
		end,
		20									# Duration
	),
	Oscillator(
		"Kelso",							# Oscillator type
		["x","v"],							# Phase variables
		[1.0,0.0],							# Initial displacement and velocity
		[1.0,1.0],							# Epsilon (ϵ), omega (ω)
		function (du,u,p,t)					# Flow rule ...
			x, v = u
			ϵ, ω = p

			du[1] = v						# Velocity causes change in displacement
			du[2] = -ϵ*(v^2 + x^2 - 1)*v - ω^2*x	# Combined checkpoint damping
			nothing
		end,
		20									# Duration
	),
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	hill( s::Real, K=1.0, n=1.0)

Return the Hill saturation function corresponding to a signal s, half-response K and cooperation n.
"""
function hill( s, K::Real=1.0, n::Real=1.0)
	if K == 0
		return 0.5
	end

	abs_K = abs(K)
	if n != 1
		n = float(n)
		abs_K = abs_K^n
		s = s.^n
	end

	abs_hill = abs_K ./ (abs_K .+ s)
	
	K < 0 ? abs_hill : 1 - abs_hill
end

#-----------------------------------------------------------------------------------------
"""
	demo( n=1)

Run the n-th oscillator model.
"""
function demo( n=1)
	osc = oscillator[n]
	u,t = trajectory(
		CoupledODEs(osc.flow,osc.initial,osc.parameters),
		osc.duration,
		Δt = 0.1
	)

	# BOTG:
	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title=osc.title)
	for i in 1:N
		lines!( t, u[:,i], label=osc.variables[i])
	end
	Legend( fig[1,2], ax)
	# Phase plot:
	Axis(fig[2,1], title="Phase plot", aspect=1,
		xlabel=osc.variables[1], ylabel=osc.variables[2]
	)
	lines!( u[:,1], u[:,2])
	# Fourier analysis:
	fourier = fft(u[:,1])
	Axis(fig[3, 1], title="Fourier components of $(osc.variables[1])")
#	lines!( real.(fourier), color=:red)
#	lines!( imag.(fourier), color=:blue)
	lines!( abs.(fourier), color=:green)

	display(fig)
	nothing
end

end