#========================================================================================#
"""
	Kaibab

Module Kaibab: Provide iterative models of Overshoot and Collapse on the Kaibab Plateau.

Author: Niall Palfreyman, 19/12/2023
"""
module Kaibab

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Model

A Model is an iterative model of species interacting on the Kaibab Plateau.
"""
struct Model
	name::String					# Name of this Archetype
	label::Vector{String}			# Label(s) of phase variables
	timeline::AbstractRange			# Timeline of demo run
	initial::Vector{Float64}		# Initial values of the demonstration
	parameters::Vector{Float64}		# Dynamical parameters for this Archetype
	flow::Function					# Dynamical flow rule for this Archetype
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	iteration

iteration specifies the parameters and flows for a sequence of Kaibab.Models
"""
const iteration = [
	Model( "Constant predation", ["Deer"], 1900:1950,
		[5000],						# Initial number of Deer
		[
			4000,					# Area of range
			0.2,					# Specific deer growth rate
			500						# Number of pumas
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],u[1]) - predation(kills(),p[3])
			nothing
		end
	),
	Model( "Logistic vegetation", ["Deer"], 1900:1950,
		[5000],						# Initial number of Deer
		[
			4000,					# Area of range
			0.2,					# Base specific deer growth rate
			451,					# Number of pumas (specially reduced!)
			50_000					# Vegetation available on plateau
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],p[4],u[1]) - predation(kills(),p[3])
			nothing
		end
	),
	Model( "Saturated predation", ["Deer"], 1900:1950,
		[5000],						# Initial number of Deer ??? Need to get stability in 1900-10
		[
			4000,					# Area of range
			0.2,					# Base specific deer growth rate
			500,					# Number of pumas
			50_000					# Vegetation available on plateau
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],p[4],u[1]) -
				predation( kills( deer_density(u[1],p[1])), p[3])
			nothing
		end
	),
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	deer_growth( specific_growth, deer)

Calculate deer growth rate from specific rate and current number of deer
"""
function deer_growth( specific_growth, deer)
	specific_growth * deer
end

#-----------------------------------------------------------------------------------------
"""
	deer_growth( base_growth, vegetation, deer)

Calculate deer growth rate from base specific rate and current number of deer
"""
function deer_growth( base_growth, vegetation, deer)
	base_growth * deer * (1 - deer/vegetation)
end

#-----------------------------------------------------------------------------------------
"""
	predation( per_puma, pumas)

Calculate predation rate from specific rate and current number of pumas
"""
function predation( per_puma, pumas)
	per_puma * pumas
end

#-----------------------------------------------------------------------------------------
"""
	kills()

Calculate number of kills per predator per year
"""
function kills()
	2
end

#-----------------------------------------------------------------------------------------
"""
	kills(density)

Calculate number of kills per predator per year, dependent on deer density
??? Fix constants to give stability at 5000 pre 1910
"""
function kills(density)
	saturation = 4
	K = 1.2
	saturation*hill(density,K,2)
end

#-----------------------------------------------------------------------------------------
"""
	deer_density( deer, area)

Calculate density of deer on the plateau
"""
function deer_density( deer, area)
	deer / area
end

#-----------------------------------------------------------------------------------------
"""
	hill( s::Real, K=1.0, n=1.0)

Return the Hill saturation function corresponding to a signal s, half-response K and cooperation n.
"""
function hill( s, K::Real=1.0, n::Real=1.0)
	@assert all(s .≥ 0) "Negative signal is not permitted"
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
	demo()

Demonstration of three iterations of the Kaibab model.
"""
function demo( iter::Int=1)
	@assert iter in 1:5 "Iteration number must be in the range 1:3"
	println("\n============ Demonstrating Kaibab model iteration " *
		"$iter: $(iteration[iter].name)" *
		" ==============="
	)

	kaibab_model = CoupledODEs(
		iteration[iter].flow,
		iteration[iter].initial,
		iteration[iter].parameters,
		t0 = first(iteration[iter].timeline)
	)
	u,t = trajectory(
		kaibab_model,
		last(iteration[iter].timeline) - first(iteration[iter].timeline),
		Δt = step(iteration[iter].timeline)
	)

	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time/yr", title="BOTG")
	lines!( t, u[:,1], label=iteration[iter].label[1])
	if N == 2
		lines!(t, u[:,2], label=iteration[iter].label[2])
		Axis( fig[2, 1], title="Phase plot",
			xlabel=iteration[iter].label[1], ylabel=iteration[iter].label[2]
		)
		scatterlines!( u[:,1], u[:,2], )
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end