#========================================================================================#
"""
	Diffusion

This module provides functionality for diffusing the contents of a matrix with periodic boundary
conditions, using von Neumann 4-neighbourhoods. The idea of diffusion is this:

At each step, a fraction `diffrate` of the qantity of heat at each location in the heatarray is
redistributed equally between the 4 adjacent neighbours of that location (right,up,left,down),
with the result that the heat diffuses out from high-value areas of the heatarray into low-value
areas of the array.
		
Author: Som Ebody, 20/21/2021.
"""
module Diffusion

using GLMakie

export diffuse4!

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
diffuse4!( heatarray::Matrix{Float64}, diffrate::Float64)

Diffuse heatarray via 4-neighbourhoods with periodic boundary conditions and the given
diffusion rate.
"""
function diffuse4!( heatarray::Matrix{Float64}, diffrate=1.0)
	nrows = size(heatarray)[1]
	ncols = size(heatarray)[2]
	map(CartesianIndices((1:size(heatarray)[1], 1:size(heatarray)[2]))) do x

	if (x[1] == 1 || x[1] == nrows || x[2] == 1 || x[2] == ncols)
		neighbours = wrapMat(nrows, ncols, neuman_neighbourhood(x[1], x[2]))
	else
		neighbours = neumann_cartini(ncols, x[1], x[2])
	end
	flow = heatarray[x[1], x[2]] * diffrate
	heatarray[x[1], x[2]] *= 1 - diffrate
	heatarray[neighbours] = heatarray[neighbours] .+ (flow / 4)
end

	heatarray
end

"""
	neuman_neighbourhood(rowindex, colindex)

Creates an neumann_neighborhood.
Gets the patch on the left on the right ont the
top and the bottom. 
returns indices in pairs
"""
function neuman_neighbourhood(rowindex, colindex)
	i = rowindex
	j = colindex
	return [[i + 1, j], [i - 1, j], [i, j - 1], [i, j + 1]]
end

"""
	cartesian_indices(size_col, rowindex, colindex)

converts inidices into cartesian_indices
"""
function cartesian_indices(size_col, rowindex, colindex)
	i = rowindex
	j = colindex
	return (j - 1) * size_col + i
end

"""
	neumann_cartini(size_col, rowindex, colindex)

return the von neumann neighborhood in 
cartesian indices
"""
function neumann_cartini(size_col, rowindex, colindex)
	i = rowindex
	j = colindex
	return [cartesian_indices(size_col, i + 1, j), cartesian_indices(size_col, i - 1, j),
	cartesian_indices(size_col, i, j - 1), cartesian_indices(size_col, i, j + 1)]
end

# TODO: finish description! (I have little clue what is expected as input nor what will be returned)
"""
	wrapMat(size_row, size_col,index)

extends the boundaries of a matrix to return valid indices
"""
function wrapMat(size_row, size_col, index::Union{Vector{Vector{Int64}},Vector{Int64}}, output_cartindi=true)
	indices = []

	if typeof(index) == Vector{Int64}
		index = [index]
	end

	for ids in 1:size(index)[1]
		if index[ids][1] == 0
		index[ids][1] = -1
		end
		if index[ids][1] == size_row
		index[ids][1] = size_row + 1
		end
		if index[ids][2] == 0
		index[ids][2] = -1
		end
		if index[ids][2] == size_col
		index[ids][2] = size_col + 1
		end

		index1 = rem(index[ids][1] + size_row, size_row)
		index2 = rem(index[ids][2] + size_col, size_col)

		if output_cartindi == true
			append!(indices, [cartesian_indices(size_col, index1, index2)])
		elseif output_cartindi == false
			append!(indices, [index1, index2])
		end
	end

	return indices
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
