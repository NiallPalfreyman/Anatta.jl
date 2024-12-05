#========================================================================================#
#		Semantics
#
# Propositions
#
# Module Propositions encapsulates the syntactic structure of Propositional Logic.
#========================================================================================#
module Propositions

export WFF, wff, show, to_not_implies

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
		if isvariable(head) || isconstant(head)
    		new(head,nothing,nothing)
		elseif isunary(head)
			@assert !isnothing(arg1)&&isnothing(arg2) "Unary arguments invalid!"
			new(head,arg1,nothing)
		else
			@assert isbinary(head) "Invalid operator!"
			@assert !isnothing(arg1)&&!isnothing(arg2) "Binary arguments invalid!"
			new(head,arg1,arg2)
		end
	end
end

"Base.convert(WFF,x): Make WFF constructor available for type conversions"
Base.convert(::Type{WFF}, x) = WFF(x)

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
# Accessor methods:
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
	isvariable(var::String)

Check whether var is a valid variable name (e.g., p45, x5342)
"""
function isvariable(var::String)
	'a' <= var[1] <= 'z' && (length(var)==1 || tryparse(Int,var[2:end]) !== nothing)
end

#-----------------------------------------------------------------------------------------
"""
	isconstant(c::String)

Check whether c is a valid boolean constant ("T" or "F")
"""
function isconstant(c::String)
	c=="T" || c=="F"
end

#-----------------------------------------------------------------------------------------
"""
	isunary(op1::String)

Check whether op1 is a unary operator ("~")
"""
function isunary(op1::String)
	op1=="~"
end

#-----------------------------------------------------------------------------------------
"""
	isbinary(op2::String)

Check whether op2 is a binary operator ("&", "|", "->", "+", "<->", "-&" or "-|").
"""
function isbinary(op2::String)
	# Learning activity:
	op2=="&" || op2=="|" || op2=="->"
end

#-----------------------------------------------------------------------------------------
"""
	Base.show( io::IO, woof::WFF)

Show a String representation of the woof (Well-Formed Formula) to the iostream.
"""
function Base.show( io::IO, woof::WFF)
	if isvariable(woof.head) || isconstant(woof.head)
		print( io, woof.head)
	elseif isunary(woof.head)
		print( io, woof.head, woof.arg1)
	else
		print( io, "(", woof.arg1, " ", woof.head, " ", woof.arg2, ")")
	end
end

#-----------------------------------------------------------------------------------------
"""
	variables(woof::WFF)

Return the Set of all variable names in the woof.
"""
function variables(woof::WFF)
	# Learning activity:
	if isconstant(woof.head)
		Set{String}([])
	elseif isvariable(woof.head)
		Set(["p","q"])
	elseif isunary(woof.head)
		Set(["p"])
	else # isbinary:
		union(variables(woof.arg1),variables(woof.arg2))
	end
end

#-----------------------------------------------------------------------------------------
"""
	operators(woof::WFF)

Return the Set of all operator names in the woof.
"""
function operators(woof::WFF)
	# Learning activity:
	if isvariable(woof.head)
		Set{String}([])
	elseif isconstant(woof.head)
		Set(["~"])
	elseif isunary(woof.head)
		Set(["~"])
	else # isbinary:
		Set(["~"])
	end
end

#-----------------------------------------------------------------------------------------
# Parsing methods:
#-----------------------------------------------------------------------------------------
"""
	Base.parse( Type{T}, sentence::AbstractString) :: WFF where T<:WFF

Assume the argument sentence is a valid sentence of the language PL, and return the WFF
described by that sentence.
"""
function Base.parse( ::Type{T}, sentence::AbstractString) :: WFF where T<:WFF
	# Learning activity:
	WFF( "->", WFF("p"), WFF("q"))
end

"wff(sentence): Provide simple interface to Base.parse(WFF,sentence)"
wff( sentence::AbstractString) = Base.parse(WFF,sentence)

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
	if length(str)>0 && isconstant(str[1:1])
		return (WFF(str[1:1]), str[2:end])
	end

	(nothing,"Cannot parse constant: \"$str\"")
end

#-----------------------------------------------------------------------------------------
"""
	parse_unary( str::String) :: Tuple{Union{WFF,Nothing},String}

Parse a unary expression (~woof) at start of statement string, then return remainder string.
"""
function parse_unary( str::String) :: Tuple{Union{WFF,Nothing},String}
	str = parse_ws(str)

	if length(str)>0 && isunary(str[1:1]) && (tuple=parse_wff(str[2:end]))[1]!==nothing
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
	successful, the return Tuple looks like this: (woof::WFF,tail::String), where woof is the
	parsed WFF and tail is the remainder string to the right of the parsed woof.
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

	(WFF("&",WFF("p"),WFF("T")),"Ani :)")
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
# Structural transformation methods:
#-----------------------------------------------------------------------------------------
"""
	substitute_vars( woof::WFF, var_subst_map::Dict{String,WFF}) :: WFF

Replace each variable - say, "p" - in the given woof by the new expression var_subst_map["p"].
Variables that arise through performing this var_subst_map are NOT further substituted.

Example:
	substitute_vars(
		wff("(p->(p&q))"), Dict( "p"=>wff("(q|r)"), "q"=>wff("r"), "r"=>wff("(p&r)"))
	) == ((q|r)->((q|r)&r))
