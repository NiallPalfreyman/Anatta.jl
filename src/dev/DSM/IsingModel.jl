#========================================================================================#
"""
	IsingModel

This model simulates a non-crystalline ferromagnetic material: individual dipoles align toward
their ambient magnetic field, while also themselves contributing to that field. 

Author: Niall Palfreyman (April 2023).
"""
module IsingModel

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Dipole

A Dipole agent has the attribute `up`, whose Bool value is determined at each step by the
Dipole's ambient B-field (i.e. magnetic field).
"""
@agent Dipole ContinuousAgent{2} begin
	up::Bool									# Is dipole pointing up or down?
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
	width = 30
	extent = (width,width)
	space = ContinuousSpace(extent; spacing = 1.0)
	properties = Dict(
		:evaporation_rate => evaporation_rate,
		:diffusion_rate => diffusion_rate,
		:secretion_rate => secretion_rate,
		:B_field => zeros(Float64, extent)		# B-field at each grid location
	)

	ising = ABM( Dipole, space; properties, scheduler = Schedulers.Randomly())

	for _ in 1:width*width
		add_agent!( ising, (0,0), rand(Bool))
	end

	for dipole in allagents(ising)
		if dipole.up == true
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
		dipole.up = true
		ising.B_field[idx_dipole] += ising.secretion_rate
	else
		dipole.up = false
	end
end

#-----------------------------------------------------------------------------------------
"""
	acolour( dipole::Dipole)

Select the dipole's colour on the basis of its up/down orientation.
"""
acolour( dipole::Dipole) = dipole.up ? :lime : :red

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a simulation of the Ising model.
"""
function demo()
	ising = ising_model()
	params = Dict(
		:evaporation_rate => 0:0.01:1,
		:diffusion_rate => 0:0.01:1,
		:secretion_rate => 0:0.01:1,
	)
	plotkwargs = (
		ac = acolour,
		as = 20,
		add_colorbar=false,
		heatarray=:B_field,
	)

	playground, = abmplayground( ising, ising_model;
		agent_step!, model_step!, params, plotkwargs...
	)

	playground
end

end