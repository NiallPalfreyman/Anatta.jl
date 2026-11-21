#========================================================================================
	States

This module contains the definition of the type State for quantum computation.

Author: Niall Palfreyman, 30/10/2026
========================================================================================#
module States

# Externally callable symbols of the States module:
export State, @x_str, ket, bra, isket, isbra, qubit, ampl, phase, prob, maxprob, nbits,
		off, on, OFF, ON, normalise!, pure, mixed, uniform, bitstate, density
# Reexport Tensors:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Imports:
include( "Tensors.jl")
using .Tensors

#========================================================================================#
# Module types:
#-----------------------------------------------------------------------------------------
"""
	AmplitudeIndex

AmplitudeIndex is a logical vector for indexing the amplitudes of a qubit-based State.
"""
AmplitudeIndex = AbstractVector{Bool}

"@x_str: Create an AmplitudeIndex from an indexing String containing bit-values"
macro x_str(idx)
    :(BitVector($(c=='1' for c in idx)))
end

#-----------------------------------------------------------------------------------------
"""
	tomatrix( v)

Reduce a variety of structures to a canonical matrix form for implementing States and Operators.
"""
tomatrix(v::AbstractVector)		= reshape(collect(v), :, 1)		# Conversion to ket form
tomatrix(v::Tuple)				= reshape(collect(v), 1, :)		# Conversion to bra form
tomatrix(m::AbstractMatrix)		= Matrix(m)						# Conversion to Matrix

#-----------------------------------------------------------------------------------------
"""
	State

A State is a collection of one or more qubits entangled together in a Kronecker product.
"""
struct State <: Tensor{Complex,1}
	amp::Matrix{Complex}									# The State's amplitudes

	"Construct a State from the given amplitudes. The amplitudes are normalised to unit length."
	function State( amp::AbstractArray)
		amp = tomatrix(amp)
		len = length(amp)
		siz = size(amp)

		@assert( (len in siz), "States may contain only one dimension of amplitudes")

		log2len = log2(len)
		@assert( isclose(log2len,round(log2len)), "Number of State amplitudes must be a power of 2")

		nrm = sqrt(sum(abs2.(amp)))
		@assert( !isclose(nrm,0.0), "States must be non-zero")

		# Convert to normalised complex Vector in appropriate ket or bra mode
		new( ComplexF64.(amp/nrm))
	end

end

#========================================================================================#
# State constructors:
#-----------------------------------------------------------------------------------------
"Construct a ket-State from the given amplitudes."
ket( amp) = State(reshape(amp,:,1))
ket( amp...) = ket(collect(amp))

"Construct a bra-State from the given amplitudes."
bra( amp) = State(reshape(amp,1,:))
bra( amp...) = bra(collect(amp))

"Query whether State is a ket."
isket( s::State) = size(s.amp,2)==1

"Query whether State is a bra."
isbra( s::State) = size(s.amp,1)==1

