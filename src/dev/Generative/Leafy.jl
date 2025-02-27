#========================================================================================#
"""
    Leafy

This module generates an approximation to a noncomputable fern.

Author: Niall Palfreyman, February 2025.
"""
module Leafy
include( "../../Development/Generative/AgentTools.jl")

using Agents, GLMakie, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
    Builder

A Builder is a very simple Agent with no internal state other than the default properties id,
pos, vel. The only thing we really need from a Builder in this simulation is its position.
"""
@agent struct Builder(ContinuousAgent{2,Float64})
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
    leafy()

Initialise the Leafy model.
"""
function leafy(;
    extent		    = (15,15),      # Spatial extent of the model
    A1L22           = 0.16,         # 1st Linear transformation: element (2,2)
    A2L11           = 0.85,
    A2L12           = 0.04,
    A2T2            = 1.6,
    A3T2            = 1.6,
    A4T2            = 0.44,
)
    properties = Dict(
        :base_point		=> [extent[1]/2,0],
        :A1L22          => A1L22,
        :A2L11          => A2L11,
        :A2L12          => A2L12,
        :footprints		=> Vector{Point2f}(undef,0),
        :affine         => [
            (P -> [0.00 0.00;  0.00 A1L22]*P + [0.0,0.0]),
            (P -> [A2L11 A2L12; -A2L12 A2L11]*P + [0.0,A2T2]),
            (P -> [0.20 -0.26; 0.23 0.22]*P + [0.0,A3T2]),
            (P -> [-0.15 0.28; 0.26 0.24]*P + [0.0,A4T2]),
        ],
    )

    fern = StandardABM( Builder,
        ContinuousSpace(extent);
        agent_step!, model_step!,
        properties
    )

    # To-do: Initialise the agents
    add_agent!( Tuple(fern.base_point), fern, vel=[0.0,0.0])
    
    fern
end

#-----------------------------------------------------------------------------------------
"""
    agent_step!( builder, model)

Move particle towards a random vertex position.
"""
function agent_step!( builder, model)
	p = collect(builder.pos) - model.base_point
    dice = rand()
	if dice < 0.01
		p = model.affine[1](p)
	elseif dice < 0.86
		p = model.affine[2](p)
	elseif dice < 0.93
		p = model.affine[3](p)
	else
		p = model.affine[4](p)
	end
    
	move_agent!( builder, Tuple(p+model.base_point), model)
end

#-----------------------------------------------------------------------------------------
"""
    model_step!(model)

After all agents have moved one step, record their current position as a footprint.
"""
function model_step!(model)
    append!( model.footprints, [Point2f(p.pos) for p in allagents(model)])
end

#-----------------------------------------------------------------------------------------
"""
    demo()

Create an interactive playground for the Leafy model.
"""
function demo()
    params = Dict(
        # To do: Playground slider values:
        :A1L22      => 0.1:0.01:0.3,
        :A2L11      => 0.7:0.01:0.9,
        :A2L12      => -0.1:0.01:0.1,
    )

    # Create playground displaying all builders and sources:
    playground, abmobs = abmplayground( leafy; params,
        agent_color=:darkgreen, agent_size=20, agent_marker=:circle
    )

    # Add footprints to abmobs:
    scatter!( lift( (m->m.footprints), abmobs.model), color=:green, markersize=1)

    display(playground)
end

end # ... of module Leafy