"""
function substitute_vars( woof::WFF, var_subst_map::Dict{String,WFF}) :: WFF
	@assert all(isvariable.(keys(var_subst_map)))

	# Learning activity:
	woof
end

#-----------------------------------------------------------------------------------------
"""
	substitute_ops( woof::WFF, op_subst_map::Dict{String,WFF}) :: WFF

Return a wff obtained from the given woof by replacing, for each constant or operator - say, "*" -
in the op_subst_map dictionary, each occurrence of this operator by the wff op_subst_map["*"] to
which it is mapped by the subst_map. In this wff, each occurrence of p is replaced by the first
operand of "*" in woof, and every occurrence of q is replaced by the second operand of "*" in woof.
Operators that arise through performing this operator substitution are NOT further substituted.

Example:
	substitute_ops(
		wff("((x|y)&~x)"), Dict( "&"=>wff("~(~p|~q)"), "|"=>wff("~(~p&~q)"))
	) == ~(~~(~x&~y)|~~x)
"""
function substitute_ops( woof::WFF, op_subst_map::Dict{String,WFF}) :: WFF
	for sub in op_subst_map
		@assert isconstant(first(sub)) || isunary(first(sub)) || isbinary(first(sub))
		@assert issubset(variables(last(sub)),Set(["p","q"]))
	end

	if isconstant(woof.head) || isvariable(woof.head)
		# No substitution needed:
		return woof
	elseif !haskey(op_subst_map,woof.head)
		# Substitution needed only in arguments:
		if isunary(woof.head)
			return WFF( woof.head, substitute_ops(woof.arg1,op_subst_map))
		else
			return WFF( woof.head,
				substitute_ops(woof.arg1,op_subst_map),
				substitute_ops(woof.arg2,op_subst_map)
			)
		end
	end

	# woof.head definitely requires substitution; set up var substitution map:
	var_subst_map = Dict("p"=>substitute_ops(woof.arg1,op_subst_map))
	if isbinary(woof.head)
		var_subst_map["q"] = substitute_ops(woof.arg2,op_subst_map)
	end

	# Perform this var substitution for each arg (p and q) in the op subst_map:
	sub = op_subst_map[woof.head]
	if isunary(sub.head)
		return WFF( sub.head, substitute_vars( sub.arg1, var_subst_map))
	end

	# Substitution uses a binary operator:
	WFF( sub.head,
		substitute_vars(sub.arg1,var_subst_map),
		substitute_vars(sub.arg2,var_subst_map)
	)
end

#-----------------------------------------------------------------------------------------
"""
	to_not_and_or( woof::WFF) :: WFF

Structurally transform woof into a wff that contains only the operators "~", "&" and "|".
"""
function to_not_and_or( woof::WFF) :: WFF
	# Learning activity:
	# {"->", "+", "<->", "-&", "-|"} => {"~", "&", "|"}
	woof
end

#-----------------------------------------------------------------------------------------
"""
	to_not_and( woof::WFF) :: WFF

Structurally transform woof into a wff that contains only the operators "~" and "&".
"""
function to_not_and( woof::WFF) :: WFF
	# Learning activity:
	# {"|", "->", "+", "<->", "-&", "-|"} => {"~", "&"}
	woof
end

#-----------------------------------------------------------------------------------------
"""
	to_not_implies( woof::WFF) :: WFF

Structurally transform woof into a wff that contains only the operators "~" and "->".
"""
function to_not_implies( woof::WFF) :: WFF
	# {"&", "|", "+", "<->", "-&", "-|"} => {"~", "->"}:
	substitute_ops( woof, Dict(
		"-&"	=> wff("(p->~q)"),
		"&"		=> wff("~(p->~q)"),
		"|"		=> wff("((p->q)->q)"),
		"-|"	=> wff("~((p->q)->q)"),
		"<->"	=> wff("((~(p->~q)->~(~p->q))->~(~p->q))"),
		"+"		=> wff("~((~(p->~q)->~(~p->q))->~(~p->q))")
	))
end

#-----------------------------------------------------------------------------------------
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Propositions
"""
function demo()
	# Make Absolutely Sure you understand the tree-structure of wffs like this `contrapositive`:
	contrapositive =
		WFF("->",						# Top-level binary operator
			WFF( "->",					# 2nd-level binary operator (arg1)
				WFF("p"),				# 3rd-level variable (arg1)
				WFF("q")				# 3rd-level variable (arg2)
			),
			WFF( "->",					# 2nd-level binary operator (arg2)
				WFF( "~",				# 3rd-level unary operator (arg1)
					WFF("q")			# 4th-level variable (arg1)
				),
				WFF( "~",				# 3rd-level unary operator (arg1)
					WFF("p")			# 4th-level variable (arg1)
				)
			)
		)
	println("Testing the WFF \"contrapositive\": $contrapositive ...")
	println("Variables contained in contrapositive are: ", variables(contrapositive))
	println("Operators contained in contrapositive are: ", operators(contrapositive))
	println("Here is my newly parsed version: ", wff( string(contrapositive)))
	println("Here is the [~,&] version: ", to_not_and(contrapositive))

	# Learning activity:
#	println("... and finally, the [~,->] version: ", to_not_implies(contrapositive))
end

end