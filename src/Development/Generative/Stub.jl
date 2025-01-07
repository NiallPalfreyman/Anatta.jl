#========================================================================================#
"""
    Ecosystem

To do: Specify the Ecosystem module.

Author: Niall Palfreyman (January 2025)
"""
module Ecosystem

using Agents, GLMakie

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
    Turtle

To do: Define the Turtle Agent type.
"""
@agent struct Turtle(ContinuousAgent{2,Float64})
    speed::Float64						# My current speed
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
    ecosystem( extent=(60,60))

To do: Initialise the Ecosystem model.
"""
function ecosystem(; extent=(60,60))
    # To do: Define the ecosystem properties
    properties = Dict(
        :dt => 0.1          # Time-step interval for the model
    )

    ecosys = StandardABM(
        Turtle,
        ContinuousSpace(extent);
        agent_step!,
        properties
    )

    # To do: Initialise the agents
    add_agent!( ecosys, vel=(1,1), speed=5)

    return ecosys
end

#-----------------------------------------------------------------------------------------
"""
    agent_step!( Turtle, model)

To do: Define the Turtles' behaviour.
"""
function agent_step!( me::Turtle, model)
    # To do: Perceive

    # To do: Decide

    # To do: Act

    # To do: Move
    move_agent!( me, model, me.speed*model.dt)

    return
end

#-----------------------------------------------------------------------------------------
"""
    demo()

Demonstrate the Ecosystem model.
"""
function demo()
    # To do: Create exploration playground:
    playground, _ = abmexploration( ecosystem();
        agent_size = 10, agent_color = :red, agent_marker = :circle,
        params = Dict( :speed => 0.0:.1:1.0)
    )
    display(playground)

    # To do: Define presentation data:
    abm = ecosystem()
    adata = [(:speed, sum)]
    mdata = [:dt]
    agent_df, model_df = run!( abm, 5; adata, mdata)

    println("Agent data:")
    println(agent_df)
    println("Model data:")
    println(model_df)
end

end # ... of module Ecosystem