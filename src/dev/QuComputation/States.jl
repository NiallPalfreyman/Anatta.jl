#========================================================================================
	States

This module contains the definition of the type State for quantum computation.

Author: Niall Palfreyman, 30/10/2026
========================================================================================#
module States

# Externally callable symbols of the States module:
export State, qubit, adj, ampl, phase, prob, maxprob, nbits, off, on, normalise!,
		pure, mixed, uniform, bitstate, density, ON, OFF
# Reexport Tensors:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Imports:
include( "Tensors.jl")
using .Tensors
using LinearAlgebra: Adjoint, norm

#========================================================================================#
# Module types:
#-----------------------------------------------------------------------------------------
"""
	State

A State is a collection of one or more qubits entangled together in a Kronecker product.
"""
struct State <: Tensor{Complex,1}
	amp::Vector												# The State's amplitudes
	ket::Bool												# Ket or bra?
end

Vectuple = Union{AbstractVector,Tuple}				# Useful for indexing States

#========================================================================================#
# State constructors:
#-----------------------------------------------------------------------------------------
"""
	State( amp::Union{Vector,Adjoint,Matrix}, ket::Bool=true)

Construct a State from the given amplitudes - by default in ket mode. The amplitudes are
normalised to unit length.
"""
function State( amp::Union{Vectuple,Adjoint,Matrix})
	amp = collect(amp)
	len = length(amp)
	siz = size(amp)
	if !(len in siz)
		# Amplitude structure is multi-dimensional:
		error( "States may contain only one dimension of amplitudes")
	end

	log2len = log2(len)
	if !(isclose(log2len,round(log2len)))
		# length(amp) is not a power of 2:
		error( "Number of State amplitudes must be a power of 2")
	end

	nrm = norm(amp)
	if isclose(nrm,0.0)
		# Amplitudes are way too small:
		error( "States must be non-zero")
	end

	# Convert to normalised complex Vector in appropriate ket or bra mode
	State( ComplexF64.(vec(collect(amp)))/nrm, !(siz[1]==1))
end

"Construct a State from the given amplitudes in ket mode."
ket( amp::Union{Vectuple,Adjoint,Matrix}) = State(amp,true)

"Construct a State from the given amplitudes in bra mode."
bra( amp::Union{Vectuple,Adjoint,Matrix}) = State(amp,false)

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
	pure( n::Int=1, i::Int=1)

Construct an n-qubit State pure in the i-th amplitude. That is, the State is |0...010...0>,
where the 1 is in the i-th position.
"""
function pure( n::Int=1, i::Int=1)
	if n < 1 || i < 1 || i > (1<<n)
		error( "Invalid number of qubits or amplitude index")
	end

	amp = zeros(Float64,1<<n)
	amp[i] = 1.0
	State(amp)
end

"Construct an n-qubit State pure in a randomly selected amplitude."
pure( n::Int=1) = pure(n, rand(1:1<<n))

#-----------------------------------------------------------------------------------------
"""
	mixed( n::Int=1, amps::Vectuple{Complex})

Construct an n-qubit State mixed in the specified amplitudes.
"""
function mixed( amps::Vectuple)
	n = log2(length(amps))
	if !(isclose(n,round(n)))
		# length(amps) is not a power of 2:
		error( "Number of State amplitudes must be a power of 2")
	end

	State(ComplexF64.(collect(amps)))
end

#-----------------------------------------------------------------------------------------
"""
	uniform( distribution::BitVector)

Construct an n-qubit State with uniformly distributed amplitudes in the given distribution.
"""
function uniform( distribution::BitVector)
	n = log2(length(distribution))
	if !(isclose(n,round(n)))
		# length(distribution) is not a power of 2:
		error( "Number of State amplitudes in distribution must be a power of 2")
	end

	amps = zeros(ComplexF64,length(distribution))
	amps[distribution] .= exp.(im*2π*rand(sum(distribution)))	# Randomise phases of non-zero amplitudes
	State(amps)
end

"Construct an n-qubit State with all amplitudes uniformly distributed."
uniform( n::Int=1) = uniform(BitVector(trues(1<<n)))		# Randomly select a uniform state

#-----------------------------------------------------------------------------------------
"""
	off( d::Int=1)

Construct the pure d-dimensional OFF state |000...0>
"""
function off( d::Int=1)
	pure( d, 1)
end

#-----------------------------------------------------------------------------------------
"""
	on( d::Int=1)

Construct the pure d-dimensional ON state |111...1>
"""
function on( d::Int=1)
	pure( d, 1<<d)
end

#-----------------------------------------------------------------------------------------
"""
	bitstate( bits)