#-----------------------------------------------------------------------------------------
"""
	qubit( alpha::Complex, beta::Complex)

Construct a single qubit State from precisely two given amplitudes.
"""
function qubit( alpha::Number, beta=nothing)
	if beta===nothing
		beta = sqrt(1.0 - alpha'*alpha)
	end

	State([alpha,beta])
end

#-----------------------------------------------------------------------------------------
"""
	qubit(; alpha=nothing, beta=nothing)

Construct a single qubit State from the named amplitudes.
"""
function qubit(; alpha=nothing, beta=nothing)
	if alpha === beta === nothing
		# Neither amplitude is given:
		error("alpha, beta or both are required.")
	end

	if alpha === nothing
		# alpha not given:
		alpha = sqrt(1.0 - beta'*beta)
	end

	qubit(alpha,beta)
end

#-----------------------------------------------------------------------------------------
"""
	pure( n::Int, i::Int)

Construct an n-qubit State pure in the i-th amplitude. That is, the State is |0...010...0>,
where the 1 is in the i-th position.
"""
function pure( n::Int, i::Int)
	ndims = 1 << n
	@assert( (n >= 1 && i in 1:ndims), "Invalid number of qubits or amplitude index")

	amp = zeros(Float64,ndims)
	amp[i] = 1.0
	State(amp)
end

"Construct an n-qubit State pure in a randomly selected amplitude."
pure( n::Int=1) = pure(n, rand(1:1<<n))

#-----------------------------------------------------------------------------------------
"""
	mixed( n::Int=1, amps::Union{AbstractVector,Tuple})

Construct an n-qubit State mixed in the specified amplitudes.
"""
function mixed( amps::Union{AbstractVector,Tuple})
	n = log2(length(amps))
	@assert( (isclose(n,round(n))), "Number of State amplitudes must be a power of 2")

	State(amps)
end

#-----------------------------------------------------------------------------------------
"""
	uniform( locations::BitVector)

Construct an n-qubit State with uniformly distributed amplitudes at the given locations.
"""
function uniform( locations::BitVector)
	n = log2(length(locations))
	@assert( (isclose(n,round(n))), "Number of State locations must be a power of 2")

	amps = zeros(ComplexF64,length(locations))
	amps[locations] .= exp.(im*2π*rand(count(locations)))	# Randomise phases of non-zero amplitudes
	State(amps)
end

"Construct an n-qubit State with all amplitudes uniformly distributed."
uniform( n::Int=1) = uniform(BitVector(trues(1<<n)))		# Randomly select a uniform state

#-----------------------------------------------------------------------------------------
"""
	off( n::Int=1)

Construct the n-bit OFF state |000...0>
"""
function off( n::Int=1)
	pure(n,1)
end

#-----------------------------------------------------------------------------------------
"""
	on( n::Int=1)

Construct the n-bit ON state |111...1>
"""
function on( n::Int=1)
	pure(n,1<<n)
end

#-----------------------------------------------------------------------------------------
"""
	bitstate( ax::AmplitudeIndex)

Construct a state that is true at the given bits.
"""
function bitstate( ax::AmplitudeIndex)
	bv = BitVector(ax)
	pure( length(bv), bits2dec(bv))
end

"Construct a state that is true at the given decimal value."
bitstate( idx::Int) = bitstate(dec2bits(idx))

"Construct a state that is true at the given bit arguments."
bitstate( ax::Bool...) = bitstate(ax)

#========================================================================================#
# Module methods:
#-----------------------------------------------------------------------------------------
# Delegated State methods:
Base.length(s::State) = length(s.amp)
Base.size(s::State) = size(s.amp)
Base.getindex(s::State,i::Integer) = getindex(s.amp,i)

#-----------------------------------------------------------------------------------------
"""
	getindex( s::State, ax::AmplitudeIndex)

Return the amplitude for qubit indexed by bits.
"""
function Base.getindex( s::State, ax::AmplitudeIndex)
	s[bits2dec(ax)]
end

"""
	getindex( s::State, ax::Bool...)

Return the amplitude specified by the given bit values.
"""
Base.getindex( s::State, ax::Bool...) = s[collect(ax)]

#-----------------------------------------------------------------------------------------
"""
	Base.kron( s1::State, s2::State)

Kronecker product of two States is itself a State.
"""
Base.kron( s1::State, s2::State) = State(kron(s1.amp,s2.amp))

#-----------------------------------------------------------------------------------------
"""
	Base.*( s1::State, s2::State)

Inner product of two States yields either a scalar (bra * ket) or a density matrix (ket * bra).
"""
function Base.:*( s1::State, s2::State)
	@assert( isket(s1) ⊻ isket(s2), "Cannot multiply ket with ket or bra with bra.")
	@assert( length(s1)==length(s2), "Cannot multiply States of different dimensionality.")

	s1.amp * s2.amp
end

#-----------------------------------------------------------------------------------------
"""
	Base.adjoint( s::State)

Return the adjoint of the state s.
"""
function Base.adjoint( s::State)
	State(collect(s.amp'))
end

#-----------------------------------------------------------------------------------------
"""
	phase( s::State, ax::AmplitudeIndex)

Return the phase of the amplitude of the qubit indexed by bits.
"""
function phase( s::State, ax::AmplitudeIndex)
	angle(s[ax])
end

phase( s::State, idx::Int) = angle(s[idx])
phase( s::State, ax::Bool...) = phase(s,collect(ax))

#-----------------------------------------------------------------------------------------
"""
	prob( s::State, ax::AmplitudeIndex)

Return probability for qubit indexed by bits.
"""
function prob( s::State, ax::AmplitudeIndex)
	abs2(s[ax])							# Calculate squared norm of ax-th amplitude
end

prob( s::State, ax::Bool...) = prob(s,collect(ax))

function prob( s::State, i::Int)
	abs2(s[i])							# Calculate squared norm of i=th amplitude
end

#-----------------------------------------------------------------------------------------
"""
	normalise!( s::State)

Normalise the state s (but throw an error if it's a zero state).
"""
function normalise!(s::State)
	nrm = sqrt(sum(abs2.(s.amp)))
	@assert( !isclose(n,0.0), "Attempted to normalise zero-State.")

	s /= nrm
end

#-----------------------------------------------------------------------------------------
"""
	nbits( stt::State)

Return number of qubits in this state.
"""
function nbits( s::State)
	Int(log2(length(s)))
end

#-----------------------------------------------------------------------------------------
"""
	maxprob( stt::State)

Return tuple (bitindex,prob) of highest probability qubit in this State.
"""
function maxprob( s::State)
	mxbits, mxprob = [], 0.0
	for bits in bitprod(nbits(s))
		thisprob = prob(s,bits)
		if thisprob > mxprob
			mxbits, mxprob = bits, thisprob
		end
	end

	(mxbits, mxprob)
end

#-----------------------------------------------------------------------------------------
"""
	bitprod( n::Int)

Return a list of all binary numbers containing n bits in numerical order.
"""
function bitprod(nbits::Int)
    [dec2bits(i,nbits) for i in 1:1<<nbits]
end

#-----------------------------------------------------------------------------------------
"""
	string( s::State)

Convert the State s to a String.
"""
function Base.string( s::State)
	str = (isket(s) ? "ket" : "bra") * "-State{" * string(nbits(s)) * "}["
	for i in 1:length(s)-1
		str = str * "$(round(s[i],digits=4)), "
	end
	str = str * "$(round(s[end],digits=4))]"
end

Base.String( s::State) = string(s)

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, s::State)

Display the given State.
"""
function Base.show( io::IO, s::State)
	print( io, string(s))
end

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, ::MIME"text/plain", s::State)

Display the given State in verbose form.
"""
function Base.show( io::IO, ::MIME"text/plain", s::State)
	len = length(s)
	nb = nbits(s)

	println( io, nb, "-qubit, ", len, "-amplitude ", (isket(s) ? "ket" : "bra"), "-State:")
	for bits in bitprod(nb)
		ampl = s[bits]
		println( io, " ",
			bits2str(bits), " : ", rpad(round(ampl,digits=4),18),
			": prob=", rpad(round(abs(ampl'*ampl),digits=4),7),
			": phase=", round(angle(ampl),digits=4)
		)
	end
end

#========================================================================================#
# State constants:
#-----------------------------------------------------------------------------------------
"""
	OFF = off(1)

The OFF qubit.
"""
const OFF = off(1)

#-----------------------------------------------------------------------------------------
"""
	ON = on(1)

The ON qubit.
"""
const ON = on(1)

#========================================================================================#
# Helper methods:
#-----------------------------------------------------------------------------------------
"""
	bits2str( ax::AmplitudeIndex)

Format bit vector as string
"""
function bits2str( ax::AmplitudeIndex, npad::Int=2)
	"|" * string([+s for s in ax]...) * "> == |" * lpad(string(bits2dec(ax)), npad) * ">"
end

bits2str(ax::Bool...) = bits2str(ax)

#-----------------------------------------------------------------------------------------
"""
	bits2dec( ax::AmplitudeIndex)

Compute decimal representation of a AmplitudeIndex.
"""
function bits2dec( ax::AmplitudeIndex)
	ax = bitvec(ax)
	1+sum( v * (1 << (length(ax)-i)) for (i,v) in enumerate(ax))
end

bitvec(ax::AmplitudeIndex)				= BitVector(ax)
bitvec(idx::AbstractVector{<:Integer})	= BitVector(idx .!= 0)

#-----------------------------------------------------------------------------------------
"""
	dec2bits( ndec::Int, nbits::Int)

Compute a hi2lo nbit binary representation of the decimal value ndec.
"""
function dec2bits( ndec::Int, nbits::Int=2)
	ndec -= 1
	BitVector(digits(ndec, base=2, pad=max(nbits, ndigits(ndec, base=2))) |> reverse)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate how to use a variety of State constructors and the display() method.
"""
function demo()
	stt1 = bitstate(Bool[1,1,0])
	stt2 = ON ⊗ ON ⊗ OFF

	println("Are these two states approximately equal?")
	println( "stt1 ≡ bitstate(1,0,1) = ", stt1)
	println( "stt2 ≡ ON ⊗  OFF ⊗  ON = ", stt2)
	println( isclose(stt1,stt2) ? "Yes:" : "No:")
	display(stt1)
end

end		# ... of module States