#========================================================================================#
#		Semantics
#
# Module Semantics encapsulates the model-based meaning of sentences in PL.
#	
# Author: Niall Palfreyman, November 2024.
#========================================================================================#
include( "Proofs.jl")
using .Propositions, .Proofs

module Semantics

using ..Propositions, ..Proofs
export Model, evaluate, issound

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
	ismodel( model::Model) :: Bool

ismodel() checks whether its argument is a valid model.
"""
function ismodel( model::Model) :: Bool
	for var in keys(model)
		if !Propositions.isvariable(var)
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
	@assert ismodel(model)
	Set(keys(model))
end

#-----------------------------------------------------------------------------------------
"""
	evaluate( woof::WFF, model::Model) :: Bool

evaluate() computes the truth-value of this woof in this model.

Use-case: evaluate( parse("~(p&q5)"), Model("p"=>true,"q5"=>false)) -> true
"""
function evaluate( woof::WFF, model::Model) :: Bool
	@assert ismodel(model)
	@assert issubset( Propositions.variables(woof), variables(model))

	# Learning activity:
#	false
	if  Propositions.isconstant(woof.head)
		woof.head == "T"
	elseif Propositions.isvariable(woof.head)
		model[woof.head]
	elseif Propositions.isunary(woof.head)
		!evaluate(woof.arg1,model)
	elseif woof.head=="&"
		evaluate(woof.arg1,model) && evaluate(woof.arg2,model)
	elseif woof.head=="|"
		evaluate(woof.arg1,model) || evaluate(woof.arg2,model)
	elseif woof.head=="->"
		!evaluate(woof.arg1,model) || evaluate(woof.arg2,model)
	elseif woof.head=="+"
		evaluate(woof.arg1,model) != evaluate(woof.arg2,model)
	elseif woof.head=="<->"
		evaluate(woof.arg1,model) == evaluate(woof.arg2,model)
	elseif woof.head=="-&"
		!(evaluate(woof.arg1,model) && evaluate(woof.arg2,model))
	elseif woof.head=="-|"
		!(evaluate(woof.arg1,model) || evaluate(woof.arg2,model))
	else # Something's gone wrong:
		error( "Non-permissible operator $(woof.head)")
	end
end

#-----------------------------------------------------------------------------------------
"""
	truth_table( vars) :: Iterable

Compute an Iterable over all possible models containing the given variable names. The order of
this Iterable corresponds to the order of variables in the vars list, with false preceding true,
and the counting of truth-assignments is in binary counting order (i.e., rightmost value changes
most rapidly).

Use-case: truth_table( ["q","p"]) returns an Iterable through Models in the following order:
	Model("q"=>false, "p"=>false),
	Model("q"=>true,  "p"=>false),
	Model("q"=>false, "p"=>true ),
	Model("q"=>true,  "p"=>true )
"""
function truth_table( vars::Union{Set{String},Vector{String}})
	@assert all( Propositions.isvariable.(vars))

	# Learning activity:
#	map( Model, [
#		[("p",false),("q",false)],[("p",false),("q",true)],
#		[("p",true),("q",false)],[("p",true),("q",true)]
#	])
	(Model(vars.=>reverse(row)) for row in
		Base.product([[false,true] for _ in vars]...)
	)
end

#-----------------------------------------------------------------------------------------
"""
	truth_values( woof, t_table) :: Vector{Bool}

Compute an iterable over all truth-values of the given woof in each model of the given truth-table.
"""
function truth_values( woof::WFF, t_table)
	# Learning activity:
#	[true,true,false,true]
	(evaluate(woof,row) for row in t_table)
end

#-----------------------------------------------------------------------------------------
"""
	print_tt( woof) :: nothing

Print a pretty version of the complete truth-table for the given woof in terms of truth-values
0 (false) and 1 (true). For example, print_tt( parse(WFF,"p->q")) prints:

	| p | q | (p -> q) |
	|---|---|----------|
	| 0 | 0 | 1        |
	| 0 | 1 | 1        |
	| 1 | 0 | 0        |
	| 1 | 1 | 1        |
"""
function print_ttable( woof::WFF)
	vars = sort([Propositions.variables(woof)...])
	tt = truth_table(vars)
	t_consequents = truth_values( woof, tt)

	header_row = "| " * *(map( v->(string(v)*" | "),vars)...) * string(woof) * " |"
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
				current_row *= current_tval ? '1' : '0'
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
	istautology( woof::WFF) :: Bool

Compute whether the given woof is true in every possible model
"""
function istautology( woof::WFF) :: Bool
	# Learning activity:
#	false
	all( truth_values( woof, truth_table(Propositions.variables(woof))))
end

#-----------------------------------------------------------------------------------------
"""
	iscontradiction( woof::WFF) :: Bool

Compute whether the given woof is false in every possible model
"""
function iscontradiction( woof::WFF) :: Bool
	# Learning activity:
#	false
	!any( truth_values( woof, truth_table(Propositions.variables(woof))))
