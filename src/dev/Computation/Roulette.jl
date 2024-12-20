#========================================================================================#
#	Roulette
#
# Module Roulette: A model of mutation and the quasi-species equation.
#
# Author: Niall Palfreyman, 17/12/2024
#========================================================================================#
module Roulette

using Statistics: mean, std
export sample

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	sample( x::Vector{Float64}, n=length(x), T=0.0)

Create a vector of n sampled types from a population whose types have population frequencies
given by the vector x. Sampling is implemented using roulette-wheel selection based on a
roulette wheel whose pockets are biased according to the frequencies.

T is a "Temperature" parameter that determines the extent to which sampling depends upon the
frequency distribution. When T is high (T>=1.0), the sampling is (rigidly) uniformly distributed;
when T is low (T<=0.0), sampling becomes increasingly determined by the frequency distribution
vector x. This implementation also uses sigma-scaling to eliminate from sampling all types whose
frequency is smaller than 1/(2T+0.1) standard deviations below the frequency mean.
"""
function sample( x::Vector{Float64}, n=length(x); T=0.0)
	# Preprocess frequencies:
	T = min(1.0,max(0.0,T))								# Enforce 0.0 <= T <= 1.0
	x = T*mean(x) .+ (1-T)*x							# Smooth frequencies towards average
	x = x / sum(x)										# Normaise the resulting frequencies
	avg = mean(x)										# Average population frequency
	stdev = std(x)										# Spread of frequencies from average

	# Create fitness values:
	if stdev == 0										# Singular case: All frequencies were
		fitnesses = ones(Float64,length(x))				# equal to the average!
	else
		fitnesses = 1.0 .+ (x.-avg)/((0.1+2T)*stdev)	# Frequencies smaller than 1/(2T+0.1) std
		fitnesses[fitnesses .<= 0] .= 0.0				# deviations below average are unviable
	end
	
	# Create fitness-biased roulette wheel:
	wheel = cumsum( fitnesses)/sum(fitnesses)			# Roulette-wheel of fitness-biased pockets
	throws = (rand() .+ (1:n)/n) .% 1.0					# Stochastic Universal Sampling: n ball-throws
														# distributed uniformly over interval (0,1)
	# Create vector of n sampled population types:
	samples = zeros(Integer,n)
	for (throw,sample) in enumerate(throws)				# Ball-throw delivers one random sample fitness
		for (pocket,fitness) in enumerate(wheel)		# Wheel pocket contains fitness of one type
			if sample <= fitness						# When the sample surpasses type's fitness ...
				samples[throw] = pocket					# ... use this pocket as the sampled type
				break									# ... then skip on to the next throw.
			end
		end
	end

	(n==1) ? samples[1] : samples						# Strip brackets if we only want one sample
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Use-case demonstrations of the method roulette().
"""
function demo( temperature=0.0)
	x = 1:10.0
	x = collect(x/sum(x))

	println( "Sampling the frequencies")
	println( "    $(round.(x,digits=2))")
	println( "generates the following sampled types:")
	println( "    ", sample(x,T=temperature))
	println()
	println( "Sampling only 7 types generates:")
	println( "    ", sample(x,7,T=temperature))
end

end		# ... of module Roulette