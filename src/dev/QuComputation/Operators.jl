#=======================================================================================#
"""
	Operators

This module defines methods of the type Operator for the module Queenie: A package for
experimenting with quantum computation.

Author: Niall Palfreyman, 10/11/2026
"""
module Operators

# Externally callable symbols of the Operators module:
export Operator, ∘, projector, ishermitian, isunitary, nbits, ctrl, s_x, s_y, s_z,
		g_X, g_Y, g_Z, g_Id, g_Rx, g_Ry, g_Rz, g_Rk, g_S, g_T, g_U1, g_V, g_Yroot, g_H,
		c_Not, c_Not0
# Reexport States:
export State, @x_str, ket, bra, isket, isbra, qubit, ampl, phase, prob, maxprob, nbits,
		off, on, OFF, ON, normalise!, pure, mixed, uniform, bitstate, density
# Reexport Tensors:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Imports:
include( "States.jl")
using .States
import .States: nbits				# Explicit import to enable method extension to Operators

#========================================================================================#
# Type definition:
#-----------------------------------------------------------------------------------------
"""
	Operator

An Operator is a transformation of States.
"""
struct Operator <: Tensor{Complex,2}
	matrix::Matrix{Complex}									# The operator matrix

	function Operator( matrix::Matrix, d::Int=1)
		if isclose(matrix,0.0)
			error("Operators must be non-zero")
		end
		new(matrix ↑ d)
	end
end

#-----------------------------------------------------------------------------------------
# Delegated Operator methods:
Base.length(op::Operator) = length(op.matrix)
Base.size(op::Operator) = size(op.matrix)
Base.getindex(op::Operator,i::Integer,j::Integer) = getindex(op.matrix,i,j)

#========================================================================================#
# Single-qubit gate definitions:
#-----------------------------------------------------------------------------------------
"""
	g_Id( d::Int=1)

Construct an d-qubit identity gate.
"""
function g_Id( d::Int=1)
	Operator([1 0;0 1], d)
end

#-----------------------------------------------------------------------------------------
"""
	g_X( d::Int=1)

The d-qubit Pauli X-gate, corresponding to a classical NOT gate.
"""
function g_X( d::Int=1)
	Operator([0 1;1 0], d)
end

"Single-qubit Pauli spin-operator σ_x"
const s_x = g_X()

#-----------------------------------------------------------------------------------------
"""
	g_Y( d::Int=1)

The d-qubit Pauli Y-gate.
"""
function g_Y( d::Int=1)
	Operator([0 -im;im 0], d)
end

"Single-qubit Pauli spin-operator σ_y"
const s_y = g_Y()

#-----------------------------------------------------------------------------------------
"""
	g_Z( d::Int=1)

The d-qubit Pauli Z-gate.
"""
function g_Z( d::Int=1)
	Operator([1 0;0 -1], d)
end

"Single-qubit Pauli spin-operator σ_z"
const s_z = g_Z()

#-----------------------------------------------------------------------------------------
"""
	g_Rx( θ::Real)

Single-qubit rotation through an angle θ about the x-axis.
"""
function g_Rx( θ::Real)
	rotation( [1,0,0], θ)
end

#-----------------------------------------------------------------------------------------
"""
	g_Ry( θ::Real)

Single-qubit rotation through an angle θ about the y-axis.
"""
function g_Ry( θ::Real)
	rotation( [0,1,0], θ)
end

#-----------------------------------------------------------------------------------------
"""
	g_Rz( θ::Real)

Single-qubit rotation through an angle θ about the z-axis.
"""
function g_Rz( θ::Real)
	rotation( [0,0,1], θ)
end

#-----------------------------------------------------------------------------------------
"""
	g_Rk( k::Int, d::Int=1)

Discrete S-gate: generalisation of the phase-gate. Performs a phase rotation about the z-axis
through a phase 2π/2^k (i.e., 1/2^k of a complete revolution). Used in quantum Fourier Transform.
"""
function g_Rk( k::Int, d::Int=1)
	Operator( [1 0; 0 exp(2π*im/2^k)], d)
