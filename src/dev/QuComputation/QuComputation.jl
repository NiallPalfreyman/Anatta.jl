#========================================================================================
	QuComputation module

This is the central organising module of the QuComputation package for experimenting with
quantum computation. It makes available the basic mathematical structure underpinning quantum
computation: Tensors, States and Operators.

Author: Niall Palfreyman, 11/11/2026
========================================================================================#
module QuComputation

# Reexport Tensors:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Reexport States:
export State, qubit, adj, ampl, phase, prob, maxprob, nbits, off, on, normalise!,
		pure, mixed, uniform, bitstate, density, ON, OFF

# Reexport Operators:
export Operator, identityop, density, ishermitian, isunitary, nbits,
		paulix, pauliy, pauliz, PauliX, PauliY, PauliZ

# Imports:
include( "Operators.jl")
using .Operators

end		# ... of module QuComputation