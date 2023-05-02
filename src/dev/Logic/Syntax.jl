#========================================================================================#
"""
	Syntax

Module Syntax encapsulates the syntactic structure of Propositional and First-Order Predicate
Calculus.
	
Author: Niall Palfreyman (May 2023).
"""
module Syntax

export WFF, is_variable, is_constant, is_unary, is_binary, show, variables, operators

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	WFF

A WFF is a Well-Formed propositional Formula, e.g., "~(a13 | (b5 -> T))"
"""
struct WFF
	head::String
	arg1::Union{WFF,Nothing}
	arg2::Union{WFF,Nothing}

	"The one and only WFF constructor"
	function WFF( head::String, arg1=nothing, arg2=nothing)
		if is_variable(head) || is_constant(head)
			arg1::Nothing; arg2::Nothing
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
		Set([wff.head])
	elseif is_unary(wff.head)
		variables(wff.arg1)
	else
		# is_binary:
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
		Set([wff.head])
	elseif is_unary(wff.head)
		union(Set([wff.head]), operators(wff.arg1))
	else
		# is_binary:
		union(Set([wff.head]),operators(wff.arg1),operators(wff.arg2))
	end
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Syntax
"""
function demo()
	wff = WFF("->",WFF("->",WFF("p"),WFF("q")),WFF("->",WFF("~",WFF("q")),WFF("~",WFF("p"))))
	println("Testing the WFF \"contrapositive\": ", wff, " ...")
	println("Variables contained in contrapositive are: ", variables(wff))
	println("Operators contained in contrapositive are: ", operators(wff))
end

end