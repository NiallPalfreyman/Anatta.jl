#========================================================================================#
"""
	Fourier

Module Fourier: This module illustrates the use of the FFTW library

Author: Niall Palfreyman, 02/05/2024
"""
module Fourier

using GLMakie, FFTW

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Fourier

???
"""
struct Example
	title::String						# Title of this Fourier example
	tutorial::Function					# Tutorial demonstration function
end

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------
"""
	example

An array of Fourier examples.
"""
const examples = [
	Example(
		"Shifting",					# Title of example
		function ()					# Demonstration tutorial ...
			for rng in [1:8,1:9,0:8]
				println( "fftshifting the range $rng generates the Vector: ", fftshift(rng)')
			end
		end,
	),
	Example(
		"fftfreq(N,r) yields below-Nyquist frequencies for N samples in the range [0,r)",
		function ()
			println( "fftfreq(8,8) yields frequencies: ", fftfreq(8,8)')
			println( "fftfreq(9,9) yields frequencies: ", fftfreq(9,9)')
			println( "fftfreq(8,1) yields frequencies: ", fftfreq(8,1)')
			println( "fftfreq(4,8) yields frequencies: ", fftfreq(4,8)')
		end,
	),
	Example(
		"Putting together shifts and frequencies",
		function ()
			N = 21
			xj = (0:N-1)*2π/N
			fj = 2exp.(17im*xj) + 3exp.(6im*xj) + rand(N)
			
			original_k = 1:N
			shifted_k = fftshift(fftfreq(N)*N)
			
			original_fft = fft(fj)
			shifted_fft = fftshift(fft(fj))
			
			fig = Figure(fontsize=30,linewidth=5)
			Axis(fig[1,1], xlabel="original frequency", title="Original FFT Coefficients")
			lines!( original_k, abs.(original_fft))
			scatter!( [1,7,18], abs.(original_fft[[1,7,18]]), markersize=20, color=:red)

			Axis(fig[2,1], xlabel="shifted frequency", title="Shifted FFT Coefficients")
			lines!( shifted_k, abs.(shifted_fft))
			scatter!( [-4,0,6], abs.(shifted_fft[[7,11,17]]), markersize=20, color=:red)
			display(fig)
		end,
	),
	Example(
		"Three superimposed signals",
		function (srate)
			t0 = 0				# Start time
			t1 = 5				# End time
			t = t0:1/srate:t1	# Sampling time domain
			N = length(t)		# Number of sample points

			c0 = 5				# Constant cosine signal (amplitude 5, frequency 0 Hz)
			s1,f1 = (3,1)		# Sine signal (amplitude 2, frequency 1 Hz)
			c2,f2 = (4,2)		# Cosine signal (amplitude 3, frequency 2 Hz)
		
			g0 = repeat([c0],N)
			g1 = s1*sin.(2π*f1*t)
			g2 = c2*cos.(2π*f2*t)
			g = g0 + g1 + g2
		
			G = fft(g)									# Calculate transform
			Gn = 2fft(g)./N								# Rescale coefficients
			Gn[1] /= 2									# Only one constant term to rescale
			Gns = fftshift(Gn)							# Shift coefficients
			freqs = fftshift(fftfreq(length(t), srate))	# Set up frequency domain
		
			fig = Figure(fontsize=30,linewidth=5)
			Axis( fig[1,1:2], title="Signal g over time",
				xlabel="Time (t/s)", ylabel="g(t)",  xticks=t0:1:t1
			)
			lines!( t, g, color=:blue)
			if srate > 1000
				lines!( t, g0, color=:red, linestyle=:dashdot)
				lines!( t, g1, color=:red, linestyle=:dot)
				lines!( t, g2, color=:red, linestyle=:dash)
			end

			Axis( fig[2,1], title="Bare Fourier transform",
				xlabel="Sample", ylabel="abs(fft(g))"
			)
			lines!( t, abs.(G))

			Axis( fig[2,2], title="Rescaled Fourier transform",
				xlabel="Unshifted frequency", ylabel="2abs(fft(g))/N"
			)
			lines!( freqs, abs.(Gn))

			Axis( fig[3,1], title="Cosine spectrum",
				xlabel="Shifted frequency", ylabel="real(G)",
				xticks=-10:10, limits = ((-10,10), nothing)
			)
			lines!( freqs, real.(Gns))

			Axis( fig[3,2], title="Sine spectrum",
				xlabel="Shifted frequency", ylabel="imag(G)",
				xticks=-10:10, limits = ((-10,10), nothing)
			)
			lines!( freqs, imag.(Gns))
			display(fig)
		end,
	),
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	demo( srate=1)

Run the 4-th Fourier example. Sample rate starts at 1, but can be taken up to 1000. Above
1000, the signal components are also displayed over the time domain.
"""
function demo( srate=1, n=4)
	eg = examples[n]
	println( "Running tutorial example $n: $(eg.title) ...\n")
	eg.tutorial(srate)
	nothing
end

end