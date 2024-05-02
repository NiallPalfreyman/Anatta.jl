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
		"Two superimposed signals",
		function ()
			t0 = 0				# Start time
			f1 = 5				# Signal frequency 1 (1 Hz)
			f2 = 9				# Signal frequency 2 (2 Hz)
			fs = 1000			# Sampling rate (frequency, Hz)
			tmax = 10			# End time
		
			t = t0:1/fs:tmax	# Sampling times
			signal = 3sin.(2π*f1*t) + 5cos.(2π*f2*t)
		
			F = fftshift(fft(signal)) ./ (16π*sqrt(fs*(tmax-t0)))
			freqs = fftshift(fftfreq(length(t), fs))
		
			fig = Figure(fontsize=30,linewidth=5)
			Axis(
				fig[1,1], xlabel="Time", ylabel="f", title="Signal f over time",
				xticks=t0:1:tmax
			)
			lines!( t, signal)
			Axis(
				fig[2,1], xlabel="Shifted cos frequency", ylabel="real(F)", title="Cosine spectrum",
				xticks=-20:5:20, limits = ((-20,20), nothing)
			)
			lines!( freqs, real.(F))
			Axis(
				fig[3,1], xlabel="Shifted sin frequency", ylabel="imag(F)", title="Sine spectrum",
				xticks=-20:5:20, limits = ((-20,20), nothing)
			)
			lines!( freqs, imag.(F))
			display(fig)
		end,
	),
	Example(
		"Artificial data",
		function ()
			t0 = 0				# Start time
			f = 60				# Signal frequency
			fs = 44100			# Sampling rate (frequency, Hz)
			tmax = 0.1			# End time
		
			t = t0:1/fs:tmax
			signal = sin.(2π*f*t)
		
			F = fftshift(fft(signal))
			freqs = fftshift(fftfreq(length(t), fs))
		
			fig = Figure(fontsize=30,linewidth=5)
			Axis(fig[1,1], xlabel="time", ylabel="f", title="Signal f over time")
			lines!( t, signal)
			Axis(fig[2,1], xlabel="shifted frequency", ylabel="abs(F)", title="Frequency spectrum")
			lines!( freqs, abs.(F))
			display(fig)
		end,
	),
	Example(
		"Real data",
		function ()
			N = 22
			xj = (0:N-1)*2*π/N
			f = 2*sin.(6*xj) + 0.1*rand(N)
			Y = rfft(f)
			f2 = irfft(Y,N)
		
			f ≈ f2
		end,
	),
]

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	hill( s::Real, K=1.0, n=1.0)

Return the Hill saturation function corresponding to a signal s, half-response K and cooperation n.
"""
function hill( s, K::Real=1.0, n::Real=1.0)
	if K == 0
		return 0.5
	end

	abs_K = abs(K)
	if n != 1
		n = float(n)
		abs_K = abs_K^n
		s = s.^n
	end

	abs_hill = abs_K ./ (abs_K .+ s)
	
	K < 0 ? abs_hill : 1 - abs_hill
end

#-----------------------------------------------------------------------------------------
"""
	demo( n=1)

Run the n-th Fourier example.
"""
function demo( n=1)
	eg = examples[n]
	println( "Running tutorial example $n: $(eg.title) ...\n")
	eg.tutorial()
	nothing
end

end