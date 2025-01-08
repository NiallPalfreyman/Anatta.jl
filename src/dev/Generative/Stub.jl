#========================================================================================#
"""
    Ecosystem

To-do: Specify the Ecosystem module.

Author: Niall Palfreyman (January 2025)
"""
module Ecosystem

using Agents, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
    Turtle

To-do: Define the Turtle Agent type.
"""
@agent struct Turtle(ContinuousAgent{2,Float64})
    speed::Float64						# My current speed
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
    max_speed   = 5.0,
    extent      = (60,60)
)
    # To-do: Define the ecosystem properties
    properties = Dict(
        :dt             => 0.1,         # Time-step interval for the model
        :n_turtles      => 5,           # Initial number of turtles
        :max_speed      => max_speed,   # Turtles' maximum speed
        :prob_regrowth  => 0.01,        # Probability of algae regrowth
        :E0             => 100.0,       # Maximum initial energy of a turtle
        :Δliving        => 1.0,         # Energy cost of living
        :Δeating        => 7.0          # Energy benefit of eating one alga
    )

    ecosys = StandardABM(
        Turtle,
        ContinuousSpace(extent);
        agent_step!,
        properties
    )

    # To-do: Initialise the agents
    for _ in 1:ecosys.n_turtles
        vel = (1,1)
        speed = ecosys.max_speed * rand()
        energy = ecosys.E0
        add_agent!( ecosys; vel, speed, energy)
    end

    ecosys
end

#-----------------------------------------------------------------------------------------
"""
    agent_step!( Turtle, model)

To-do: Define the Turtles' behaviour.
"""
function agent_step!( me::Turtle, model)
    # To-do: Perceive

    # To-do: Decide

    # To-do: Act

    # To-do: Move
    move_agent!( me, model, me.speed*model.dt)

    return
end

#-----------------------------------------------------------------------------------------
"""
    demo()

Demonstrate the Ecosystem model.
"""
function demo()
    params = Dict(
        # To-do: Specify model exploration parameters
        :max_speed      => 0.0:10.0,
    )
    kwargs = (
        # To-do: Specify plotting and data keyword arguments
        agent_size      = 10,
        agent_color     = :red,
        agent_marker    = :circle,
        adata           = [(:speed, sum)],
        mdata           = [:dt],
    )
    playground, _ = abmexploration( ecosystem(); params, kwargs...)
    display(playground)
end

end # ... of module Ecosystem