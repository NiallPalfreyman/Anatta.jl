#========================================================================================#
#	Roulette
#
# Module Roulette: A model of mutation and the quasi-species equation.
#
# Author: Niall Palfreyman, 17/12/2024
#========================================================================================#
module Roulette

using Statistics: mean, std

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	sample( frequencies::Vector{Float64}, n=length(freq), T=0.0)

Create a vector of n sampled types from a population containing types with the given current
frequencies. This sampling is achieved using roulette-wheel selection of the types based on
a roulette wheel whose pockets are biased according to the frequencies. T is a "Temperature"
parameter: when it is high (1.0), the sampling is more random; when it is low (0.0), the
sampling is increasingly defined by the current distribution of frequencies. Use sigma-scaling
to eliminate all types from sampling whose frequency is less than 1/(2T+0.1) standard deviations
below the frequency mean. 
"""
function sample( frequencies::Vector{Float64}, n=length(frequencies); T=0.0)
	# Preprocess frequencies:
	T = min(1.0,max(0.0,T))								# Enforce 0.0 <= T <= 1.0
	frequencies = T*mean(frequencies) .+ (1-T)*frequencies	# Smooth frequencies towards average
	frequencies = frequencies / sum(frequencies)		# Normaise the resulting frequencies
	avg = mean(frequencies)								# Average population frequency
	stdev = std(frequencies)							# Spread of frequencies from average

	# Create fitness values:
	if stdev == 0										# Singular case: All frequencies were
		fitnesses = ones(Float64,length(frequencies))	# equal to the average!
	else
		fitnesses = 1.0 .+ (frequencies.-avg)/((0.1+2T)*stdev)
		fitnesses[fitnesses .<= 0] .= 0.0				# Frequencies smaller than 1/2T std
	end													# deviations below average are unviable
	
	# Create fitness-biased roulette wheel:
	wheel = cumsum( fitnesses)/sum(fitnesses)			# Roulette-wheel of fitness-biased pockets
	throws = (rand() .+ (1:n)/n) .% 1.0					# nsamples uniformly distributed ball-throws

	# Create vector of sampled freqency types:
	samples = zeros(Integer,n)
	for (throw,sample) in enumerate(throws)				# Ball-throw delivers one random sample fitness
		for (pocket,fitness) in enumerate(wheel)		# Wheel pocket contains fitness of one type
			if sample <= fitness						# When the sample surpasses type's fitness ...
				samples[throw] = pocket					# ... use this pocket as the sampled type
				break									# ... then break out to the next throw
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
	println( "    $(sample(x,T=temperature))")
end

end		# ... of module Roulette