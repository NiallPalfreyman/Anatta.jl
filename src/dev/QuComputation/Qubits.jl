#========================================================================================
	Qubits

A Qubit is a quantum bit, which can be in a superposition of the classical states 0 and 1.
In this lab, we explore the basic properties and behaviours of qubits in quantum computation.

Author: Niall Palfreyman, 30/10/2026
========================================================================================#
module Qubits

# Externally callable symbols of the Qubits module:
export Qubit, phase, off, on, OFF, ON, measure

# Imports:
using LinearAlgebra

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Qubit

A Qubit is a quantum bit - that is, a quantum superposition of the classical bit values 0 and 1.
It consists of two complex probability amplitudes α and β, which satisfy the normalisation
condition |α|² + |β|² = 1.
"""
mutable struct Qubit
	amp::Vector{Complex}		# The amplitudes of the qubit: |α|² + |β|² = 1
	tMeasure::Float64			# Time of last measurement
end

const energy = 1.0				# Energy of the qubit (Joules)
const hbar = 0.1				# Reduced Planck's constant (Joule-seconds)
const pauliX = [0 1;1 0]		# 1st Pauli spin matrix
const pauliY = [0 -im;im 0]		# 2nd Pauli spin matrix

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	Qubit( alpha::Complex, beta::Complex)

Construct a single Qubit from the given amplitudes.
"""
function Qubit( alpha::Number, beta=nothing)
	if beta===nothing
		beta = sqrt(1.0 - alpha'*alpha)
	end

	# Convert to normalised complex Vector ket:
	amps = ComplexF64.([alpha, beta])
	Qubit(amps/norm(amps), time())
end

#-----------------------------------------------------------------------------------------
"""
	Qubit(; alpha=nothing, beta=nothing)

Construct a single Qubit from the named amplitude arguments.
"""
function Qubit(; alpha=nothing, beta=nothing)
	if alpha === beta === nothing
		# Neither amplitude is given:
		error("alpha, beta or both are required.")
	end

	if alpha === nothing
		# alpha not given:
		alpha = sqrt(1.0 - beta'*beta)
	end

	Qubit(alpha,beta)
end

#-----------------------------------------------------------------------------------------
" OFF: The pure OFF Qubit."
const OFF = Qubit(1.0,0.0)
" ON:  The pure ON Qubit."
const ON  = Qubit(0.0,1.0)

#-----------------------------------------------------------------------------------------
"""
	measure( qubit::Qubit)

Jitter the amplitudes in proportion to the time since the previous measurement, ensure they
still satisfy the normalization condition |α|² + |β|² = 1, then measure the qubit and collapse
it to a classical state.
"""
function measure( qubit::Qubit)
	newtime = time()
	dt = newtime - qubit.tMeasure
	a = rand()
	randRotation = a*pauliX + (1-a)*pauliY
	qubit.amp += dt*(energy/hbar)*randRotation * qubit.amp
	qubit.amp ./= norm(qubit.amp)		# Normalise the amplitudes
	qubit.tMeasure = newtime			# Update the time of measurement
	prior_qubit = deepcopy(qubit)		# Store the prior qubit for debugging
	if rand() < abs(qubit.amp[1])^2
		qubit.amp .= [1.0, 0.0]			# Collapse to |0⟩
		return (0.0, prior_qubit)
	end

	qubit.amp .= [0.0, 1.0]				# Collapse to |1⟩
	(1.0, prior_qubit)
end

#-----------------------------------------------------------------------------------------
"""
	phase( qubit::Qubit)

Return the phase of the amplitude of the qubit.
"""
function phase( qubit::Qubit)
	angle(qubit.amp[2] / qubit.amp[1])
end

#-----------------------------------------------------------------------------------------
"""
	string( qubit::Qubit)

Convert the Qubit to a String.
"""
function Base.string( qubit::Qubit)
	"State[$(round(qubit.amp[1],digits=4)),$(round(qubit.amp[2],digits=4))," *
		"measured:$(round(qubit.tMeasure,digits=4))]"
end

Base.String( qubit::Qubit) = string(qubit)

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, qubit::Qubit)

Display the given Qubit.
"""
function Base.show( io::IO, qubit::Qubit)
	print( io, string(qubit))
end

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, ::MIME"text/plain", qubit::Qubit)

Display the qubit in a human-readable format.
"""
function Base.show( io::IO, ::MIME"text/plain", qubit::Qubit)
	println(io, "Qubit: ", string(qubit))
end

#-----------------------------------------------------------------------------------------
function demo()
	qubit = Qubit(1,1)
	println( "Created a qubit with equal amplitudes:        ", qubit)
	for _ in 1:5
		println( "Measuring the qubit immediately after:  $(measure(qubit))")
	end
	sleep(3)
	println( "Measuring the qubit 3.0 s later:        $(measure(qubit))")
	println()
	println( "Created an ON qubit with amplitudes:          ", qubit)
	for _ in 1:3
		println( "Measuring the qubit immediately after:  $(measure(qubit))")
		sleep(3)
		println( "Measuring the qubit 3.0 s later:        $(measure(qubit))")
	end
end

end		# ... of module Qubits