Construct a state that is true at the given bits.
"""
function bitstate( bits::Vectuple)
	bv = BitVector(bits)
	pure( length(bv), bits2dec(bv))
end

"Construct a state that is true at the given decimal value."
bitstate( bits::Int) = bitstate(dec2bits(bits))

"Construct a state that is true at the given bit arguments."
bitstate( bits...) = bitstate(bits)

#========================================================================================#
# Module methods:
#-----------------------------------------------------------------------------------------
# Delegated State methods:
Base.length(s::State) = length(s.amp)
Base.size(s::State) = size(s.amp)
Base.getindex(s::State,i::Integer) = getindex(s.amp,i)

#-----------------------------------------------------------------------------------------
"""
	getindex( s::State, bits::Vectuple)

Return the amplitude for qubit indexed by bits. Note: since binary values start from 0, we must
add 1 to the decimal conversion of bits.
"""
function Base.getindex( s::State, bits::Vectuple)
	s[bits2dec(bits)]
end

"""
	getindex( s::State, bits...)

Return the amplitude specified by the given bit values.
"""
Base.getindex( s::State, bits...) = s[bits]

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
	if s1.ket == s2.ket
		error( "Cannot multiply ket with ket or bra with bra")
	end

	s1.ket ? (s1.amp * permutedims(s2.amp)) : (permutedims(s1.amp) * s2.amp)[1]
end

#-----------------------------------------------------------------------------------------
"""
	adj( s::State)

Return the adjoint of the state s.
"""
function adj( s::State)
	State(conj(s.amp),!s.ket)
end

#-----------------------------------------------------------------------------------------
"""
	phase( s::State, bits::Vectuple)

Return the phase of the amplitude of the qubit indexed by bits.
"""
function phase( s::State, bits::Vectuple)
	angle(s[bits])
end

phase( s::State, i::Int) = angle(s[i])
phase( s::State, bits...) = phase(s,bits)

#-----------------------------------------------------------------------------------------
"""
	prob( s::State, bits::Vectuple)

Return probability for qubit indexed by bits.
"""
function prob( s::State, bits::Vectuple)
	abs2(s[bits])						# Calculate squared norm of bits-th amplitude
end

prob( s::State, bits...) = prob(s,bits)

function prob( s::State, i::Int)
	abs2(s[i])							# Calculate squared norm of i=th amplitude
end

#-----------------------------------------------------------------------------------------
"""
	normalise!( s::State)

Normalise the state s (but throw an error if it's a zero state).
"""
function normalise!(s::State)
	n = norm(s)
	if isclose(n,0.0)
		error("Attempted to normalise zero-State.")
	end
	s /= n
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
	str = (s.ket ? "ket" : "bra") * "-State{" * string(nbits(s)) * "}["
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

	println( io, nb, "-qubit, ", len, "-amplitude ", (s.ket ? "ket" : "bra"), "-State:")
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
	bits2str( bits::Vectuple)

Format bit vector as string
"""
function bits2str( bits::Vectuple, npad::Int=2)
	"|" * string([+s for s in bits]...) * "> == |" * lpad(string(bits2dec(bits)), npad) * ">"
end

bits2str(bits...) = bits2str(bits)

#-----------------------------------------------------------------------------------------
"""
	bits2dec( bits::AbstractVector)

Compute decimal representation of an AbstractVector interpreted as a binary number.
"""
function bits2dec( bits::AbstractVector)
	bits = bitvec(bits)
	1+sum( v * (1 << (length(bits)-i)) for (i,v) in enumerate(bits))
end

bitvec(v::AbstractVector{Bool})			= BitVector(v)
bitvec(v::AbstractVector{<:Integer})	= BitVector(v .!= 0)

#-----------------------------------------------------------------------------------------
"""
	dec2bits( dec::Int, nbits::Int)

Compute a hi2lo nbit binary representation of a decimal value.
"""
function dec2bits( ndec::Int, nbits::Int=2)
#	BitVector(reverse( digits(dec-1, base=2, pad=nbits)))
	ndec -= 1
	BitVector(digits(ndec, base=2, pad=max(nbits, ndigits(ndec, base=2))) |> reverse)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate how to use a variety of State constructors and the display() method.
"""
function demo()
	stt1 = bitstate(1,0,1)
	stt2 = ON ⊗  OFF ⊗  ON

	println("Are these two states approximately equal?")
	println( "stt1 ≡ bitstate(1,0,1) = ", stt1)
	println( "stt2 ≡ ON ⊗  OFF ⊗  ON = ", stt2)
	println( isclose(stt1,stt2) ? "Yes:" : "No:")
	display(stt1)
end

end		# ... of module States