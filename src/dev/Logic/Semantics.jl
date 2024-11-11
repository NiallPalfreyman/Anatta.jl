#========================================================================================#
"""
	Semantics

Module Semantics encapsulates the model-based meaning of sentences in PL.
	
Author: Niall Palfreyman (November 2024).
"""
module Semantics

include( "Propositions.jl")
using .Propositions

export Model

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
		if !is_variable(var)
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
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Propositions
"""
function demo()
	model = Model("a"=>true,"b"=>false)
	println(variables(model))
end

end