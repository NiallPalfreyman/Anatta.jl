module Ecosystem
using Agents, GLMakie, GeometryBasics

@agent struct Turtle(ContinuousAgent{2,Float64})
end

function agent_step!( me::Turtle, model)
    remove_agent!( me, model)
    return
end

wedge( agent) = Polygon( Point2f.([[1,0],[-0.5,0.5],[-0.5,-0.5]]))

xvel( me::Turtle) = me.vel[1]

abm = StandardABM( Turtle, ContinuousSpace((60,60)); agent_step!)
add_agent!( abm; vel=[1,1])
playground, _ = abmexploration( abm; adata=[(xvel, sum)], agent_marker=:circle)
display(playground)
end