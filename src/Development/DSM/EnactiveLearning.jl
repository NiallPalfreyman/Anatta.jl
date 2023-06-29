"""
    Enactive Learning
    Model of a Turing system where generation of activator and inhibitor are separated from each other.
    Activator is produced by agents and inhibitor is produced by the world.
    Based on the feedback loop the agents have, they should search for high concentration and other places with many agents.
    Their position should stabilize there.

Authors: Stefan Simmeth, Felix Brabänder, Maximilian Meyer
Date: June 2023
"""
module EnactiveLearning

include( "../../Tools/AgentTools.jl")


using Agents, .AgentTools, GLMakie, Random


const SMALL = 10^-5
const WIDTH = 100                 # global const for size of playground

#-----------------------------------------------------------------------------------------

@agent Atom ContinuousAgent{2} begin

    secretion_rate::Float64       # sectretion amount of activator 
    speed::Float64                # how fast the agents starts
    flow::Float64                 # saves the concentration of activator from the prevous step

end

#-----------------------------------------------------------------------------------------

function enactive_learning(
    a_diff_rate=0.01,                   # diffusion rate of activator 
    i_diff_rate=0.4,                    # diffusion rate of inhibitor
    a_evap_rate=0.01,                   # evaporation rate of activator
    i_evap_rate=0.03,                   # evaporation rate of inhibitor
    speed=0.5,                          # Starting speed of the Atoms
    gen=0,                              # Interation Counter
    activator=1e-4rand(WIDTH, WIDTH)    # Start concentration of activator in the world
)

    extent = (WIDTH, WIDTH)
    properties = Dict(
        :activator => activator,
        :inhibitor => 1e-4rand(WIDTH, WIDTH),
        :temp => activator,
        :a_diff_rate => a_diff_rate,
        :i_diff_rate => i_diff_rate,
        :a_evap_rate => a_evap_rate,
        :i_evap_rate => i_evap_rate,
        :dt => 0.5,
        :speed => speed,
        :gen => gen,
    )

    enl = ABM(Atom, ContinuousSpace(extent, spacing=1.0); properties)

    # Agents are placed evenly across the world
    for i in 0:1:99
        for j in 0:1:99
            add_agent!((i, j), Atom, enl,        # Agent, enl 
                (0.5, 0.5),                      # velocities
                0.2,                             # secretion_rate
                speed,                           # speed
                SMALL,                           # flow
            )
        end
    end

    return enl

end


#-----------------------------------------------------------------------------------------
"""
	agent_step!( atom, enl)

Express activator proteins.
And if activated, moves the agents based on the walk! and checkFlow function.

"""
function agent_step!(atom::Atom, enl::ABM)


    idx_here = get_spatial_index(atom.pos, enl.activator, enl)
    # enl.activator[idx_here] += atom.secretion_rate * enl.dt           # base sectretion of activator from Atom 

    enl.activator[idx_here] = enl.activator[idx_here] + enl.dt * enl.activator[idx_here]^2 / (enl.inhibitor[idx_here])

    # checkFlow!(atom, enl) # Activate for Version 6.2

end


#-----------------------------------------------------------------------------------------
"""
    walk!(atom, enl)

Determins the movement based upon the the change in activator concentration.

"""
function walk!(atom::Atom, enl)

    idx_here = get_spatial_index(atom.pos, enl.activator, enl)
    conc_here = enl.activator[idx_here] * 100


    if atom.flow < conc_here
        flow_change = -log(atom.flow / (conc_here + SMALL))
    else
        flow_change = 2 * exp(-(conc_here / atom.flow))
    end


    turn!(atom, rand(-flow_change:SMALL:flow_change))
    x = atom.vel .* atom.speed
    move_agent!(atom, enl, sqrt(x[1]^2 + x[2]^2))

end


#-----------------------------------------------------------------------------------------
"""
    checkFlow!(atom, enl) 

Checks the concentration of activator befor stepping and saves it in each agent.
Determins the speed of each agent based upon the amount of prevously recognised activator.

"""
function checkFlow!(atom::Atom, enl::ABM)
    atom.speed = 1 / (6 * atom.flow + 1)
    index = get_spatial_index(atom.pos, enl.activator, enl)
    atom.flow = enl.activator[index]
    walk!(atom, enl)
end


#-----------------------------------------------------------------------------------------
"""
	model_step!(enl)

Allow each location in the world to produce inhibitor.
Activator and inhibitor get diffused in the world. Some of them gets evaporated.
The step counter increases and get displayed.

"""
function model_step!(enl::ABM)


    #Inhibition from the world

    enl.inhibitor = enl.inhibitor + enl.dt .* enl.temp .^ 2      #Turing equation for inhibition using the activator value from the previous generation

    #Evaporation
    enl.activator *= (1 - enl.dt * enl.a_evap_rate)
    enl.inhibitor *= (1 - enl.dt * enl.i_evap_rate)

    # Diffusion:
    diffuse4_parallel!(enl.activator, enl.dt * enl.a_diff_rate)
    diffuse4_parallel!(enl.inhibitor, enl.dt * enl.i_diff_rate)

    #GenerationCounter
    enl.gen += 1

    if enl.gen % 1000 == 0
        println("Step: ", enl.gen)
    end

    enl.temp = enl.activator

end


#-----------------------------------------------------------------------------------------
"""
	demo()

Runs the simulation.

"""
function demo()
    enl = enactive_learning()

    params = Dict(
        :a_diff_rate => 0:0.001:0.025,
        :i_diff_rate => 0:0.001:1,
        :a_evap_rate => 0:0.001:0.1,
        :i_evap_rate => 0:0.001:0.1,
    )
    plotkwargs = (
        am=:circle,
        ac=:red,
        as=4,
        heatarray=:activator,
        add_colorbar=false,
        spu=1:20,
    )
    playground, abmobs = abmplayground(enl, enactive_learning;
        agent_step!, model_step!, params, plotkwargs...
    )

    # The right heatmap shows the inhibitor
    inhib = @lift($(abmobs.model).inhibitor)
    axhm, hm = heatmap(playground[1, 2], inhib; colormap=:binary)   # Other colors: magma, vikO100
    axhm.aspect = AxisAspect(1)                                     # equal aspect ratio for heatmap

    # https://juliadynamics.github.io/AgentsExampleZoo.jl/dev/examples/sugarscape/


    playground
end

end # module EnactiveLearning