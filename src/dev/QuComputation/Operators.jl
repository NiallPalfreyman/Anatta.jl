#========================================================================================
	Operators

This file contains definitions of the type Operator for the module QuBits: A package for
experimenting with quantum computation.

Author: Niall Palfreyman, 10/11/2026
========================================================================================#
module Operators

# Externally callable symbols of the Operators module:
export Operator, identityop, density, ishermitian, isunitary, nbits,
		paulix, pauliy, pauliz, PauliX, PauliY, PauliZ
# Reexport States:
export State, qubit, adj, ampl, phase, prob, maxprob, nbits, off, on, normalise!,
		pure, mixed, uniform, bitstate, density, ON, OFF
# Reexport Tensors:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Imports:
include( "States.jl")
using .States
import .States: nbits		# Explicit import to enable extension to Operators
using LinearAlgebra: I

#========================================================================================#
# Module definitions:
#-----------------------------------------------------------------------------------------
"""
	Operator

An Operator is a transformation of States.
"""
struct Operator <: Tensor{Complex,2}
	matrix::Matrix{Complex}									# The operator matrix

	function Operator(matrix::Matrix)
		if isclose(matrix,0.0)
			error("Operators must be non-zero")
		end
		new(matrix)
	end
end

#-----------------------------------------------------------------------------------------
# Delegated Operator methods:
Base.length(op::Operator) = length(op.matrix)
Base.size(op::Operator) = size(op.matrix)
Base.getindex(op::Operator,i::Integer,j::Integer) = getindex(op.matrix,i,j)

#========================================================================================#
# Module constructors:
#-----------------------------------------------------------------------------------------
"""
	identityop( n::Int=1)

Construct an n-qubit identity Operator.
"""
function identityop( n::Int=1)
	Operator([1 0;0 1] ↑ n)
end

#-----------------------------------------------------------------------------------------
"""
	paulix( d::Int=1)

Construct d-dimensional Pauli-x Operator.
"""
function paulix( d::Int=1)
	Operator([0 1;1 0] ↑ d)
end

#-----------------------------------------------------------------------------------------
"""
	pauliy( d::Int=1)

Construct d-dimensional Pauli-y Operator.
"""
function pauliy( d::Int=1)
	Operator([0 -im;im 0] ↑ d)
end

#-----------------------------------------------------------------------------------------
"""
	pauliz( d::Int=1)

Construct d-dimensional Pauli-z Operator.
"""
function pauliz( d::Int=1)
	Operator([1 0;0 -1] ↑ d)
end

#-----------------------------------------------------------------------------------------
"""
	density( s::State)

Construct the density operator of the state s.
"""
function density( s::State)
    Operator((s.ket) ? (s.amp * adj(s.amp)) : (adj(s.amp) * s.amp))
end

#========================================================================================#
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	Base.kron( op1::Operator, op2::Operator)

Kronecker product of two Operators is itself an Operator.
"""
Base.kron( op1::Operator, op2::Operator) = Operator( kron(op1.matrix,op2.matrix))

#-----------------------------------------------------------------------------------------
"""
	*( op1::Operator, op2::Operator)

Inner product of two Operators is itself an Operator.
"""
Base.:*( op1::Operator, op2::Operator) = Operator( op1.matrix * op2.matrix)

#-----------------------------------------------------------------------------------------
"""
	*( op::Operator, s::State)

Inner product of an Operator with a state is a transformed State.
"""
function Base.:*( op::Operator, s::State)
	if !s.ket
		error("Operators can only be multiplied onto ket-States")
	end
	State( op.matrix * s.amp)
end

#-----------------------------------------------------------------------------------------
"""
	call( op::Operator, s::State, idx::Int=1)

Apply the Operator op to the State s at the idx-th bit.
"""
function (op::Operator)( s::State, idx::Int=1)
	nbitsop = nbits(op)

	if idx > 1
		# Pad to the left:
		op = identity(idx-1) ⊗ op
	end

	remainingdims = nbits(s) - idx - nbitsop + 1
	if remainingdims > 0
		# Pad to the right:
		op = op ⊗ identity(remainingdims)
	end
	
	op * s
end

#-----------------------------------------------------------------------------------------
"""
	call( op1::Operator, op2::Operator)

Compose the Operator op1 followed by the Operator op2. Note the reversed order of multiplication!!
"""
function (op1::Operator)(op2::Operator, idx::Int=1)
	nbitsop2 = nbits(op2)				# Save before possible left-padding
	if idx > 1
		# Pad to the left:
		op2 = identity(idx-1) ⊗ op2
	end

	if nbits(op1) > nbits(op2)
		# Pad rightwards to match nbits of op2 to nbits of op1:
		op2 = op2 ⊗ identity(nbits(op1)-(idx-1)-nbitsop2)
	end
	
	op2 * op1
end

#-----------------------------------------------------------------------------------------
"""
	nbits( op::Operator)

Return number of qubits on which the Operator op operates.
"""
function nbits( op::Operator)
	Int(log2(size(op.matrix,1)))
end

#-----------------------------------------------------------------------------------------
"""
	ishermitian( op::Operator)

Check whether the Operator op is hermitian.
"""
function ishermitian( op::Operator)
	isclose(op,op')
end

#-----------------------------------------------------------------------------------------
"""
	isunitary( op::Operator)

Check whether the Operator op is unitary.
"""
function isunitary( op::Operator)
	m = op.matrix
	isclose(m*m',Matrix(I(size(m,1))))
end

#-----------------------------------------------------------------------------------------
"""
	string( op::Operator)

Convert the Operator op to a String.
"""
function Base.string( op::Operator)
	string( "Operator: ", op.matrix)
end

Base.String( op::Operator) = string(op)

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, op::Operator)

Display the given Operator op.
"""
function Base.show( io::IO, op::Operator)
	print( io, string(op))
end

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, ::MIME"text/plain", op::Operator)

Display the Operator op in verbose form.
"""
function Base.show( io::IO, ::MIME"text/plain", op::Operator)
	println( io, "Operator:")
	for i in 1:size(op.matrix,1)
		print( io, " ")
		for j in 1:size(op.matrix,2)
			print( io, rpad(round(op.matrix[i,j],digits=4),20))
		end
		println()
	end
end

#========================================================================================#
# Module constants:
#-----------------------------------------------------------------------------------------
"""
	PauliX = paulix(1)

The 1-d Pauli X-gate.
"""
const PauliX = paulix()

#-----------------------------------------------------------------------------------------
"""
	PauliY = pauliy(1)

The 1-d Pauli Y-gate.
"""
const PauliY = pauliy()

#-----------------------------------------------------------------------------------------
"""
	PauliZ = pauliz(1)

The 1-d Pauli Z-gate.
"""
const PauliZ = pauliz()

#========================================================================================#
"""
	demo()

Demonstrate how to create, compose and display Operators.
"""
function demo()
	op1 = paulix()
	op2 = pauliy()
	print("op1 = "); display( op1)
	print("op2 = "); display( op2)

	print( "op1(op2) = op2 * op1 = ")
	display( op1(op2))
end

end		# ... of module Operators