#========================================================================================#
"""
    Schelling

This module reproduces Schelling's segregation model

Author: Niall Palfreyman (November 2024)
"""
module Schelling

using Agents
using Statistics: mean

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
    Scheller

A Scheller is a very simple Agent existing in a 2-dimensional space, inheriting internal state
position and speed, plus the new states happy and group.
"""
@agent struct Scheller(GridAgent{2})
    happy::Bool = false			            # All agents start life sad
    group::Int					            # The agent's group has no default value
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
    schelling()

Initialise a Schelling model.
"""
function schelling(;
    worldsize=20
)
    properties = Dict(
        :min_to_be_happy => 3
    )

    schell = StandardABM( Scheller, GridSpace((worldsize, worldsize)); agent_step!, properties)

    n_agents = round(0.75(worldsize^2))
    for n in 1:n_agents
        # Place an agent at a random unique location in grid-space:
        add_agent_single!( schell; group = (n < n_agents/2) ? 1 : 2)
    end
    
    return schell
end

#-----------------------------------------------------------------------------------------
"""
    agent_step!( scheller, model)

Define the evolution rule: a function that acts once per step on each activated Scheller agent.
"""
function agent_step!( scheller::Scheller, model)
    minhappy = model.min_to_be_happy
    count_group_nbrs = 0

    # Count number of neighbours in my group:
    for nbr in nearby_agents( scheller, model)
        if scheller.group == nbr.group
            count_group_nbrs += 1
        end
    end

    if count_group_nbrs ≥ minhappy
        scheller.happy = true                       # Happy! Stick around!
    else
        scheller.happy = false                      # Sad! Move on!
        move_agent_single!( scheller, model)
    end
    return
end

#-----------------------------------------------------------------------------------------
"""
    demo()

Demonstrate the Schelling model.
"""
function demo()
    schell = schelling()
    xpos(agent) = agent.pos[1]
    adata = [(:happy, sum), (xpos, mean)]
    adf, _ = run!( schell, 5; adata)

    adf
end

end # ... of module Schelling