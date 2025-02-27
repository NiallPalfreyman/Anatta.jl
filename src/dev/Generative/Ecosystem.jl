#========================================================================================#
"""
    Ecosystem

To-do: Specify the Ecosystem module.

Author: Niall Palfreyman (January 2025)
"""
module Ecosystem
include( "../../Development/Generative/AgentTools.jl")
using Agents, GLMakie, .AgentTools

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
    Turtle

To-do: Define the Turtle Agent type.
"""
@agent struct Turtle(ContinuousAgent{2,Float64})
    energy::Float64						# My current energy
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
    ecosystem( extent=(60,60))

To-do: Initialise the Ecosystem model.
"""
function ecosystem(;
    dt          = 0.1,          # Time-step interval for the model
    n_turtles   = 5,            # Initial number of turtles
    v0          = 5.0,          # Maximum initial speed of Turtles
    E0          = 20,           # Maximum initial energy of Turtles
    Δliving     = 1.0,          # Energy cost of living
    Δeating     = 10.0,         # Energy benefit of eating one alga
    extent      = (60,60)       # Spatial extent of the model
)
    # To-do: Initialise the model properties
    properties = Dict(
        :dt             => dt,
        :n_turtles      => n_turtles,
        :v0             => v0,
        :E0             => E0,
        :Δliving        => Δliving,
        :Δeating        => Δeating,
        :algae          => falses(extent),
        :prob_regrowth  => 0.0001,
    )
    ecosys = StandardABM(
        Turtle,
        ContinuousSpace(extent);
        agent_step!,
        model_step!,
        properties
    )

    # To-do: Initialise the agents
    for _ in 1:ecosys.n_turtles
        vel = ecosys.v0 * rand() * (x->[cos(x),sin(x)])(2π*rand())
        energy = rand(1:ecosys.E0)
        add_agent!( ecosys; vel, energy)
    end

    ecosys
end

#-----------------------------------------------------------------------------------------
"""
    agent_step!( Turtle, model)

One step in the life of a Turtle:
	- Move forward,
	- Eat algae if there is one here,
	- Die if my energy is below zero and reproduce if my energy is above model's initial_energy.
"""
function agent_step!( me::Turtle, model)
    # To-do: Set state
    if nagents(model) > 1
        me.energy -= model.Δliving * model.dt
        if me.energy < 0
            remove_agent!( me, model)
            return
        end
    end

    # To-do: Perceive

    # To-do: Decide

    # To-do: Act
    reproduce!( me, model)
    eat!( me, model)

    # To-do: Move
    cs,sn = (x->(cos(x),sin(x)))((2rand()-1)*pi/15)
    me.vel = [cs -sn;sn cs]*collect(me.vel)
    move_agent!( me, model, model.dt)

    return
end

#-----------------------------------------------------------------------------------------
"""
	eat!( turtle, model)

Eat the algae at turtle's current position if there are any, and receive a feeding-benefit towards
my own energy. Remove algae from current location.
"""
function eat!( turtle, model)
    indices = get_spatial_index( turtle.pos, model.algae, model)
    if model.algae[indices]
        turtle.energy += model.Δeating
        model.algae[indices] = false
    end
end

#-----------------------------------------------------------------------------------------
"""
	reproduce!( parent, model)

Create a child with the same properties as the parent. Reproduction costs the parent the
model's initial_energy, which is then given to the child.
"""
function reproduce!( parent::Turtle, model)
    if parent.energy > model.E0 && rand() < 0.01
        parent.energy -= model.E0
        add_agent!( parent.pos, model, parent.vel, model.E0)
    end
end

#-----------------------------------------------------------------------------------------
"""
	model_step!( model)

At each currently empty algae location, allow an alga to regrow with a certain probability.
"""
function model_step!( model)
    empties = .!model.algae
    model.algae[empties] .= (rand(count(empties)).<model.prob_regrowth)
end

#-----------------------------------------------------------------------------------------
"""
    demo()

Demonstrate the Ecosystem model.
"""
function demo()
    params = Dict(
        # To-do: Specify model exploration parameters
        :prob_regrowth	=> 0:0.0001:0.01,
        :E0	            => 10.0:200.0,
        :Δeating        => 0:0.1:10.0,
        :Δliving        => 0:0.1:10.0,
    )
    plotkwargs = (
        # To-do: Specify plotting keyword arguments
        agent_size      = 10,
        agent_color     = :red,
        agent_marker    = wedge,
		heatarray       = (model->+model.algae),
		heatkwargs      = (colormap=[:black,:lime],colorrange=(0,1)),
        add_colorbar    = false,
        adata=[(a->isa(a,Turtle),count)], alabels=["Turtles"],
        mdata=[(m->sum(m.algae))], mlabels=["Algae"],
    )
    playground, _ = abmplayground( ecosystem; params, plotkwargs...)
    display(playground)
end

end # ... of module Ecosystem