#========================================================================================#
"""
	WaveDynamics

This module applies simulation to visualise processes that may otherwise be difficult to visualise.
This use of simulation is becoming increasingly important in pedagogical applications.

Author: Niall Palfreyman (March 2023)
"""
module WaveDynamics

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, Random, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	ESource

A source of electrical vibration.
"""
@agent ESource ContinuousAgent{2} begin
	amplitude::Float64
	frequency::Float64
	phase::Float64
	efield::Float64
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	wavedynamics( kwargs)

Initialise WaveDynamics model initially empty of ESources.
"""
function wavedynamics(;
	worldwidth = 100,
	attenuation = 0.4,
)
	world = ContinuousSpace((worldwidth,worldwidth), spacing=1.0)
	properties = Dict(
		:EField => zeros(Float64,worldwidth,worldwidth),
		:BField => zeros(Float64,worldwidth,worldwidth),
		:c => 1.0,
		:t => 0.0,
		:dt => 0.001,
		:dxy => 0.1,
		:attenuation => attenuation,
	)

	wd = ABM( ESource, world; properties)
	addsource!( wd, (50,45))
	addsource!( wd, (50,55))

	wd
end

#-----------------------------------------------------------------------------------------
"""
	addsource!( abm, pos, amplitude, frequency, phase)

Add an ESource to the ABM with the given specification, initialised to time zero.
"""
function addsource!( abm, pos, ampl=1.0, freq=1.0, phase=0.0)
	add_agent!( pos, abm, (0.0,0.0), ampl, freq, phase, ampl*sin(phase))
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!(wavesource, wavemodel)

Update wavesource's efield to correct value for current timestep.
"""
function agent_step!( ws::ESource, wm::ABM)
	ws.efield = ws.amplitude * sin(ws.phase + 2pi*ws.frequency*wm.t)
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(wavemodel)

Update all fields of wavemodel one timestep dt into the future.
"""
function model_step!( wm::ABM)
	sources = allagents(wm)
	srcfields = map(sources) do ws
		ws.efield
	end
	srcindices = map(sources) do ws
		get_spatial_index( ws.pos.-1, wm.EField, wm)
	end
	wm.EField[srcindices] = srcfields

	# E-field satisfies the Laplace equation: d2E/dt2 = c^2 * del^2(E):
	# First calculate first-order Euler change in E ...
	wm.BField = wm.BField + wm.dt * wm.c * wm.c * (
		0.25 .* (
			circshift(wm.EField,( 1,0)) + circshift(wm.EField,(0, 1)) +
			circshift(wm.EField,(-1,0)) + circshift(wm.EField,(0,-1))
		) - wm.EField
	) ./ (wm.dxy*wm.dxy)
	wm.BField *= (1-wm.attenuation*wm.dt)			# Attenuate the wave!

	# ... then calculate second-order change in E:
	wm.EField = wm.EField + wm.dt * wm.BField
	wm.EField[srcindices] = srcfields

	wm.t += wm.dt
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Create playground with two wave sources.
"""
function demo()
	wd = wavedynamics()

	params = Dict(
		:attenuation => 0:0.1:1
	)
	plotkwargs = (
		ac = :yellow,
		as = 20,
		heatarray = :EField,
		add_colorbar = false,
		heatkwargs = (
			colorrange = (-1,1),
			colormap = cgrad(:oslo),
		)
	)

	playground, = abmplayground( wd, wavedynamics;
		agent_step!, model_step!, params, plotkwargs...
	)

	playground
end

end