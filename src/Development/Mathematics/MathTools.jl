#========================================================================================#
"""
	MathTools

This module provides a collection of convenient utility methods for the Mathematics library.

Author:  Niall Palfreyman, April 2025.
"""
module MathTools

using Random, GLMakie

#-----------------------------------------------------------------------------------------
# Module data:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	array_diagram( charray::Matrix{Char})

Display an array of characters in a diagram without type annotations.
"""
function array_diagram( charray::Matrix{Char}, styles...)
	m,n = size(charray)
	separator = (:vbar in styles) ? '!' : (:hbar in styles ? '-' : ' ')

	if :jumble in styles
		(m,n) = 2 .* (m,n)
		picture = reshape(
			shuffle([charray[:] ; fill(' ',m*n-prod(size(charray)))]),
			m,n
		)
	else
		picture = charray
	end

	if :flip in styles
		(m,n) = (n,m)
	end

	for i in 1:m
		for j in 1:n-1
			print( (:flip in styles) ? picture[j,i] : picture[i,j], separator)
		end
		println( (:flip in styles) ? picture[n,i] : picture[i,n])
	end

	nothing
end

#-----------------------------------------------------------------------------------------
"""
	dots_diagram( factor1, factor2)

Display an array of dots arranged according to the specified factors.
"""
function dots_diagram( factor1=[1], factor2=[1])
	bdry1 = cumsum(factor1)
	nfact1 = bdry1[end]
	brak1 = string(reduce( (a,b)->string(a,'+',b), factor1))
	if length(factor1) > 1
		brak1 = "(" * brak1 * ")"
	end

	bdry2 = cumsum(factor2)
	nfact2 = bdry2[end]
	brak2 = string(reduce( (a,b)->string(a,'+',b), factor2))
	if length(factor2) > 1
		brak2 = "(" * brak2 * ")"
	end
	margin = 0.2

	fig = Figure()
	ax = Axis(fig[1,1],aspect=DataAspect())
	limits!( ax, 1-margin,nfact2+margin, 1-margin,nfact1+margin)

	for i in eachindex(bdry1), j in eachindex(bdry2)
		lt = (j==1) ? 1-margin : bdry2[j-1]+1-margin
		rt = bdry2[j] + margin
		bm = (i==1) ? 1-margin : bdry1[i-1]+1-margin
		tp = bdry1[i] + margin
		poly!( ax, [(lt,bm),(rt,bm),(rt,tp),(lt,tp)], color=:lime)
	end
	scatter!( ax,
		vec([(i,j) for i in 1:nfact2, j in 1:nfact1]),
		markersize=20, color=:green
	)

	ax.title = "Dots diagram for: " * brak1 * " * " * brak2 * " = " * string(nfact1*nfact2)
	ax.xlabel = brak2
	ax.xticks = 1:nfact2
	ax.ylabel = brak1
	ax.yticks = 1:nfact1
	display(fig)

	nothing
end

#-----------------------------------------------------------------------------------------
"""
	area_diagram( factor...; ids...)