end

#-----------------------------------------------------------------------------------------
"""
	g_S( d::Int=1)

S-, or Phase, gate: A d-qubit pi/2 phase rotation of the |1> amplitude about the z-axis.
"""
function g_S( d::Int=1)
	Operator( [1 0;0 im], d)
end

#-----------------------------------------------------------------------------------------
"""
	g_T( d::Int=1)

T-gate: Square-root of the S-gate (Phase gate).
"""
function g_T( d::Int=1)
	Operator( [1 0;0 exp(im*pi/4)], d)
end

#-----------------------------------------------------------------------------------------
"""
	g_U1( λ::Real, d::Int=1)

U1 phase shift, or phase kick, gate: d-bit generalisation of the phase-gate. Similar to g_Rk, but
for an arbitrary phase λ. For integer powers of 2, the relationship is:
	g_Rk(k) == g_U1(2π/2^k)
"""
function g_U1( λ::Real, d::Int=1)
	Operator( [1 0; 0 exp(λ*im)], d)
end

#-----------------------------------------------------------------------------------------
"""
	g_V( d::Int=1)

Square-root of the d-qubit Pauli X-gate: sqrt(NOT).
"""
function g_V( d::Int=1)
	Operator( 0.5*[1+im 1-im;1-im 1+im], d)
end

#-----------------------------------------------------------------------------------------
"""
	g_Yroot( d::Int=1)

Square-root of the d-qubit Pauli Y-gate.
"""
function g_Yroot( d::Int=1)
	Operator( [1+im -1-im;1+im 1+im], d)
end

#-----------------------------------------------------------------------------------------
"""
	projector( s::State)

Projection (density) operator of the state s.
"""
function projector( s::State)
    Operator( density(s))
end

#-----------------------------------------------------------------------------------------
"""
	g_H( d::Int=1)

Hadamard gate: Creates a superposition of the basis states |0> and |1>.
"""
function g_H( d::Int=1)
	Operator( [1 1;1 -1]/sqrt(2), d)
end

#========================================================================================#
# Controlled-gate definitions:
#-----------------------------------------------------------------------------------------
"""
	ctrl( qbxClient, qbxServer, g_Op::Operator)

Construct a controlled-gate c_Op in which a Client qubit-index qbxClient controls the gate
g_Op at the Server qubit-index qbxServer. Note that this construction is location-independent:
	ctrl( 1, 3, op) == ctrl( 2, 4, op)
"""
function ctrl( qbxClient::Int, qbxServer::Int, g_Op::Operator)
	@assert( qbxClient ≠ qbxServer, "Client and server qubits cannot be equal")

	prjClient	= projector( OFF)
	prjServer	= projector( ON)
	cs_gap		= g_Id( abs(qbxClient-qbxServer))	# Gap in qubits between Client and Server
	op_width	= g_Id( nbits(g_Op))				# Width in qubits of g_Op

	if qbxServer > qbxClient						# Build the matrix ...
		if qbxServer - qbxClient > 1
			c_matrix = prjClient ⊗ cs_gap ⊗ op_width + prjServer ⊗ cs_gap ⊗ g_Op
		else
			c_matrix = prjClient ⊗ op_width + prjServer ⊗ g_Op
		end
	else
		if qbxClient - qbxServer > 1
			c_matrix = op_width ⊗ cs_gap ⊗ prjClient + g_Op ⊗ cs_gap ⊗ prjServer
		else
			c_matrix = op_width ⊗ prjClient + g_Op ⊗ prjServer
		end
	end

	Operator(c_matrix)								# ... then build the Operator
end

#-----------------------------------------------------------------------------------------
"""
	c_Not( qbxClient::Int, qbxServer)

Controlled-NOT gate: If client-qubit Then Not server-qubit.
"""
function c_Not( qbxClient::Int=1, qbxServer::Int=2)
	ctrl( qbxClient, qbxServer, s_x)
end

