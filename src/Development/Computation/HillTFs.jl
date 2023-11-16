#========================================================================================#
"""
	HillTFs

A skeleton julia file, defining the Very Simple new type HillTF. Please use it as a general
template for your own programming work.

Author: Niall Palfreyman, 26/05/2023
"""
module HillTFs

using Observables, GLMakie

import Base.==
export expression, HillTF

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	HillTF

This data type encapsulates the chemically important characteristics of a range of concentrations
of a Hill transcription factor, a half-response constant K and a cooperation level n.
"""
struct HillTF
	range::Vector{Float64}
	K::Float64
	n::Float64

	function HillTF( range::AbstractVector, K=2.0, n=1.0)
		@assert (K > 0.0) "K must be greater than zero"
		new(collect(range),K,n)
	end
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	==( tf1::HillTF, tf2::HillTF) :: Bool

Equality between two HillTFs.
"""
function ==( tf1::HillTF, tf2::HillTF)
	tf1.K==tf2.K && tf1.n==tf2.n && tf1.range==tf2.range
end

"""
	hill( tf::Real, K, n)

Return the Hill chemical reaction rate corresponding to a transcription factor concentration tf,
a half-response constant K and a cooperation level n.
"""
function hill( tf::Real, K=2.0, n=1.0)
	abs_n = abs(n)
	if abs_n != 1
		K = K^abs_n
		tf = tf^abs_n
	end

	(n >= 0) ? (tf/(K+tf)) : (K/(K+tf))
end

#-----------------------------------------------------------------------------------------
"""
	expression( substrate::HillTF)

Return the protein expression rates corresponding to a range of concentrations of a transcription
factor HillTF, a half-response constant K and a cooperation level n.
"""
function expression( tf::HillTF)
	map(tf.range) do concentration
		hill(concentration,tf.K,tf.n)
	end
end

#-----------------------------------------------------------------------------------------
"""
	animate_hill()

Create a graphical animation of the Hill function as the value of the cooperation (n)
changes from 1 up to 10.
"""
function animate_hill()
	tf_range = 0:30
	K = 10

	anim_n = Observable(1.0)           		# The animated cooperation value is Observable.
	hill_curve = map(anim_n) do n			# Create an expression curve that listens
		expression(HillTF(tf_range,K,n))    # directly to the current value (n) of anim_n.
	end

	fig = lines(tf_range, hill_curve)       # Create a plot of the (current) hill_curve ...
	display(fig)                        	# ... and display the result

	for n in 1:0.1:10                   	# Finally, animate the figure: Step through the
		anim_n[] = n                   		# values of n, and watch the hill_curve change
		sleep(0.1)                      	# as the value of anim_n moves from 1 to 10.
	end
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate the use of the HillTF module.
"""
function demo()
	tf = HillTF(0:30,5)
	expression(tf)
end

end		# of Hill