Display an area diagram segmented according to the specified factors with optional ID Symbols.
"""
function area_diagram( factor...; ids=(Symbol[],Symbol[]))
	# Check argument correctness:
	@assert length(factor) == 2					"Number of factors must currently equal 2"
	@assert length(ids) == length(factor)		"Number of id lists must equal number of factors"
	for f in eachindex(factor)
		@assert( (isempty(ids[f]) || length(ids[f])==length(factor[f])),
			"Number of IDs must equal number of terms in corresponding factor"
		)
	end

	# Calculate cumulative boundaries for the vertical (1) and horizontal (2) axes:
	bdry = cumsum.(factor)
	lwb  = map( b->floor(minimum([0.0;b])), bdry)
	upb  = map( b->ceil( maximum([0.0;b])), bdry)

	# Construct bracketed factors 1 and 2:
	brak = fill("",length(factor))
	for f in eachindex(factor)
		if isempty(ids[f])
			brak[f] = string( factor[f][1])
			for term in 2:lastindex(factor[f])
				brak[f] = string( brak[f], (factor[f][term]<0 ? "" : "+"), factor[f][term])
			end
		else
			brak[f] = ids[f][1]==:? ? string(factor[f][1]) :
				string( (factor[f][1]<0 ? "-" : ""), ids[f][1])
			for term in 2:lastindex(factor[f])
				brak[f] = ids[f][term]==:? ?
					string( brak[f], (factor[f][term]<0 ? "" : "+"), factor[f][term]) :
					string( brak[f], (factor[f][term]<0 ? "-" : "+"), ids[f][term])
			end
		end
		if factor[f][1]<0 || length(factor[f]) > 1
			brak[f] = "(" * brak[f] * ")"
		end
	end

	# Construct list of terms in the expanded factors:
	if all(isempty.(ids))
		expanded = fill(0.0,length(factor[1]),length(factor[2]))
		for r in eachindex(factor[1]), c in eachindex(factor[2])
			expanded[r,c] = round(factor[1][r]*factor[2][c],digits=5)
		end
	else
		expanded = fill("",length(factor[1]),length(factor[2]))
		for r in eachindex(factor[1]), c in eachindex(factor[2])
#			println("$r,$c: ids[1][r].$(ids[2][c])")
			expanded[r,c] = string(
				isempty(ids[1]) || ids[1][r]==:? ?
					(factor[1][r]<0 ? string('(',factor[1][r],')') : string(factor[1][r])) :
					(factor[1][r]<0 ? string("(-",ids[1][r],')') : string(ids[1][r])),
				'.',
				isempty(ids[2]) || ids[2][c]==:? ?
					(factor[2][c]<0 ? string('(',factor[2][c],')') : string(factor[2][c])) :
					(factor[2][c]<0 ? string("(-",ids[2][c],')') : string(ids[2][c]))
			)
		end
	end
		
	# Construct the figure axes:
	fig = Figure()
	ax = Axis(fig[1,1],aspect=DataAspect())
	limits!( ax, lwb[2], upb[2], lwb[1], upb[1])
	ax.ylabel = "Factor 1: " * brak[1];	ax.xlabel = "Factor 2: " * brak[2]
	ax.yticks = lwb[1]:upb[1];			ax.xticks = lwb[2]:upb[2]
	ax.title = "Area diagram for: " * brak[1] * "." * brak[2] * " = " * (
		all(isempty.(ids)) ? string(sum(expanded)) :
			reduce((a,b)->string(a,"+",b),expanded,init="")
	)

	# Colour in the rectangular component products:
	for r in eachindex(factor[1]), c in eachindex(factor[2])
		bm = r==1 ? 0.0 : bdry[1][r-1]; tp = bdry[1][r]
		lt = c==1 ? 0.0 : bdry[2][c-1]; rt = bdry[2][c]
		poly!( ax, [(lt,bm),(rt,bm),(rt,tp),(lt,tp)], alpha=0.55,
			color=(factor[1][r]*factor[2][c]>0 ? :yellow : :red)
		)
	end

	# Stamp a label at the centre of each rectangular component product:
	for r in eachindex(factor[1]), c in eachindex(factor[2])
		bm = r==1 ? 0.0 : bdry[1][r-1]; tp = bdry[1][r]
		lt = c==1 ? 0.0 : bdry[2][c-1]; rt = bdry[2][c]
		text!( ax, (lt+rt)/2, (bm+tp)/2,
			fontsize=20, align=(:center,:center), text=string(expanded[r,c])
		)
	end

	# Delineate the term boundaries within each factor:
	map(bdry[1]) do b
		lines!( ax, [(lwb[2],b),(upb[2],b)], color=:darkgreen, linewidth=2)
	end
	map(bdry[2]) do b
		lines!( ax, [(b,lwb[1]),(b,upb[1])], color=:darkgreen, linewidth=2)
	end

	display(fig)

	nothing
end

#-----------------------------------------------------------------------------------------
"""
	zcol( z::Number)

Convert a complex number to a colour for use in graphics:
	+ve real axis: green
	+ve imag axis: yellow
	-ve real axis: red
	-ve imag axis: blue
"""
function zcol( z, R=pi)
	θ = angle(z)/π
	if 0 <= θ <= 0.5
		λ = 2θ
		colour = λ * [0.8,0.8,0.0] + (1-λ) * [0.0,0.5,0.0]
	elseif 0.5 <= θ <= 1.0
		λ = 2θ - 1
		colour = λ * [1.0,0.0,0.0] + (1-λ) * [0.8,0.8,0.0]
	elseif -0.5 <= θ <= 0.0
		λ = 2abs(θ)
		colour = λ * [0.0,0.0,1.0] + (1-λ) * [0.0,0.5,0.0]
	elseif -1 <= θ <= -0.5
		λ = 2abs(θ) - 1
		colour = λ * [1.0,0.0,0.0] + (1-λ) * [0.0,0.0,1.0]
	end

	L = 2atan(abs(z)/R)/π
	if L <= 0.5
		colour *= 2L
	else
		s = 2(1-L)
		colour = s * colour + (1-s) * [1.0,1.0,1.0]
	end

	GLMakie.RGB(colour...)
end

end