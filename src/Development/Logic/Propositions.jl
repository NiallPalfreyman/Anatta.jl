#========================================================================================#
#		Semantics
#
# Propositions
#
# Module Propositions encapsulates the syntactic structure of Propositional Logic.
#========================================================================================#
module Propositions

export WFF, iswff, show

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	WFF

A WFF is a Well-Formed propositional Formula, e.g., "~(a13 | (b5 -> T))". It possesses a head,
representing either a constant (T/F), a variable name ("a91") or an operator that combines the
next two argument fields.
"""
struct WFF
	head::String				# Operator
	arg1::Union{WFF,Nothing}	# Argument 1
	arg2::Union{WFF,Nothing}	# Argument 2

	function WFF( head::String, arg1=nothing, arg2=nothing)
		if is_variable(head) || is_constant(head)
    		new(head,nothing,nothing)
		elseif is_unary(head)
			@assert !isnothing(arg1)&&isnothing(arg2) "Unary arguments invalid!"
			new(head,arg1,nothing)
		else
			@assert is_binary(head) "Invalid operator!"
			@assert !isnothing(arg1)&&!isnothing(arg2) "Binary arguments invalid!"
			new(head,arg1,arg2)
		end
	end
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
# Expression methods:
#-----------------------------------------------------------------------------------------
"""
	iswff(str::String) :: Bool

iswff checks whether its String argument is a valid WFF (e.g., "~(a13 | (b5 -> T))"). If so, it
returns true; otherwise, it returns false.
"""
function iswff(str::String)
	# Learning activity:
	true
end

#-----------------------------------------------------------------------------------------
"""
	is_variable(var::String)

Check whether var is a valid variable name (e.g., p45, x5342)
"""
function is_variable(var::String)
	'a' <= var[1] <= 'z' && (length(var)==1 || tryparse(Int,var[2:end]) !== nothing)
end

#-----------------------------------------------------------------------------------------
"""
	is_constant(c::String)

Check whether c is a valid boolean constant ("T" or "F")
"""
function is_constant(c::String)
	c=="T" || c=="F"
end

#-----------------------------------------------------------------------------------------
"""
	is_unary(op1::String)

Check whether op1 is a unary operator ("~")
"""
function is_unary(op1::String)
	op1=="~"
end

#-----------------------------------------------------------------------------------------
"""
	is_binary(op2::String)

Check whether op2 is a binary operator ("&", "|" or "->")
"""
function is_binary(op2::String)
	op2=="&" || op2=="|" || op2=="->"
end

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, wff::WFF)

Show a String representation of the wff (Well-Formed Formula) to the iostream.
"""
function Base.show( io::IO, wff::WFF)
	if is_variable(wff.head) || is_constant(wff.head)
		print( io, wff.head)
	elseif is_unary(wff.head)
		print( io, wff.head, wff.arg1)
	else
		print( io, "(", wff.arg1, " ", wff.head, " ", wff.arg2, ")")
	end
end

#-----------------------------------------------------------------------------------------
"""
	variables(wff::WFF)

Return the Set of all variable names in the wff.
"""
function variables(wff::WFF)
	# Learning activity:
	if  is_constant(wff.head)
		Set{String}([])
	elseif is_variable(wff.head)
		Set(["a91"])
	elseif is_unary(wff.head)
		Set(["a91"])
	else # is_binary:
		union(variables(wff.arg1),variables(wff.arg2))
	end
end

#-----------------------------------------------------------------------------------------
"""
	operators(wff::WFF)

Return the Set of all operator names in the wff.
"""
function operators(wff::WFF)
	# Learning activity:
	if  is_variable(wff.head)
		Set{String}([])
	elseif is_constant(wff.head)
		Set(["~"])
	elseif is_unary(wff.head)
		Set(["~"])
	else # is_binary:
		Set(["~"])
	end
end

#-----------------------------------------------------------------------------------------
# Parsing methods:
#-----------------------------------------------------------------------------------------
"""
	Base.parse( Type{T}, sentence::AbstractString) :: WFF where T<:WFF

Assume the argument sentence is a valid sentence of the language PL, parse it as a WFF
described by that sentence.
"""
function Base.parse( ::Type{T}, sentence::AbstractString) :: WFF where T<:WFF
	# Learning activity:
	WFF("a91")
end

