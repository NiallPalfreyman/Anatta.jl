#========================================================================================#
"""
	Flows

This module illustrates how to implement and handle the presence of FLOWS in an agent's world
that can react, diffuse and evaporate. Such flows provide the topological structure around
which biological development occurs.

Author: Niall Palfreyman (March 2023), Dominik Pfister (July 2022)
"""
module Flows

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Turtle

An extremely simple agent that just sits in the world and poos endlessly.
"""
@agent Turtle ContinuousAgent{2} begin end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	flows()

Create the Flows world model.
"""
function flows(;
	extent	= (50, 50),		# Dimensions of the world
	dPoo	= 0.01,			# Diffusion rate of resource poo
	αPoo	= 0.001			# Evaporation rate of resource poo
)
	# Create the Flows space, properties and model:
	space = ContinuousSpace( extent, spacing=1.0)
	properties = Dict(
		:dPoo	=> dPoo,
		:αPoo	=> αPoo,
		:poo	=> zeros(Float64, extent)	# Heatmap of poo at each location in world
	)
	model = ABM( Turtle, space; properties, scheduler=Schedulers.randomly)

	# Insert one Turtle in the middle of the world, facing northwards:
	add_agent!( (25, 25), model, (0,1))

#=	turtle = Turtle(nextid(model), (25, 25), (0, 1))
	add_agent!(turtle, turtle.pos, model)=#

	return model
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!(turtle, model)

The turtle collects the resources at and in front of its current position, then pumps these
resources backwards, together with its own contribution.
"""
function agent_step!( turtle, model)
	idxHere = get_spatial_index( turtle.pos, model.poo, model)
	idxFwrd = get_spatial_index( normalize_position(turtle.pos.+turtle.vel,model),
		model.poo, model
	)
	idxBwrd = get_spatial_index( normalize_position(turtle.pos.-turtle.vel,model),
		model.poo, model
	)
#	println("Current pos = $(idxHere); Fwd pos = $(idxFwrd)")

	poo = 5.0									# Amount of poo I will pump backwards
	poo += model.poo[idxHere];	model.poo[idxHere] = 0.0
	poo += model.poo[idxFwrd];	model.poo[idxFwrd] = 0.0
	model.poo[idxBwrd] += poo

	move_agent!(turtle, model, 0.1)				# Step (slowly) forward ...
	turn!(turtle, 0.1(rand()-0.5))				# ... and turn a little
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(model)

Poo at every location diffuses through the world and evaporates by a constant fraction.
"""
function model_step!(model)
	model.poo[:] = ((1-model.αPoo) .* diffuse4( model.poo, model.dPoo))[:]
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Create a playground for visualising manipulation of poo flow by the Turtle.
"""
function demo()
	flowworld = flows()				# Model
	params = Dict(					# Sliders
		:dPoo => 0:0.001:0.02,
		:αPoo => 0:0.0001:0.002
	)
	plotkwargs = (					# Plotting parameters:
		ac=:red, 													# Turtle's colour
		as=10,														# Turtle's size
		am=wedge,													# Turtle's marker
		title = "Creation and manipulation of flows",				# Playground title
		heatarray=(model->model.poo), 								# Background map of poo
		heatkwargs = (colormap=:thermal, colorrange=(0.0,10.0)),	# Poo intensity colours
		add_colorbar=false,											# No need for poo colour bar
	)

	playground, = abmplayground( flowworld, flows;
		agent_step!, model_step!,
		params, plotkwargs...
	)

	playground
end

end # ... end of module Flow
