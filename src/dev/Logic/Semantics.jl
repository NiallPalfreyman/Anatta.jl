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
#	true
	if  Propositions.is_constant(wff.head)
		wff.head == "T"
	elseif Propositions.is_variable(wff.head)
		model[wff.head]
	elseif Propositions.is_unary(wff.head)
		!evaluate(wff.arg1,model)
	elseif wff.head=="&"
		evaluate(wff.arg1,model) && evaluate(wff.arg2,model)
	elseif wff.head=="|"
		evaluate(wff.arg1,model) || evaluate(wff.arg2,model)
	elseif wff.head=="->"
		!evaluate(wff.arg1,model) || evaluate(wff.arg2,model)
	else # Something's gone wrong:
		error( "Non-permissible operator $(wff.head)")
	end
end

#-----------------------------------------------------------------------------------------
"""
	all_models( vars::Vector{String}) :: Iterable{Model}

all_models(vars) computes an Iterable of all possible models over the given variable names.
The order of this Iterable is equal to the order of variables in the vars Vector, with false
preceding true.

Example: all_models( ["q","p"]) -> [
	Model("q"=>false,"p"=>false), Model("q"=>false,"p"=>true),
	Model("q"=>true,"p"=>false),  Model("q"=>true,"p"=>true)
]
"""
function all_models( vars::Union{Set{String},Vector{String}})
	@assert all( Propositions.is_variable.(vars))

	# Learning activity:
#	map( Model, ((("a91",false),),(("a91",true),)))
	(Model(vars.=>reverse(t_row)) for t_row in
		Base.product([[false,true] for _ in vars]...)
	)
end

#-----------------------------------------------------------------------------------------
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Propositions
"""
function demo()
	wff = parse( WFF, "~((p&q5)|(p&~q3))")
	models = all_models(Propositions.variables(wff))
	for model in models
		println("$model: ", evaluate(wff,model))
	end
end

end