#-----------------------------------------------------------------------------------------
"""
	c_Not0( qbxClient::Int, qbxServer)

0-Controlled-NOT gate: If Not client-qubit Then Not server-qubit.
"""
function c_Not0( qbxClient::Int=1, qbxServer::Int=2)
	if qbxServer > qbxServer
		x2 = s_X ⊗ g_Id(qbxServer-qbxClient)
	else
		x2 = g_Id(qbxClient-qbxServer) ⊗ s_x
	end

	x2 ⊗ c_Not( qbxClient, qbxServer) ⊗ x2
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
	if !isket(s)
		error("Operators can only be multiplied onto ket-States")
	end
	State( op.matrix * s.amp)
end

#-----------------------------------------------------------------------------------------
"""
	op::Operator( s::State, qbx::Int=1)

Apply the Operator op to the State s at the qbx-th bit. Note that op is applied to s, and so
cannot address more bits than are available in s: nbits(op) <= nbits(s)
"""
function (op::Operator)( s::State, qbx::Int=1)
	opbits = nbits(op)								# Number of Operator bits
	nleft  = qbx - 1								# Number of bits to pad left of op
	nright = nbits(s) - qbx - opbits + 1			# Number of bits to pad right of op
	@assert( nright ≥ 0, "Operator accesses more bits than its argument State")

	if qbx > 1
		# Pad to the left:
		op = g_Id(nleft) ⊗ op
	end

	if nright > 0
		# Pad to the right:
		op = op ⊗ g_Id(nright)
	end
	
	op * s
end

#-----------------------------------------------------------------------------------------
"""
	op1::Operator( op2::Operator, qbx::Int=1)

Compose the Operator op1 followed by the Operator op2 at the qbx-th bit. Again, op2 is applied
to op1, and so cannot address more bits than are available in op1: nbits(op2) <= nbits(op1).

Also, note the reversed order of application, in which we apply first op1, and then op2 to the
State s: op1(op2)(s) == op2(op1(s)) !
"""
function (op1::Operator)(op2::Operator, qbx::Int=1)
	op1bits = nbits(op1)						# Number of Operator bits in op1
	op2bits = nbits(op2)						# Number of Operator bits in op2
	nleft  = qbx - 1								# Number of bits to pad left of op1
	nright = op1bits - qbx - op2bits + 1			# Number of bits to pad right of op1
	@assert( nright ≥ 0, "2nd Operator accesses more bits than the 1st Operator")

	if qbx > 1
		# Pad to the left:
		op2 = g_Id(nleft) ⊗ op2
	end

	if nright > 0
		# Pad right:
		op2 = op2 ⊗ g_Id(nright)
	end
	
	op2 * op1
end

"Infix form of Operator composition: (op1 ∘ op2)(s) == op2(op1(s))"
Base.:∘( op1::Operator, op2::Operator) = op1(op2)

"Infix form of Operator composition at given qubit-index: (op1 ∘ (op2,qbx))(s) == op2(op1(s),qbx)"
Base.:∘( op1::Operator, op2::Tuple{Operator, Int64}) = op1(op2...)

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
	Base.adjoint( op::Operator)

Return adjoint of the Operator.
"""
function Base.adjoint( op::Operator)
	Operator(Matrix(adjoint(op.matrix)))
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
	rotation( axis::Vector, θ::Real)

Construct a single-qubit rotation through an angle θ about the given ocoordinate axis.
"""
function rotation( ax::Vector, θ::Real)
	@assert( length(ax)==3 && all(isa.(ax,Real)) && isclose(sum(abs2.(ax)),1),
		"Rotation axis must be a real, 3-dimensional unit vector"
	)
	Operator( cos(θ/2)*g_Id() - im*sin(θ/2) * ax' * [X,Y,Z])
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
	println( io, nbits(op), "-qubit Operator:")
	for i in 1:size(op.matrix,1)
		print( io, " ")
		for j in 1:size(op.matrix,2)
			print( io, rpad(round(op.matrix[i,j],digits=2),16))
		end
		println()
	end
end

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