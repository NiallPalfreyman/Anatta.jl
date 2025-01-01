#========================================================================================#
"""
    Schelling

This module reproduces Schelling's model of segregation in social communities.

Author: Niall Palfreyman (December 2024)
"""
module Schelling

using Agents

# Learning activity - use Statistics.mean()
using Statistics: mean

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
    Person

A Person is a very simple Agent existing in a discrete 2-dimensional grid space. The @agent macro
ensures that the Person type autonmatically inherits the implicit state variables `id` and
`position`, and we explicitly add here the state variables `comfort` and `tribe`.
"""
@agent struct Person(GridAgent{2})
    comfort::Bool = false		            # All Persons start life feeling uncomfortable
    tribe::Int					            # Each Person's tribe (0/1) will need initialising
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
    schelling( comfort_threshold=1.0, worldsize=60)

Initialise the size, stepping function, properties and initial population of a Schelling model.
"""
function schelling( comfort_threshold=1.0, worldsize=60)
    # Learning activity - define comfort_threshold as a model property:
    properties = Dict(
        :comfort_threshold => comfort_threshold
    )

    schelling_model = StandardABM(
        Person,
        GridSpace((worldsize, worldsize));
        agent_step!,
        properties
    )

    # Learning activity - set n_agents to 80% of the total number of grid points:
#    n_agents = 0
    n_agents = round(0.8(worldsize^2))
    for n in 1:n_agents
        # Learning activity - place Persons of random tribe:
#        add_agent_single!( schelling_model; tribe=0)
        add_agent_single!( schelling_model; tribe=n%2)
    end

    return schelling_model
end

#-----------------------------------------------------------------------------------------
"""
    agent_step!( Person, model)

Define the evolution rule acting once per step on each activated Person agent:
    If my neighbourhood group contains at least a certain proportion of members of my own tribe,
    I feel comfortable; otherwise, I feel uncomfortable and react accordingly.
"""
function agent_step!( me::Person, model)
    # Count the proportion of neighbours belonging to my tribe:
    n_nbrs = n_mytribe = 0
    for nbr in nearby_agents(me,model)
        n_nbrs += 1
        if me.tribe == nbr.tribe
            n_mytribe += 1
        end
    end
    proportion_mytribe = (n_nbrs > 0) ? n_mytribe/n_nbrs : 0.0

    # Learning activity - decide how to react:
#    me.comfort = proportion_mytribe ≥ 1.0
    me.comfort = proportion_mytribe ≥ model.comfort_threshold

    # Learning activity - if uncomfortable, relocate to a random grid point:
    if !me.comfort
        move_agent_single!( me, model)
    end

    return
end

#-----------------------------------------------------------------------------------------
"""
    demo()

Demonstrate the Schelling model.
"""
function demo(comfort_threshold=1.0)
    abm = schelling(comfort_threshold)

    # Learning activity - define xpos as collectible data:
#    adata = [(:comfort, sum)]
    xpos(agent) = agent.pos[1]
    adata = [(:comfort, sum), (xpos, mean)]

    dataframe, _ = run!( abm, 9; adata)
    dataframe
end

end # ... of module Schelling