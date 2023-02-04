module Test

using Agents, GLMakie, InteractiveDynamics
using Random:bitrand

@agent Turtle ContinuousAgent{2} begin
	speed::Float64
end

function agent_step!( turtle, model)
	cs,sn = (x->(cos(x),sin(x)))((2rand()-1)*pi/15)
	turtle.vel = Tuple([cs sn;-sn cs]*collect(turtle.vel))
	move_agent!( turtle, model, turtle.speed)
end

function demo()
	dims = (30,30)
	world = ContinuousSpace(dims, spacing=1.0)
	model = ABM( Turtle, world; properties=Dict(:food => bitrand(dims)))
	foodmap(modl) = modl.food

	for _ in 1:50
		vel = (x->(cos(x),sin(x)))(2π*rand())
		add_agent!( model, vel, 1.0)
	end

	abmvideo(
		"Test.mp4", model, agent_step!;
		framerate = 50, frames = 200,
		ac=:blue, as=20, am=:circle,
		heatarray=foodmap,
	)
end

end