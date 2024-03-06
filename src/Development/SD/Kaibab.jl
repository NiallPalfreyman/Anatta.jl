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
	model_iteration

model_iteration specifies the parameters and flows for a sequence of Kaibab.Models.
"""
const model_iteration = [
	Model( "Constant predation", ["Deer"], 1900:1950,
		[5_000],					# u[1]: Initial number of Deer
		[
			4_000,					# p[1]: Area of range
			0.2,					# p[2]: Specific deer growth rate
			500						# p[3]: Number of pumas
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],u[1]) - predation(kills(),p[3])
			nothing
		end
	),
	Model( "Logistic vegetation", ["Deer"], 1900:1950,
		[5_000],					# u[1]: Initial number of Deer
		[
			4_000,					# p[1]: Area of range
			0.2,					# p[2]: Base specific deer growth rate
			451,					# p[3]: Number of pumas (specially reduced!)
			50_000					# p[4]: Vegetation available on plateau
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],p[4],u[1]) - predation(kills(),p[3])
			nothing
		end
	),
	Model( "Saturated predation", ["Deer"], 1900:1950,
		[5_000],					# u[1]: Initial number of Deer
		[
			4_000,					# p[1]: Area of range
			0.2,					# p[2]: Base specific deer growth rate
			500,					# p[3]: Number of pumas
			50_000					# p[4]: Vegetation available on plateau
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],p[4],u[1]) -
				predation( kills( deer_density(u[1],p[1])), p[3])
			nothing
		end
	),
	Model( "Culling pumas", ["Deer","Puma"], 1900:1950,
		[
			5_000,					# u[1]: Initial number of Deer
			500						# u[2]: Initial number of Puma
		],
		[
			4_000,					# p[1]: Area of range
			0.2,					# p[2]: Base specific deer growth rate
			50_000					# p[3]: Vegetation available on plateau
		],
		function (du,u,p,t)
			du[1] = deer_growth(p[2],p[3],u[1]) -
				predation( kills( deer_density(u[1],p[1])), u[2])
			if t >= 1910 && u[2] > 0.0
				u[2] = 0.0
			end
			nothing
		end
	),
	Model( "Degrading vegetation", ["Deer","Puma","Vegetation"], 1900:1950,
		[
			5_000,					# u[1]: Initial number of Deer
			500,					# u[2]: Initial number of Puma
			45_000,					# u[3]: Initial Vegetation on plateau
		],
		[
			4_000,					# p[1]: Area of range
			0.2,					# p[2]: Base specific deer growth rate
			0.05,					# p[3]: Base specific Vegetation growth rate
			50_000					# p[4]: Maximum vegetation available on plateau
		],
		function (du,u,p,t)
			# Deer give birth, but are hunted by puma:
			du[1] = deer_growth(p[2],u[3],u[1]) -
				predation( kills( deer_density(u[1],p[1])), u[2])
			# Puma stay constant until 1910, when they are culled to zero:
			if u[2] > 0.0 && t >= 1910
				u[2] = 0.0
			end
			# Deer graze Vegetation, but also undercut its ability to grow back:
			du[3] = p[3]*u[3] * (1 - u[3]/(p[4]*hill(u[1],-40_000,2))) -
				u[3]*hill(u[1],40_000,2)
			nothing
		end
	),
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	coupled_odes( model::Model)

Construct a CoupledODEs instance from the given Model
"""
function coupled_odes( model::Model)
	CoupledODEs(
		model.flow,
		model.initial,
		model.parameters,
		t0 = first(model.timeline)
	)
end

#-----------------------------------------------------------------------------------------
"""
	deer_growth( specific_growth, deer)

Calculate deer growth rate from specific rate and current number of deer.
"""
function deer_growth( specific_growth, deer)
	specific_growth * deer
end

#-----------------------------------------------------------------------------------------
"""
	deer_growth( base_growth, vegetation, deer)

Calculate deer growth rate from base specific rate and current number of deer.
"""
function deer_growth( base_growth, vegetation, deer)
	base_growth * deer * (1 - deer/vegetation)
end

#-----------------------------------------------------------------------------------------
"""
	predation( per_puma, pumas)

Calculate predation rate from specific rate and current number of pumas.
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
K = 1.2 gives a realistic model, but Deer then fall to zero over period 1900-1910.
Which value of K yields stability over this period?
"""
function kills(density)
	saturation = 4
	K = 1.382
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
	@assert iter in 1:5 "Iteration number must be in the range 1:5"
	
	kaibab_model = model_iteration[iter]
	println("\n============ Demonstrating Kaibab model iteration " *
		"$iter: $(kaibab_model.name)" *
		" ==============="
	)

	u,t = trajectory(
		coupled_odes( kaibab_model),
		last(kaibab_model.timeline) - first(kaibab_model.timeline),
		Δt = step(kaibab_model.timeline)
	)

	# ??? Doesn't work with more than 1 phase variable! :(
	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time/yr", title="BOTG")
	for phase_var in 1:N
		lines!( t, u[:,phase_var], label=kaibab_model.label[phase_var])
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end