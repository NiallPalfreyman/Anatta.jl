#========================================================================================#
"""
	RapaNui

Module RapaNui: Provide iterative models of Overshoot and Collapse on the islan of Rapa nui.

Author: Niall Palfreyman, 15/04/2024
"""
module RapaNui

using DynamicalSystems, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Model

A Model is an iterative model of species interacting on the Kaibab Plateau.
"""
struct Model
	title::String					# Name of this Archetype
	variables::Vector{String}		# Label(s) of phase variables
	initial::Vector{Float64}		# Initial values of the demonstration
	parameters::Vector{Float64}		# Dynamical parameters for this Archetype
	timeline::AbstractRange			# Timeline of demo run
	flow::Function					# Dynamical flow rule for this Archetype
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	rapa_nui_model

rapa_nui_model specifies the parameters and flows for a sequence of Rapa nui models.
"""
const rapa_nui_model = [
	Model( "Growth model 1", ["Humans"],
		[30],						# u[1]: Initial number of Human settlers
		[
			0.0625,					# p[1]: Specific birth rate 
			0.025					# p[2]: Specific death rate
		],
		1200:20:1600,				# Timeline
		function (du,u,p,t)			# Flow function
			du[1] = p[1]*u[1] - p[2]*u[1]
			nothing
		end
	),
	Model( "Growth model 2", ["Humans"],
		[30],						# u[1]: Initial number of Human settlers
		[
			0.0625*0.65,			# p[1]: Specific birth rate * child mortality
			0.025					# p[2]: Specific death rate
		],
		1200:20:1600,				# Timeline
		function (du,u,p,t)			# Flow function
			du[1] = p[1]*u[1] - p[2]*u[1]
			nothing
		end
	),
	Model( "Tree consumption", ["Humans", "Trees"],
		[30,40_000],				# u[1]: Initial number of Human settlers
		[
			0.0625*0.65,			# p[1]: Specific birth rate * child mortality
			0.025,					# p[2]: Specific death rate
			0.025,					# p[3]: Specific tree requirement rate r
			2						# p[4]: Greediness factor (desired/required)
		],
		1200:1600,					# Timeline
		function (du,u,p,t)			# Flow function
			s = u[2]/u[1]			# Current tree supply per Human
			d = p[4]*p[3]			# Desired specific tree consumption rate
			w = d * hill(s,d,2)		# Wasteful specific tree consumption rate

			du[1] = p[1]*u[1] - p[2]*u[1]
			du[2] = -w * u[1]
			nothing
		end
	),
	Model( "Overshoot", ["Humans", "Trees"],
		[30,40_000],				# u[1]: Initial number of Human settlers
		[
			0.0625*0.65,			# p[1]: Specific birth rate * child mortality
			0.025,					# p[2]: Specific death rate
			0.025,					# p[3]: Specific tree requirement rate r
			2						# p[4]: Greediness factor (desired/required)
		],
		1200:1750,					# Timeline
		function (du,u,p,t)			# Flow function
			s = u[2]/u[1]			# Current tree supply per Human
			d = p[4]*p[3]			# Desired specific tree consumption rate
			w = d * hill(s,d,2)		# Wasteful specific tree consumption rate
			surplus_mortality = hill(w,-p[3],2)	# ... due to low tree usage

			du[1] = p[1]*u[1] - p[2]*u[1]*(1 + surplus_mortality)
			du[2] = -w * u[1]
			nothing
		end
	),
	Model( "Collapse", ["Humans", "Trees"],
		[30,40_000],				# u[1]: Initial number of Human settlers
		[
			0.0625*0.65,			# p[1]: Specific birth rate * child mortality
			0.025,					# p[2]: Specific death rate
			0.025,					# p[3]: Specific tree requirement rate r
			3						# p[4]: Greediness factor (desired/required)
		],
		1200:1850,					# Timeline
		function (du,u,p,t)			# Flow function
			s = u[2]/u[1]			# Current tree supply per Human
			d = p[4]*p[3]			# Desired specific tree consumption rate
			w = d * hill(s,d,2)		# Wasteful specific tree consumption rate
			surplus_mortality = hill(w,-p[3],2)	# ... due to low tree usage

			du[1] = p[1]*u[1] - p[2]*u[1]*(1 + surplus_mortality)
			du[2] = -w * u[1]
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

Demonstration of three iterations of the Rapa nui model.
"""
function demo( iter::Int=1)
	@assert iter in 1:5 "Iteration number must be in the range 1:5"
	
	rapa_nui = rapa_nui_model[iter]
	println("\n============ Simulating Rapa nui model iteration " *
		"$iter: $(rapa_nui.title)" *
		" ==============="
	)

	u,t = trajectory(
		coupled_odes( rapa_nui),
		last(rapa_nui.timeline) - first(rapa_nui.timeline),
		Δt = step(rapa_nui.timeline)
	)

	N = size(u,2)
	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time/yr", title="BOTG")
	for phase_var in 1:N
		lines!( t, u[:,phase_var], label=rapa_nui.variables[phase_var])
	end
	Legend( fig[1,2], ax)
	display(fig)

	nothing
end

end