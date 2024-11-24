#========================================================================================#
#		Semantics
#
# Module Semantics encapsulates the model-based meaning of sentences in PL.
#	
# Author: Niall Palfreyman, November 2024.
#========================================================================================#
include( "Propositions.jl")
module Semantics

using ..Propositions

export Model, evaluate

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	Model

A Model is a mapping from Strings to truth-values.
"""
Model = Dict{String,Bool}

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	is_model( model::Model) :: Bool

is_model() checks whether its argument is a valid model.
"""
function is_model( model::Model) :: Bool
	for var in keys(model)
		if !Propositions.is_variable(var)
			return false
		end
	end
	true
end

#-----------------------------------------------------------------------------------------
"""
	variables( model::Model) :: Set{String}

variables() finds all variables over which the model is defined.
"""
function variables( model::Model) :: Set{String}
	@assert is_model(model)
	Set(keys(model))
end

#-----------------------------------------------------------------------------------------
"""
	evaluate( wff::WFF, model::Model) :: Bool

evaluate() computes the truth-value of this wff in this model.

Example: evaluate( parse("~(p&q5)"), Model("p"=>true,"q5"=>false)) -> true
"""
function evaluate( wff::WFF, model::Model) :: Bool
	@assert is_model(model)
	@assert issubset( Propositions.variables(wff), variables(model))

	# Learning activity:
	false
end

#-----------------------------------------------------------------------------------------
"""
	truth_table( vars) :: Iterable

Compute an Iterable over all possible models containing the given variable names. The order of
this Iterable corresponds to the order of variables in the vars list, with false preceding true,
and the counting of truth-assignments is in binary counting order (i.e., rightmost value changes
most rapidly).

Example: truth_table( ["q","p"]) -> [
	Model("q"=>false, "p"=>false),
	Model("q"=>true,  "p"=>false),
	Model("q"=>false, "p"=>true ),
	Model("q"=>true,  "p"=>true )
]
"""
function truth_table( vars::Union{Set{String},Vector{String}})
	@assert all( Propositions.is_variable.(vars))

	# Learning activity:
	map( Model, [
		[("p",false),("q",false)],[("p",false),("q",true)],
		[("p",true),("q",false)],[("p",true),("q",true)]
	])
end

#-----------------------------------------------------------------------------------------
"""
	truth_values( wff, t_table) :: Vector{Bool}

Compute an iterable over all truth-values of the given wff in each model of the given truth-table.
"""
function truth_values( wff::WFF, t_table)
	# Learning activity:
	[true,true,false,true]
end

#-----------------------------------------------------------------------------------------
"""
	print_tt( wff) :: nothing

Print a pretty version of the complete truth-table for the given wff, for example
print_tt( parse(WFF,"p->q")) prints:

	| p | q | (p -> q) |
	|---|---|----------|
	| F | F | T        |
	| F | T | T        |
	| T | F | F        |
	| T | T | T        |
"""
function print_ttable( wff::WFF)
	vars = sort([Propositions.variables(wff)...])
	tt = truth_table(vars)
	t_consequents = truth_values( wff, tt)

	header_row = "| " * *(map( v->(string(v)*" | "),vars)...) * string(wff) * " |"
	println(header_row)

	bars = findall('|',header_row)							# Find column separator bars
	bars = [bars[1:length(vars)+1];bars[end]]				# Discard disjunctions
	separator_row = ""
	for i in eachindex(bars)
		separator_row *= "|"
		if i < length(bars)
			separator_row *= "-"^(bars[i+1]-bars[i]-1)
		end
	end
	println(separator_row)

	tt_row = replace(separator_row, r"-" => " ")			# Convert separator to tt-row
	tt_row = replace(tt_row, "|  " => "| ?")				# Mark truth-value locations with '?'
	map(tt,t_consequents) do model, t_consequent
		ivar = 1
		current_row = ""
		for c in tt_row
			if c=='?'
				current_tval = ivar<=length(vars) ? model[vars[ivar]] : t_consequent
				current_row *= current_tval ? 'T' : 'F'
				ivar += 1
			else
				current_row *= c
			end
		end
		println(current_row)								# Current tuth-table row
	end
	nothing
