#========================================================================================#
"""
	IRGames

Module IRGames: Dynamical model demonstrating the stabilisation of integral-rein players.

Author: Niall Palfreyman, 28/12/2023
"""
module IRGames

using GLMakie

const K_DELTA = 0.1			# Upper bound on K-variation
const K_UPB = 2.0			# Upper bound on K-magnitude
const K_LWB = 0.1			# Lower bound on K-magnitude
const P_UPB = 3.0			# Upper bound on Player state value
const R_UPB = 10.0			# Upper bound on Resource value
const RELAXATION = 50		# Duration of relaxation between successive variations
const INIT_VALUE = 0.001	# Initial value of all player states and resource
const ALPHA = 0.1			# Depletion constant of players' state

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	IRPlayer

An IRPlayer is a single player in an IRGame, characterised by a Michaelis-Menten half-saturation
constant K and a current state u.
"""
mutable struct IRPlayer
	K::Float64
	u::Float64
	u0::Float64

	function IRPlayer( K::Float64=4(2rand()-1), u0::Float64=INIT_VALUE)
		new(K,u0,u0)
	end
end

#-----------------------------------------------------------------------------------------
"""
	IRGame

An IRGame is a collection of N IRPlayers playing a shared, iterated integral-rein game.
"""
mutable struct IRGame
	players::Vector{IRPlayer}
	abstraction::Float64
	resource::Float64
	t::Float64
	t0::Float64

	function IRGame(players::Vector{IRPlayer}=[IRPlayer(),IRPlayer()], resource=INIT_VALUE, t0=0.0)
		new(players,sum(conservation.(players)),resource,t0,t0)
	end
end

#-----------------------------------------------------------------------------------------
# IRPlayer methods:
#-----------------------------------------------------------------------------------------
"""
	conservation( irp::IRPlayer)

Calculate the conservation quantity of this IRPlayer.
"""
function conservation( irp::IRPlayer)
	abs(irp.K) * irp.u
end

#-----------------------------------------------------------------------------------------
# IRGame methods:
#-----------------------------------------------------------------------------------------
"""
	state( irg::IRGame)

Report the current state of this game.
"""
function state( irg::IRGame)
	[[irg.abstraction,irg.resource];(p->p.u).(irg.players)]
end

#-----------------------------------------------------------------------------------------
"""
	euler( us, resource, Ks, abstraction, t) → (du, d_resource)

Develop the current state [us;resource] at time t through a single Euler time-step Δt, using
the parameters [Ks;abstraction].
"""
function euler( us, resource, Ks, abstraction, t)
	balancing_feedback = saturation(abstraction,-1)
	du = (balancing_feedback*phi(resource,Ks) .- ALPHA) .* us
	d_resource = supply(t) - resource - sum(Ks.*us)

	(du,d_resource)
end

#-----------------------------------------------------------------------------------------
"""
	step!( irg::IRGame, Δt)

Develop the IRGame through a single Runge-Kutta-2 time-step Δt.
"""
function step!( irg::IRGame, Δt)
	us_initial = (p->p.u).(irg.players)
	Ks = (p->p.K).(irg.players)

	# RK2 half-step:
	du,d_res = euler( us_initial, irg.resource, Ks, irg.abstraction, irg.t)
	dt2 = Δt/2.0
	us_halfstep = us_initial + du*dt2
	res_halfstep = irg.resource + d_res*dt2

	# RK2 full-step:
	du,d_res = euler( us_halfstep, res_halfstep, Ks, conservation(Ks,us_halfstep), irg.t+dt2)
	us_fullstep = us_initial + du*Δt
	setfield!.(irg.players,:u,us_fullstep)
	irg.resource += d_res*Δt
end

#-----------------------------------------------------------------------------------------
"""
	trajectory( irg::IRGame, T; Δt=0.1) → (u, t)

Develop the game forward from the current instant through given time duration T.
(Modelled on DynamicalSystems.trajectory)
"""
function trajectory( irg::IRGame, T::Real; Δt=0.1)
	num_ts = Int(round(T/Δt))+1									# Allow for roundng errors in t
	tfinal = round(irg.t+T,digits=3)
	ts = range(irg.t,tfinal,length=num_ts)
	Δt = step(ts)

	n_dims = length(irg.players) + 2							# Set up trajectory states to store,
	us = [Vector{Float64}(undef,n_dims) for _ in 1:num_ts]		# including resource, conservation
	us[1] = state( irg)
	Ks = (p->p.K).(irg.players)

	for i in 2:num_ts
		step!(irg,Δt)											# Take next step ...

		irg.resource = max(0.0,min(R_UPB,irg.resource))			# Repair values outside boundaries
		stocks = max.( 0.0, min.( P_UPB, (p->p.u).(irg.players)))
		setfield!.( irg.players, :u, stocks)
		irg.abstraction = conservation(Ks,stocks)
		irg.t = round(irg.t+Δt,digits=3)
	
		us[i] = [[irg.abstraction,irg.resource];stocks]			# Store new state
	end

	return (us, ts)
end

#-----------------------------------------------------------------------------------------
"""
	conservation( irg::IRGame)

Calculate the conservation quantity of this IRGame.
"""
function conservation( irg::IRGame)
	sum(conservation.(irg.players))
end

#-----------------------------------------------------------------------------------------
"""
	vary!( irgame, mu::Float64=1.0)

