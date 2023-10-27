"""
	Skeleton

This simulation demonstrates how flow is enacted into structure by simulating the building
of a skeleton (Skeleton) by Osteocyte agents using Turing reaction-diffusion dynamics.

Author: Niall Palfreyman (July 2023)
"""
module Skeleton

include( "../../Tools/AgentTools.jl")

using Agents, GLMakie, InteractiveDynamics, Random, .AgentTools

#-----------------------------------------------------------------------------------------
# Module constants:
#-----------------------------------------------------------------------------------------
const SECRETION_RATE		= 0.001				# Agent-generated differentiation rate
const EXCITATION_RATE		= 0.2				# Interaction-generated differentiation rate
const TRAINING_RATE			= 1.0				# Training-generated differentiation rate
const STEP_LENGTH			= 0.1				# Length of a single Osteocyte step
const ACCELERATION			= 0.1				# Acceleration factor
const TOLERANCE				= 0.1				# Minimum detectable change in concentration
const TEMPERATURE			= 0.01				# Skeleton temperature: Source of thermal jitter
const ACTIVATION_RADIUS		= 2					# Inner radius of activation
const INHIBITION_RADIUS		= 4					# Outer radius of inhibition
const INHIBITION_WEIGHT		= 0.3				# Weighting of inhibition ring
const DT					= 1.0				# Simulation timestep length
const POPULATION_DENSITY	= 10				# Number of Osteocytes per patch
const WORLD_WIDTH			= 40				# Width of Skeleton
const GENS_PER_SCENARIO		= 30				# Number of cycles per training scenario
const SCENARIOS_PER_EPOCH	= 2					# Number of training scenarios per epoch
const EPOCHS_PER_REGIME		= 50				# Number of epochs in entire training regime

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Osteocyte

An Osteocyte moves with a certain probability, and secretes a chemical activator.
"""
@agent Osteocyte ContinuousAgent{2} begin
	speed::Float64					# Osteocyte's current speed
	secretion_rate::Float64			# Rate of secretion of activator/inhibitor
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	create_skeleton( kwargs)

Initialise the Skeleton reaction-diffusion system.
"""
function create_skeleton(;
)
	width = WORLD_WIDTH
	extent = (width,width)
	properties = Dict(
		:differentiation 	=> zeros(Float64,extent...),
		:activators 		=> fill(Int[],extent),
		:inhibitors			=> fill(Int[],extent),
		:population_density	=> POPULATION_DENSITY,
		:secretion_rate		=> SECRETION_RATE,
		:generation			=> 0,
		:scenario			=> 1,
		:epoch				=> 1,
		:temperature		=> TEMPERATURE,
		:training			=> true,
		:training_set		=> Vector{Vector{Int}}(),
		:testing_set		=> Vector{Vector{Int}}(),
	)

	skeleton = ABM( Osteocyte, ContinuousSpace(extent,spacing=1.0); properties)

	# Set up activation and inhibition neighbourhoods:
	for i in 1:width, j in 1:width
		# Inner circle of activating next-door neighbours:
		skeleton.activators[i,j] = nearby_patches(
			(i,j), skeleton, (ACTIVATION_RADIUS,ACTIVATION_RADIUS)
		)
		# Outer circle of inhibiting distant neighbours:
		skeleton.inhibitors[i,j] = setdiff(
			nearby_patches( (i,j), skeleton, (INHIBITION_RADIUS,INHIBITION_RADIUS)),
			skeleton.activators[i,j]
		)
	end

	# Insert all agents:
	for _ in 1:POPULATION_DENSITY*prod(extent)
		# Baby emilies have maximum (unit) speed in a random direction:
		θ = 2π * rand()
		add_agent!( Osteocyte, skeleton, (cos(θ),sin(θ)),
			1.0, SECRETION_RATE*(2rand() - 1)
		)
	end

	# Set up training and testing sets - 2 annuli centred either side of middle of space:
	middle = width ÷ 2
	r_outer = 1.5INHIBITION_RADIUS
	r_inner = r_outer - ACTIVATION_RADIUS
	centres = [(middle-2INHIBITION_RADIUS,middle),(middle+2INHIBITION_RADIUS,middle)]
	skeleton.training_set = map(centres) do centre
		# Return annulus around centre:
		setdiff(
			nearby_patches( centre, skeleton, (r_outer,r_outer)),
			nearby_patches( centre, skeleton, (r_inner,r_inner))
		)
	end
	skeleton.testing_set = map(skeleton.training_set) do tset
		# Only activate 1/4 of the annulus cells:
		shuffle(tset)[1:length(tset)÷4]
	end

	skeleton
