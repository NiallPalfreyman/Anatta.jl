include("atom.jl")
"""
world() creates a model of a torroid world and adds a number of agents to it.
"""
function world(;
	n_atoms = 200,					    # Number of Cell in model
	temperatur = 1.0,					# temperatur of the world, influences speed of the cells
	influenc_range = 5.0,               # influence range of Cell
    secretion_rate = 1.0,			    # Secretion of chemA
    consumption_rate = 1.0,             # Consumption of chemA 
	extent = (100, 100),			    # Extent of model space
)
	model = ABM( Cell, ContinuousSpace(extent; spacing=influenc_range/2);
		properties = Dict(			# Model properties applying to all Cell:
			:n_atoms			=> n_atoms,
			:influenc_range		=> influenc_range,
            :temperatur         => temperatur
		),
		scheduler = Schedulers.Randomly()
	)

	velocities = [Tuple(2rand(2) .- 1) for _ in 1:n_atoms]
	map( velocities) do vel
		add_agent!( cell, vel./norm(vel), speed, influenc_range, )
	end

	return model
end