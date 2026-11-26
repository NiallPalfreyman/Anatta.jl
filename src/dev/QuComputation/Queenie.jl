#=======================================================================================#
"""
	Queenie

This is the central organising module of Queenie the Quantum Computer. It makes available
the basic mathematical structures and operations that underpin quantum computation:
Tensors, States, Operators, Gates and Circuits.

Author: Niall Palfreyman, 11/11/2026
"""
module Queenie

# Reexport Tensors:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Reexport States:
export State, @x_str, ket, bra, isket, isbra, qubit, ampl, phase, prob, maxprob, nbits,
		off, on, OFF, ON, normalise!, pure, mixed, uniform, bitstate, density

# Reexport Operators:
export Operator, ∘, projector, ishermitian, isunitary, nbits, s_x, s_y, s_z,
		g_X, g_Y, g_Z, g_Id, g_Rx, g_Ry, g_Rz, g_Rk, g_S, g_T, g_U1, g_V, g_Yroot, g_H

# Imports:
include( "Operators.jl")
using .Operators

end		# ... of module Queenie