end

#-----------------------------------------------------------------------------------------
"""
	issatisfiable( woof::WFF) :: Bool

Compute whether the given woof is true in somee possible model
"""
function issatisfiable( woof::WFF) :: Bool
	# Learning activity:
#	true
	any( truth_values( woof, truth_table(Propositions.variables(woof))))
end

#-----------------------------------------------------------------------------------------
"""
	conjunctive_wff( model::Model) :: WFF

Compute a conjunctive proposition (i.e., a chain of conditions that are linked by the &-operator)
that uniquely specifies the given model. That is, the conjunctive woof is true for this model, and
false for EVERY other model over the same set of names.

For example, the model Model("p" => 1, "q" => 1, "r" => 0) is completely specified by the
conjunctive proposition: ((p & q) & ~r).
"""
function conjunctive_wff( model::Model) :: WFF
	@assert ismodel(model)
	@assert length(model) > 0

	# Learning activity:
#	WFF("&",WFF("p"),WFF("~",WFF("q")))
	vars = sort([keys(model)...])
	var1 = vars[begin]
	wff1 = (model[var1]) ? WFF(var1) : WFF("~",WFF(var1))
	conjoin(woof,var) = (model[var]) ? WFF("&",woof,WFF(var)) : WFF("&",woof,WFF("~",WFF(var)))
	foldl( conjoin, vars[2:end], init=wff1)
end

#-----------------------------------------------------------------------------------------
"""
	dnf( vars::Vector{String}, AbstractArray{Bool}) :: WFF

Compute a woof in disjunctive normal form (DNF) that uniquely describes a complete truth-table
consisting of the given variable names, and yields the given collection of resulting truth-values.
"""
function dnf( vars::Vector{String}, tvalues::AbstractArray{Bool}) :: WFF
	@assert length(vars) > 0
	@assert length(tvalues) == 2^length(vars)

	rows = zip( truth_table(vars), tvalues)
	((model,tvalue), i) = iterate(rows)
	woof = tvalue ? conjunctive_wff(model) : WFF("~",conjunctive_wff(model))

	next = iterate(rows,i)
	while !isnothing(next)
		((model,tvalue), i) = next
		woof = WFF("|", woof, (tvalue ? conjunctive_wff(model) : WFF("~",conjunctive_wff(model))))
		next = iterate( rows, i)
	end
	woof
end

#-----------------------------------------------------------------------------------------
# Inference methods:
#-----------------------------------------------------------------------------------------
"""
	evaluate( ir::InferenceRule, model::Model) :: Bool

Compute whether the given InferenceRule is valid within the given Model. That is, whether the
model satisfies the conclusion whenever that model satisfies ALL of the assumptions.

Use-cases:
	evaluate( InferenceRule([wff("p")],wff("q")), Model("p"=>true,"q"=>false)) -> false
	evaluate( InferenceRule([wff("p")],wff("q")), Model("p"=>false,"q"=>true)) -> true
"""
function evaluate( ir::InferenceRule, model::Model) :: Bool
	@assert ismodel(model)

	# Learning activity:
#	false
	for assumption in ir.assumptions
		if !evaluate(assumption,model)
			return true
		end
	end

	evaluate(ir.conclusion,model)
end

#-----------------------------------------------------------------------------------------
"""
	issound( ir::InferenceRule) :: Bool

Compute whether the given InferenceRule is sound. That is, whether its conclusion is true
within Every model that satisfies all of its assumptions.
"""
function issound( ir::InferenceRule) :: Bool
	# Learning activity:
#	false
	vars = Proofs.variables(ir)
	tt = truth_table(vars)
	for model in tt
		if !evaluate(ir,model)
			return false
		end
	end

	true
end

#-----------------------------------------------------------------------------------------
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Propositions
"""
function demo()
	woof = wff( "(p->q)")
#	woof = wff( "(q->p)")
#	woof = wff( "((p->q) -> (~q->~p))")
#	woof = wff( "~(p&q)")
#	woof = wff( "(~~~p&p)")
#	woof = wff( "(p&(~p|q))")
#	woof = wff( "((p-&q)<->(~q|~p))")			# Only used in lab 102
	print_ttable(woof)
	println( "$woof is $(~istautology(woof) ? "not " : "")a tautology, ",
		"is $(~iscontradiction(woof) ? "not " : "")a contradiction, ",
		"and is $(~issatisfiable(woof) ? "not " : "")satisfiable!"
	)
	println()

	model = Model("p"=>true,"q"=>false)
	println( "In the model $model, the woof $woof evaluates to: $(evaluate(woof,model)).")
	println( "This model is described by the conjunctive woof: ", conjunctive_wff(model))
	println()

	tvalues = [true,true,false,true]
	vars = ["p","q"]
	dn_form = dnf( vars, tvalues)
	println( "The semantics ", tvalues, " for variables ", vars)
	println( "    are described by the following DNF:")
	print_ttable(dn_form)
end

end