end

#-----------------------------------------------------------------------------------------
"""
	agent_step!( ossie::Osteocyte, skeleton::ABM)

Osteocyte dynamics: Osteoblasts tend to climb differentiation gradients, while osteoclasts
tend to slide down them. This is achieved as follows:
	-	Osteoblasts deposit collagen; somersault if ambient collagen concentration is falling;
	-	Osteoclasts dissolve collagen; somersault if collagen concentration is rising;
	-	All Osteocytes decelerate if collagen concentration is unchanging;
	-	All Osteocytes decelerate if other Osteocytes are in the immediate neighbourhood;
	-	All Osteocytes add some random thermal acceleration.
"""
function agent_step!( ossie::Osteocyte, skeleton::ABM)
	# Gather local information:
	prev_idx = get_spatial_index( ossie.pos, skeleton.differentiation, skeleton)
	prev_differentiation = skeleton.differentiation[prev_idx]

	# Deposit either activator or inhibitor, then move on:
	if skeleton.secretion_rate != 0.0
		skeleton.differentiation[prev_idx] += ossie.secretion_rate*DT
	end
	if rand() < ossie.speed
		move_agent!( ossie, skeleton, STEP_LENGTH)
	end

	# Note step-change in local activator concentration:
	new_idx = get_spatial_index( ossie.pos, skeleton.differentiation, skeleton)
	delta_differentiation = skeleton.differentiation[new_idx] - prev_differentiation
	if osteoblast(ossie) && delta_differentiation < -TOLERANCE ||
			!osteoblast(ossie) && delta_differentiation > TOLERANCE
		# Somersault if local activator concentration is changing against my needs:
		turn!( ossie, 2π*rand())
		accelerate!( ossie, ACCELERATION)
	end

	# Slow down in presence of at least 5 like-minded neighbours:
	nbrs = collect(nearby_agents( ossie, skeleton, 0.1STEP_LENGTH))
	n_osteoblasts = count(osteoblast,nbrs)
	n_friends = osteoblast(ossie) ? n_osteoblasts : length(nbrs) - n_osteoblasts
	if n_friends > 5skeleton.population_density
		# Slow down for neighbours:
		accelerate!(ossie,-ACCELERATION)
	end

	# Add in some random jitter:
	if rand() < skeleton.temperature
		accelerate!(ossie)
	end
end

#-----------------------------------------------------------------------------------------
"""
	model_step!(skeleton)

Skeleton dynamics: Allow both A and I to react, evaporate and diffuse.
"""
function model_step!( skeleton::ABM)
	for i in shuffle(1:length(skeleton.differentiation))
		# Calculate logistic squashing of neighbours' excitatory influence on my differentiation:
		nbrhd_excitation = EXCITATION_RATE * DT * logistic(
			sum( skeleton.differentiation[skeleton.activators[i]]) -
				INHIBITION_WEIGHT * sum( skeleton.differentiation[skeleton.inhibitors[i]])
		)

		# ... then adjust differentiation level towards either 0.0 or 1.0:
		if nbrhd_excitation < 0
			# Down towards 0.0:
			skeleton.differentiation[i] += nbrhd_excitation * (skeleton.differentiation[i] - 0.0)
		else
			# Up towards 1.0:
			skeleton.differentiation[i] += nbrhd_excitation * (1.0 - skeleton.differentiation[i])
		end
	end

	# Training:
	orchestrate!( skeleton)
end

#-----------------------------------------------------------------------------------------
"""
	nearby_patches( centre::Tuple, skeleton::ABM, r::Tuple)

Return a Vector of all indices of skeleton model within range r from a centre location.
Note: This implementation is still quite inefficient and only works for 2d spaces.
"""
function nearby_patches( centre::Tuple, skeleton::ABM, r::Tuple)
	# Set up neighbourhood Cartesian indices:
	rsq = r.^2
	rint = (s->round(Int,s)).(r)
	nbhd = [(i,j)
		for i in -rint[1]:rint[1], j in -rint[2]:rint[2]
			if (i^2/rsq[1] + j^2/rsq[2] ≤ 1.0)
	]
	setdiff!(nbhd,[(0,0)])						# We only want neighbours - not the centre

	# Displace (0,0)-based neighbourhood locations to the centre location:
	cint = (s->round(Int,s)).(centre)
	disc = map(nbhd) do pt
		cint .+ pt
	end

	# Extract linear matrix indices for the neighbourhood locations:
	ext = Int.(skeleton.space.extent)
	ind = LinearIndices((w->1:w).(ext))

	map(disc) do tupl
		ind[mod(tupl[1]-1,ext[1])+1,mod(tupl[2]-1,ext[2])+1]
	end