end

#-----------------------------------------------------------------------------------------
"""
	istautology( wff::WFF) :: Bool

Compute whether the given wff is true in every possible model
"""
function istautology( wff::WFF) :: Bool
	# Learning activity:
	false
end

#-----------------------------------------------------------------------------------------
"""
	iscontradiction( wff::WFF) :: Bool

Compute whether the given wff is false in every possible model
"""
function iscontradiction( wff::WFF) :: Bool
	# Learning activity:
	false
end

#-----------------------------------------------------------------------------------------
"""
	issatisfiable( wff::WFF) :: Bool

Compute whether the given wff is true in somee possible model
"""
function issatisfiable( wff::WFF) :: Bool
	# Learning activity:
	true
end

#-----------------------------------------------------------------------------------------
"""
	conjunctive_wff( model::Model) :: WFF

Compute a conjunctive proposition (i.e., a chain of conditions that are linked by the &-operator)
that uniquely specifies the given model. That is, the conjunctive wff is true for this model, and
false for EVERY other model over the same set of names.

For example, the model Model("p" => 1, "q" => 1, "r" => 0) is completely specified by the
conjunctive proposition: ((p & q) & ~r).
"""
function conjunctive_wff( model::Model) :: WFF
	@assert is_model(model)
	@assert length(model) > 0

	# Learning activity:
	WFF("&",WFF("p"),WFF("~",WFF("q")))
end

#-----------------------------------------------------------------------------------------
"""
	dnf( vars::Vector{String}, AbstractArray{Bool}) :: WFF

Compute a wff in disjunctive normal form (DNF) that uniquely describes a complete truth-table
consisting of the given variable names, and yields the given collection of resulting truth-values.
"""
function dnf( vars::Vector{String}, tvalues::AbstractArray{Bool}) :: WFF
	@assert length(vars) > 0
	@assert length(tvalues) == 2^length(vars)

	rows = zip( truth_table(vars), tvalues)
	((model,tvalue), i) = iterate(rows)
	wff = tvalue ? conjunctive_wff(model) : WFF("~",conjunctive_wff(model))

	next = iterate(rows,i)
	while !isnothing(next)
		((model,tvalue), i) = next
		wff = WFF("|", wff, (tvalue ? conjunctive_wff(model) : WFF("~",conjunctive_wff(model))))
		next = iterate( rows, i)
	end
	wff
end

#-----------------------------------------------------------------------------------------
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Propositions
"""
function demo()
	wff = parse( WFF, "(p->q)")
#	wff = parse( WFF, "(q->p)")
#	wff = parse( WFF, "((p->q) -> (~q->~p))")
#	wff = parse( WFF, "~(p&q7)")
#	wff = parse( WFF, "~~~p")
#	wff = parse( WFF, "(x&(~z|y))")
	print_ttable(wff)
	println( "$wff is $(~istautology(wff) ? "not " : "")a tautology, ",
		"is $(~iscontradiction(wff) ? "not " : "")a contradiction, ",
		"and is $(~issatisfiable(wff) ? "not " : "")satisfiable!"
	)
	println()

	model = Model("p"=>true,"q"=>false)
	println( "In the model $model, the wff $wff evaluates to: $(evaluate(wff,model)).")
	println( "This model is described by the conjunctive wff: ", conjunctive_wff(model))
	println()

	tvalues = [true,true,false,true]
	vars = ["p","q"]
	dn_form = dnf( vars, tvalues)
	println( "The semantics ", tvalues, " for variables ", vars)
	println( "    are described by the following DNF:")
	print_ttable(dn_form)
end

end