Vary this IRGame: With probability mu, vary the Ks by up to an amount K_DELTA within the default
wrap-domain.
"""
function vary!( irg::IRGame, mu::Float64=-1.0)
	if mu < 0.0
		mu = instability(irg)
	end

	if mu >= 1.0 || rand() < mu
		setfield!.(
			irg.players, :K, wrap.(
				(p->p.K).(irg.players) + K_DELTA*(2rand(length(irg.players)).-1)
			)
		)
	end

	irg.abstraction = conservation(irg)
end

#-----------------------------------------------------------------------------------------
"""
	instability( irg::IRGame)

Determine the instability of the current resource level in an IRGame.
"""
function instability( irg::IRGame)
	min( 1.0, abs(irg.resource-1.0)^3)
end

#-----------------------------------------------------------------------------------------
"""
	report( irg::IRGame) → String

Report current status of the IRGame.
"""
function report( irg::IRGame)
	"Abstraction=$(irg.abstraction), Resource=$(irg.resource), Instability=$(instability(irg)):" *
		"\n$((p->p.K).(irg.players)), $((p->p.u).(irg.players))"
end

#-----------------------------------------------------------------------------------------
# Module-level utilities:
#-----------------------------------------------------------------------------------------
"""
	conservation( Ks, us)

Calculate the conservation quantity of two Vectors of Ks and us.
"""
function conservation( Ks::Vector{Float64}, us::Vector{Float64})
	sum(abs.(Ks) .* us)
end

#-----------------------------------------------------------------------------------------
"""
	pruning( Ks, states)

Calculate the total pruning due to the given Ks and states
"""
function pruning( Ks, states)
	sum(Ks.*states)
end

#-----------------------------------------------------------------------------------------
"""
	phi( resource, Ks)

Calculate the phi function of the current resource level wrt each of the given Ks.
"""
function phi( resource, Ks)
	map(K->saturation(resource,K),Ks)
end

#-----------------------------------------------------------------------------------------
"""
	saturation( s::Real, K=1.0, n=1.0)

Return the Hill saturation function of a signal s, half-saturation constant K and cooperation n.
"""
function saturation( s, K::Real=1.0, n::Real=1.0)
	if K == 0
		return 0.5
	end

	abs_K = abs(K)
	if n != 1
		n = float(n)
		abs_K = abs_K^n
		s = s.^n
	end

	abs_saturation = abs_K ./ (abs_K .+ s)
	
	(K < 0) ? abs_saturation : (1 .- abs_saturation)
end

#-----------------------------------------------------------------------------------------
"""
	supply( t::Real)

Return a square-wave resource supply rate for the given time t.
"""
function supply( t::Real; period=177.0, lo=0.75INIT_VALUE, hi=1.25INIT_VALUE)
	(rem(t÷(period/2),2)>0) ? hi : lo
end

#-----------------------------------------------------------------------------------------
"""
	wrap( k::Real)

	Wrap the number k into the permissible K-range [-K_UPB,-K_LWB] U [K_UPB,K_LWB].
"""
function wrap( k::Real)
	span = float(K_UPB - K_LWB)

	if -K_UPB<=k<=-K_LWB || K_LWB<=k<=K_UPB
		return float(k)
	elseif -K_LWB<k<0.0
		return float(k + 2K_LWB)
	elseif 0.0<k<K_LWB
		return float(k - 2K_LWB)
	elseif K_UPB<k<K_UPB+span
		return float(k - 2K_UPB)
	elseif -(K_UPB+span)<k<-K_UPB
		return float(k + 2K_UPB)
	end

	K = mod((k+span),2span)-span
	(K<0) ? span-K_LWB : span+K_LWB
end

#-----------------------------------------------------------------------------------------
"""
	rand_player(n::Int)

Generate a Vector of n IRPlayers with random Ks within the range [-K_UPB,K_UPB].
"""
function rand_player( n::Int=1)
	n = max(n,1)
	map(rand(n)) do r
		IRPlayer((2r-1)*K_UPB)
	end
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Build and run the IRGame.
"""
function demo()
	println("\n============ Demonstrating an N-player IRGame ===============")
	irgame = IRGame([IRPlayer(K_LWB+rand()*(K_UPB-K_LWB)) for _ in 1:200])
	ustore,tstore = trajectory(irgame,RELAXATION)
	println( report(irgame))
	println()

	for n in 1:999
		vary!(irgame)
		u,t = trajectory(irgame,RELAXATION)
		push!(ustore,u[2:end]...)
		tstore = range(first(tstore),last(t),length=length(ustore))
		if mod(n,100)<0
			println(report(irgame))
		end
	end
	println(report(irgame))
	println()

	fig = Figure(fontsize=30,linewidth=5)
	ax = Axis(fig[1,1], xlabel="time", title="BOTG")
	lines!( tstore, (u->u[1]).(ustore), label="Abstraction")
	lines!( tstore, (u->u[2]).(ustore), label="Resource")
	n_dims = length(ustore[1])
	for i in 3:n_dims
		if abs(ustore[end][i]) > 0.1
			lines!( tstore, (u->u[i]).(ustore), label="Player $(i-2)")
		end
	end
	Legend( fig[1,2], ax)
	display( fig)
	fig
end

end