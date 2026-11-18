#========================================================================================
	Tensors

This module contains the basic mathematical structure underpinning quantum theory: Tensors.
This forms the definitional base for the QuComputation package for experimenting with quantum
computation.

Author: Niall Palfreyman, 30/10/2026
========================================================================================#
module Tensors

# Externally callable symbols of the Tensors module:
export Tensor, ⊗, ↑, kpow, isclose, ishermitian, isunitary, ispermutation

# Imports:
using LinearAlgebra: I, adjoint

#========================================================================================#
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Tensor

Tensor is our term for AbstractArray or a Number.
"""
Tensor = AbstractArray

#========================================================================================#
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	Tensor product ⊗

Define ∘ as an infix operator for the tensor (or Kronecker) product of two Tensors.
"""
⊗ = Base.kron

#-----------------------------------------------------------------------------------------
"""
	kpow( T::Tensor, n::Int)

Kronecker the Tensor T n times with itself.
"""
function kpow( T::Tensor, n::Int)
	if n==0
		# Base case:
		return 1.0
	end
	
	# Build Kronecker product:
	Tn = T
	for _ in 1:(n-1)
		Tn = Tn ⊗ T
	end
	Tn
end
# Define ↑ (\uparrow) as infix operator for kpow:
↑ = kpow

#-----------------------------------------------------------------------------------------
"""
	isclose( T::Union{Tensor,Number}, U::Union{Tensor,Number}, tolerance::Float64=1e-6)

Check whether all elements of the Tensor T are close to those of the Tensor U.
"""
function isclose( T::Union{Tensor,Number}, U::Union{Tensor,Number}, tolerance::Float64=1e-6)
	all(abs.(T.-U) .< tolerance)
end

#-----------------------------------------------------------------------------------------
"""
	ishermitian( T::Tensor)

Check whether the Tensor T is Hermitian (i.e., equal to its own adjoint).
"""
function ishermitian( T::Tensor)
    m, n = size(T)
    m == n || return false
	
	isclose(adjoint(T),T)
end

#-----------------------------------------------------------------------------------------
"""
	isunitary( T::Tensor)

Check whether the Tensor T is unitary (i.e., its inverse is equal to its adjoint).
"""
function isunitary( T::Tensor)
    m, n = size(T)
    m == n || return false

	isclose(adjoint(T)*T, I(size(T,1)))
end

#-----------------------------------------------------------------------------------------
"""
	ispermutation( T::Tensor)

Check whether the Tensor T is a permutation matrix.
"""
function ispermutation( T::Tensor)
    m, n = size(T)
    m == n || return false

    all(x -> x == 0 || x == 1, T) ||
        return false

    all(sum(T, dims=1) .== 1) &&
    all(sum(T, dims=2) .== 1)
end

#========================================================================================#
"""
	demo()

Demonstrate the Tensor type by test-driving all QuBase methods.
"""
function demo()
	A = [1 2;0 1]
	B = [1 3;0 1]
	println( "Here are two 2x2 matrices A and B:")
	display( A)
	display( B)
	println()

	println( "Here is their tensor product A⊗B:")
	display( A ⊗ B)
	println()

	println( "... and here is their tensor product B⊗A:")
	display( B ⊗ A)
	println()

	C = A .+ 1e-6rand(2,2)
	println( "Here is a 2x2 matrix C that is close to the matrix A:")
	display( C)
	println()

	println("Is C close to A? ", isclose(C,A) ? "Yes" : "No")
	println()

	println( "Here is the tensor square of B:")
	display( B ↑ 2)
	println()

	D = [1 im; -im 1]
	println( "Here is a 2x2 ", (ishermitian(D) ? "" : "non-"), "hermitian matrix:")
	display( D)
	println()

	E = [0 im; -im 0]
	println( "Here is a 2x2 ", (isunitary(E) ? "" : "non-"), "unitary matrix:")
	display( E)
	println()

	F = [0 1 0; 1 0 0; 0 0 1]
	println( "Here is a 3x3 ", (ispermutation(F) ? "" : "non-"), "permutation matrix:")
	display( F)
end

end		# ... of module Tensors