end

#-----------------------------------------------------------------------------------------
"""
	accelerate!( ossie::Osteocyte, accn::Float64=1.0)

If ossie is positively accelerating, increase speed; otherwise slow down.
"""
function accelerate!( ossie::Osteocyte, accn::Float64=1.0)
	if accn > 0.0
		ossie.speed += accn * (1.0-ossie.speed)
	else
		ossie.speed *= (1.0+accn)
	end
end

#-----------------------------------------------------------------------------------------
"""
	logistic( y::Real)

Calculate logistic squashing function of Real value y.
"""
function logistic( y::Real)
	expy = exp(y)
	2expy/(1+expy) - 1
end

#-----------------------------------------------------------------------------------------
"""
	osteoblast( ossie::Osteocyte)

Does this Osteocyte build up the differentiation level with a positive secretion_rate?
"""
function osteoblast( ossie::Osteocyte)
	ossie.secretion_rate > 0
end

#-----------------------------------------------------------------------------------------
"""
	agent_colour( ossie::Osteocyte)

Osteoblasts are blue; non-osteoblasts are red.
"""
function agent_colour( ossie::Osteocyte)
	if osteoblast(ossie)
		:red
	else
		:lime
	end
end

#-----------------------------------------------------------------------------------------
"""
	tick!( skeleton::Skeleton)

Step the skeleton's time-clock (generation,scenario,epoch) forward one tick.
"""
function tick!( skeleton::ABM)
	skeleton.generation += 1

	if skeleton.training
		if skeleton.generation > GENS_PER_SCENARIO
			skeleton.generation = 1
			skeleton.scenario += 1
		end
		if skeleton.scenario > SCENARIOS_PER_EPOCH
			skeleton.scenario = 1
			skeleton.epoch += 1
		end
		if skeleton.epoch > EPOCHS_PER_REGIME
			skeleton.generation = 1
			skeleton.scenario = 1
			skeleton.epoch = 1
			skeleton.training = false
			skeleton.temperature /= 100.0
		end
	else
		if skeleton.generation > GENS_PER_SCENARIO
			skeleton.generation = 1
			skeleton.scenario += 1
		end
		if skeleton.scenario > SCENARIOS_PER_EPOCH
			skeleton.scenario = 1
			skeleton.epoch += 1
		end
	end
end

#-----------------------------------------------------------------------------------------
"""
	orchestrate!( skeleton::Skeleton)

Orchestrate the training and testing regime: tick!() time forwards, advance training scenario,
and move to testing after training has completed requisite number of EPOCHS_PER_REGIME.
"""
function orchestrate!( skeleton::ABM)
	tick!( skeleton)

	dollop = TRAINING_RATE * DT
	if skeleton.epoch == 1 && skeleton.scenario == 1 && skeleton.generation == 1
		skeleton.differentiation[:] .= 0.0
	end
	if skeleton.training
		# Conduct a training regime:
		if skeleton.scenario == 1
			# Conduct first training scenario:
			skeleton.differentiation[skeleton.training_set[1]] .+= dollop
		else
			# Conduct second training scenario:
			skeleton.differentiation[skeleton.training_set[2]] .+= dollop
		end
	else
		# Conduct a testing regime:
		if skeleton.scenario == 1
			# Conduct first testing scenario:
			skeleton.differentiation[skeleton.testing_set[1]] .+= dollop
		else
			# Conduct second testing scenario:
			skeleton.differentiation[skeleton.testing_set[2]] .+= dollop
		end
	end
end

#-----------------------------------------------------------------------------------------
"""
	run()

Create and run a playground with a complete Skeleton full of Ossie Osteocyte babies.
"""
function run()
	skeleton = create_skeleton()
	params = Dict(
		:population_density	=> 0:0.1:5,
	)
	plotkwargs = (
		am = :circle,
		ac = agent_colour,
		as = 15,
		heatarray = :differentiation,
		add_colorbar = false,
		spu = 1:20,
	)

	playground, = abmplayground( skeleton, create_skeleton;
		agent_step!, model_step!, params, plotkwargs...
	)

	playground
end

end