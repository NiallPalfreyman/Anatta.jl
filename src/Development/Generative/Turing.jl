#========================================================================================#
"""
	Turing

This simulation demonstrates the emergence of complex activity in reaction-diffusion
(i.e., Turing) systems.

Author: Niall Palfreyman (April 2023)
"""
module Turing

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, Random, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	SlimeMould

A SlimeMould can in principle move, and secretes the chemical A(ctivator).
"""
@agent SlimeMould ContinuousAgent{2} begin
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	turing( kwargs)

Initialise the Turing reaction-diffusion system.
"""
function turing(;
	a_secr_rate = 0.0,
	a_diff_rate = 1e-2,
	i_diff_rate = 0.4,
	a_evap_rate = 1e-2,
	i_evap_rate = 3e-2,
	pPop = 0.1,
)
	width = 50
	properties = Dict(
		:activator => 1e-4rand(width,width),
		:inhibitor => 1e-4rand(width,width),
		:a_secr_rate => a_secr_rate,
		:a_diff_rate => a_diff_rate,
		:i_diff_rate => i_diff_rate,
		:a_evap_rate => a_evap_rate,
		:i_evap_rate => i_evap_rate,
		:pPop => pPop,
		:dt => 0.5,
	)

	tur = ABM( SlimeMould, ContinuousSpace((width,width),spacing=1.0); properties)

	for _ in 1:pPop*width*width
		add_agent!( SlimeMould, tur, (0,0))
	end

	tur
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( slimy, tur)

Express activator and inhibitor proteins.
"""
function agent_step!( slimy::SlimeMould, tur::ABM)
	idx_here = get_spatial_index( slimy.pos, tur.activator, tur)
	if tur.a_secr_rate > 0.0
		tur.activator[idx_here] += tur.a_secr_rate*tur.dt
	end
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(tur)

Allow both A and I to react, evaporate and diffuse.
"""
function model_step!( tur::ABM)
	# Chemical reaction:
	(tur.activator,tur.inhibitor) = (
		tur.activator + tur.dt * tur.activator.^2 ./ tur.inhibitor,
		tur.inhibitor + tur.dt * tur.activator.^2
	)
	
	# Evaporation:
	tur.activator *= (1 - tur.dt*tur.a_evap_rate)
	tur.inhibitor *= (1 - tur.dt*tur.i_evap_rate)

	# Diffusion:
	diffuse4!( tur.activator, tur.dt*tur.a_diff_rate)
	diffuse4!( tur.inhibitor, tur.dt*tur.i_diff_rate)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Create playground with two wave sources.
"""
function demo()
	tur = turing()
	params = Dict(
		:pPop => 0:0.01:1,
		:a_secr_rate => 0:0.001:0.01,
		:a_diff_rate => 0:0.001:0.025,
		:i_diff_rate => 0:0.01:1,
		:a_evap_rate => 0:0.001:0.1,
		:i_evap_rate => 0:0.001:0.1,
	)
	plotkwargs = (
		am = :circle,
		ac = :red,
		as = 15,
		heatarray = :activator,
		add_colorbar = false,
	)

	playground, = abmplayground( tur, turing;
		agent_step!, model_step!, params, plotkwargs...
	)

	playground
end

end