#-----------------------------------------------------------------------------------------
"""
	parse_wff( str::String) :: Tuple{Union{WFF,Nothing},String}

Parse the first complete WFF in the given statement string, then return a Tuple containing that WFF
and the remaining, unparsed src string. If we cannot parse a WFF from the string, return the error
tuple: (nothing,error message).
"""
function parse_wff( str::String) :: Tuple{Union{WFF,Nothing},String}
	if !isnothing((tuple=parse_var(str))[1]) || !isnothing((tuple=parse_const(str))[1])
		# str starts with a variable or constant:
		return tuple
	elseif !isnothing((tuple=parse_unary(str))[1])
		# str starts with a negated WFF:
		return tuple
	elseif !isnothing((tuple=parse_binary(str))[1])
		# str starts with a conjuction, disjunction or implication expression:
		return tuple
	end

	(nothing, tuple[2])
end

#-----------------------------------------------------------------------------------------
"""
	parse_var( str::String) :: Tuple{Union{WFF,Nothing},String}

Parse a variable at start of statement string, then return remainder string.
"""
function parse_var( str::String) :: Tuple{Union{WFF,Nothing},String}
	str = parse_ws(str); len = length(str)
	if len>0 && 'a'<=str[1]<='z'
		next_char = 2
		while next_char<=len && isdigit(str[next_char])
			next_char += 1
		end
		return (WFF(str[1:next_char-1]), str[next_char:end])
	end

	(nothing, "Cannot parse variable: \"$str\"")
end

#-----------------------------------------------------------------------------------------
"""
	parse_const( str::String) :: Tuple{Union{WFF,Nothing},String}

Parse a constant (T/F) at start of statement string, then return remainder string.
"""
function parse_const( str::String) :: Tuple{Union{WFF,Nothing},String}
	str = parse_ws(str)
	if length(str)>0 && is_constant(str[1:1])
		return (WFF(str[1:1]), str[2:end])
	end

	(nothing,"Cannot parse constant: \"$str\"")
end

#-----------------------------------------------------------------------------------------
"""
	parse_unary( str::String) :: Tuple{Union{WFF,Nothing},String}

Parse a unary expression (~wff) at start of statement string, then return remainder string.
"""
function parse_unary( str::String) :: Tuple{Union{WFF,Nothing},String}
	str = parse_ws(str)

	if length(str)>0 && is_unary(str[1:1]) && (tuple=parse_wff(str[2:end]))[1]!==nothing
		return (WFF("~",tuple[1]),tuple[2])
	end

	(nothing,"Cannot parse unary expression: \"$str\"")
end

#-----------------------------------------------------------------------------------------
"""
	parse_binary( str::String) :: Tuple{Union{WFF,Nothing},String}

parse_binary() fulfils the following specification:
-   It accepts a single string as argument, and returns a Tuple containing two items;
=   It attempts to parse the string as a binary expression (either (wff1 & wff2),
	(wff1 | wff2) or (wff1 -> wff2) ) at the string's Left end. If this parsing is
	successful, the return Tuple looks like this: (wff::WFF,tail::String), where wff is the
	parsed WFF and tail is the remainder string to the right of the parsed wff.
-   If parse_binary() cannot parse the string as a binary expression, it returns a Tuple
	(nothing,"error msg"), whose first element is `nothing`, and whose second element is an
	error string which helps users to understand what went wrong.
"""
function parse_binary( str::String) :: Tuple{Union{WFF,Nothing},String}
	# Learning activity:
	str = parse_ws(str)

	if isempty(str) || str[1] != '('
		return (nothing,"Cannot find opening \'(\' in binary expression: \"$str\"")
	end

	(WFF("&",WFF("a91"),WFF("T")),"Ani :)")
end

#-----------------------------------------------------------------------------------------
"""
	parse_ws( str::String) :: String

Parse all leading white space at start of statement string, then return remainder string.
"""
function parse_ws( str::String) :: String
	idx = 1; len = length(str)
	while idx <= len && str[idx] in [' ','\t']
		idx += 1
	end

	str[idx:end]
end

#-----------------------------------------------------------------------------------------
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Propositions
"""
function demo()
	contrapositive = WFF("->",
		WFF( "->", WFF("p"), WFF("q")),
		WFF( "->",
			WFF( "~", WFF("q")),
			WFF( "~", WFF("p"))
		)
	)
	println("Testing the WFF \"contrapositive\": ", contrapositive, " ...")
	println("Variables contained in contrapositive are: ", variables(contrapositive))
	println("Operators contained in contrapositive are: ", operators(contrapositive))
	println("And here is my newly parsed version: ", parse( WFF, string(contrapositive)))
end

end