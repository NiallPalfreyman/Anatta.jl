#========================================================================================#
"""
	Diffusion

This module provides functionality for diffusing the contents of a matrix with periodic boundary
conditions, using von Neumann 4-neighbourhoods. The idea of diffusion is this:

At each step, a fraction `diffrate` of the qantity of heat at each location in the heatarray is
redistributed equally between the 4 adjacent neighbours of that location (right,up,left,down),
with the result that the heat diffuses out from high-value areas of the heatarray into low-value
areas of the array.
		
Author: Niall Palfreyman, 1/2/2023.
"""
module Diffusion

using GLMakie

export diffuse4!

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	diffuse4( heatarray::Matrix{Float64}, diffrate::Float64)

Diffuse heatarray via 4-neighbourhoods with periodic boundary conditions and the given
diffusion rate.
"""
function diffuse4( heatarray::Matrix{Float64}, diffrate=1.0)
	heatarray + 0.25diffrate * (
		circshift(heatarray,( 1,0)) + circshift(heatarray,(0, 1)) +
		circshift(heatarray,(-1,0)) + circshift(heatarray,(0,-1))
		- 4heatarray
	)
end

#-----------------------------------------------------------------------------------------
"""
	diffuse4!( heatarray::Matrix{Float64}, diffrate::Float64)

Diffuse heatarray in place via 4-neighbourhoods with periodic boundary conditions and the given
diffusion rate.
"""
function diffuse4!( heatarray::Matrix{Float64}, diffrate=1.0)
	heatarray[:] = diffuse4(heatarray,diffrate)[:]
	heatarray
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Demonstrate diffusion of a numerical array.
"""
function demo()
	dims = (7,7)
	centre = 1 .+ dims.÷2
	heatarray = zeros(dims...)
	heatarray[centre...] = 100.0

	nplots = 3
	fig = Figure(resolution = (600nplots, 600))
	for plt in 1:nplots
		display(heatarray)
		ax, = heatmap(fig[1,plt], heatarray)
		diffuse4!(heatarray,0.5)
		ax.aspect = AxisAspect(1)
	end

	fig
end

end # ... of module Diffusion
