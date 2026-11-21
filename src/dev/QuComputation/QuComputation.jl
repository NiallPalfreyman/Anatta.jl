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
export State, @x_str, ket, bra, isket, isbra, qubit, ampl, phase, prob, maxprob, nbits,
		off, on, OFF, ON, normalise!, pure, mixed, uniform, bitstate, density

# Reexport Operators:
export Operator, identityop, density, ishermitian, isunitary, nbits, adj,
		paulix, pauliy, pauliz, PauliX, PauliY, PauliZ

# Imports:
include( "Operators.jl")
using .Operators

end		# ... of module QuComputation