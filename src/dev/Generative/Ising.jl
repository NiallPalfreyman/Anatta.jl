#========================================================================================#
"""
	Ising

This model simulates a non-crystalline ferromagnetic material: individual dipoles align toward
their ambient magnetic field, while also themselves contributing to that field. 

Author: Niall Palfreyman, April 2023.
"""
module Ising

include( "../../Development/Generative/AgentTools.jl")

using Agents, GLMakie, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Dipole

A Dipole agent has the attribute `north`, whose Bool value is determined at each step by the
Dipole's ambient B-field (i.e. magnetic field).
"""
@agent struct Dipole(ContinuousAgent{2,Float64})
	north::Bool									# Is dipole pointing up or down?
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	ising_model( kwargs)

Create and initialise an Ising model.
"""
function ising_model(;
	evaporation_rate = 0.5,						# How fast does B evaporate?
	diffusion_rate = 0.6,						# How fast does B diffuse?
	secretion_rate = 0.6,						# How fast is B secreted?
)
	extent = (30,30)
	properties = Dict(
		:evaporation_rate => evaporation_rate,
		:diffusion_rate => diffusion_rate,
		:secretion_rate => secretion_rate,
		:B_field => zeros(Float64, extent)		# B-field at each grid location
	)

	ising = StandardABM( Dipole, ContinuousSpace(extent; spacing = 1.0);
		agent_step!, model_step!,
		properties
	)

	for _ in 1:prod(extent)
		dipole = add_agent!( ising, (0,0), rand(Bool))
		if dipole.north
			ising.B_field[get_spatial_index(dipole.pos,ising.B_field,ising)] += ising.secretion_rate
		end
	end

	return ising
end

#-----------------------------------------------------------------------------------------
"""
	model_step!( ising)

On each step, B-field evaporates and diffuses outwards from dipoles.
"""
function model_step!( ising::ABM)
	ising.B_field[:] = (
		(1-ising.evaporation_rate) .* diffuse4( ising.B_field, ising.diffusion_rate)
	)[:]
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( dipole, ising)

Each dipole changes its orientation in response to the ambient B-field, and also secretes
B-field when in its up-orientation.
"""
function agent_step!( dipole::Dipole, ising::ABM)
	idx_dipole = get_spatial_index( dipole.pos, ising.B_field, ising)
	if rand() < ising.B_field[idx_dipole]
		dipole.north = true
		ising.B_field[idx_dipole] += ising.secretion_rate
	else
		dipole.north = false
	end
end

#-----------------------------------------------------------------------------------------
"""
	acolour( dipole::Dipole)

Select the dipole's colour on the basis of its north/south orientation.
"""
acolour( dipole::Dipole) = dipole.north ? :lime : :red

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a simulation of the Ising model.
"""
function demo()
	params = Dict(
		:evaporation_rate => 0:0.01:1,
		:diffusion_rate => 0:0.01:1,
		:secretion_rate => 0:0.01:1,
	)
	plotkwargs = (
		agent_color = acolour,
		agent_size = 20,
		add_colorbar=false,
		heatarray=:B_field,
	)

	playground, = abmplayground( ising_model; params, plotkwargs...)

	playground
end

end