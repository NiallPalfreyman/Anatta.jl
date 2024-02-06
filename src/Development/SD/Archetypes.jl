#========================================================================================#
"""
	Archetypes

Module Archetypes: This module demonstrates SD's six behavioural archetypes: Growth, Decay,
Goal-seeking, Overshoot, Oscillation and Switch.

Author: Niall Palfreyman, 07/12/2023
"""
module Archetypes

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Archetype

An Archetype represents a family of dynamical systems exhibiting similar behaviours.
"""
struct Archetype
	name::String					# Name of this Archetype
	label::Vector{String}			# Label(s) of phase variables
	duration::Float64				# Duration of demo run
	initial::Vector{Float64}		# Initial values of the demonstration
	parameters::Vector{Float64}		# Dynamical parameters for this Archetype
	flow::Function					# Dynamical flow rule for this Archetype
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	archetype

archetype contains the parameter and flow specifications for the six behavioural archetypes.
"""
const archetype = [
	Archetype( "Growth", ["Protein concentration"], 15,
		[0.1],											# Example: Genetic auto-activation
		[0.4],											# β: Specific auto-activation rate
		function (dP,P,β,t)
			dP[1] = β[1] * P[1]
			nothing
		end
	),
	Archetype( "Decay", ["Protein concentration"], 15,
		[10.0],											# Example: Cellular protein breakdown
		[0.4],											# α: Specific protein degradation rate
		function (dP,P,α,t)
			dP[1] = -α[1] * P[1]
			nothing
		end
	),
	Archetype( "Goal-seeking", ["Protein concentration"], 30,
		[0.0],											# Example: Leaky barrel
		[0.6,0.2],										# β: Expression rate; α: degradation rate
		function (dP,P,k,t)
			dP[1] = k[1] - k[2]*P[1]
			nothing
		end
	),
	Archetype( "Overshoot", ["Dugong","Algae"], 30,
		[40.0,100.0],									# Example: Grazing degradation
		[0.4,100.0],									# Rate r, Sustainable capacity C
		function (du,u,p,t)
			du[1] = p[1]*u[1]*(1 - u[1]/u[2])			# A defines D-capacity
			du[2] = p[1]*hill(u[1],-10) * u[2] *		# D reduces A growth-rate, and also ...
					(1 - u[2]/(p[2]*hill(u[1],-10)))	# ... degrades A's ability to regrow back
			nothing
		end
	),
	Archetype( "Oscillation", ["ADP","F6P"], 50,
		[0.7,1.3],										# Example: Selkov's glycolysis oscillator
		[0.06,0.6],										# a: F6P->ADP breakdown; b: F6P supply rate
		function (du,u,p,t)
			du[1] = -u[1] + p[1]*u[2] + u[1]^2*u[2]		# ADP degrades, but is replenished from F6P
			du[2] =  p[2] - p[1]*u[2] - u[1]^2*u[2]		# Constantly supplied F6P reacts to ADP
			nothing
		end
	),
	Archetype( "Switch", ["Protein","RNA"], 60,
		[0.1,0.1],										# Example: Griffith switch (a_c = 1/2b)
		[0.2,2.0],										# a1: P breakdown; a2: RNA breakdown rate
		function (du,u,p,t)
			injection = (abs(t-10)<1) ? 0.4 : 0.0		# Micro-inject P around t=10
			du[1] = u[2] - p[1]*u[1] + injection		# RNA expresses P, which then breaks down
			du[2] = hill(u[1],1,2) - p[2]*u[2]			# P up-regulates RNA, which also degrades
			nothing
		end
	)
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	hill( s::Real, K=1.0, n=1.0)

Return the Hill saturation function corresponding to a signal s, half-response K and cooperation n.
"""
function hill( s::Real, K::Real=1.0, n::Real=1.0)
	if K == 0
		return 0.5
	end

	abs_K = abs(K)
	if n != 1
		n = float(n)
		abs_K = abs_K^n
		s = s^n
	end

	abs_hill = abs_K / (abs_K + s)
	
	K < 0 ? abs_hill : 1 - abs_hill
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstration of the six SD behavioural archetypes.
"""
function demo( arch::Int=1)
	@assert arch in 1:6 "Archetype number must be in the range 1:6"
	println("\n============ Demonstrating behavioural archetype " *
		"$arch: $(archetype[arch].name)" *
		" ==============="
	)

	dynamical_model = CoupledODEs(
		archetype[arch].flow,
		archetype[arch].initial,
		archetype[arch].parameters
	)
	u,t = trajectory( dynamical_model, archetype[arch].duration, Δt = 0.1)

	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title="BOTG")
	lines!( t, u[:,1], label=archetype[arch].label[1])
	if N == 2
		lines!(t, u[:,2], label=archetype[arch].label[2])
		Axis( fig[2, 1], title="Phase plot",
			xlabel=archetype[arch].label[1], ylabel=archetype[arch].label[2]
		)
		scatterlines!( u[:,1], u[:,2], )
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end