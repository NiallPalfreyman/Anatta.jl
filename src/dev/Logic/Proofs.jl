#========================================================================================#
#		Proofs
#
# Module Proofs encapsulates computational deduction using inference rules in PL.
#	
# Author: Niall Palfreyman, December 2024.
#========================================================================================#
include( "Propositions.jl")
using .Propositions

module Proofs

using ..Propositions
export InferenceRule, SpecialisationMap, specialisation, merge, wff_specialisation

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"""
	SpecialisationMap

A SpecialisationMap is a mapping from Strings to WFFs.
"""
SpecialisationMap = Dict{String,WFF}

#-----------------------------------------------------------------------------------------
"""
	InferenceRule

An InferenceRule comprises a Tuple of Assumption WFFs and a single Conclusion WFF.
"""
struct InferenceRule
	assumptions::Vector{WFF}
	conclusion::WFF
end

#-----------------------------------------------------------------------------------------
"""
	InferenceRule( assumption::AbstractString, conclusion::AbstractString)

Construct an InferenceRule from a single assumption WFF-String and a conclusion WFF-String.
"""
function InferenceRule( assumption::AbstractString, conclusion::AbstractString)
	InferenceRule([assumption],conclusion)
end

#-----------------------------------------------------------------------------------------
"""
	InferenceRule( conclusion::AbstractString)

Construct an Axiom from a conclusion WFF-String.
"""
function InferenceRule( conclusion::AbstractString)
	InferenceRule(Vector{WFF}[],conclusion)
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
# Accessor methods:
#-----------------------------------------------------------------------------------------
"""
	variables( ir::InferenceRule)

Return the Set of all variable names in the assumptions and conclusion of the InferenceRule.
"""
function variables(ir::InferenceRule)
	# Learning activity:
#	Set(["p"])
	union(Propositions.variables.(ir.assumptions)...,Propositions.variables(ir.conclusion))
end

#-----------------------------------------------------------------------------------------
# Specialisation methods:
#-----------------------------------------------------------------------------------------
"""
	specialisation( infrule::InferenceRule, specmap::SpecialisationMap) :: InferenceRule

Replace each variable - say, "p" - throughout the given inference rule by the new expression
smap["p"].

Use-case:
	specialisation( InferenceRule( ["~~p"], "p"), SpecialisationMap("p"=>wff("(q->r)"))
	) == InferenceRule( ["~~(q->r)"], "(q->r)")
"""
function specialisation( infrule::InferenceRule, specmap::SpecialisationMap) :: InferenceRule
	@assert all(Propositions.isvariable.(keys(specmap)))

	# Learning activity:
#	infrule
	InferenceRule(
		map( infrule.assumptions) do assumption
			Propositions.substitute_vars( assumption, specmap)
		end,
		Propositions.substitute_vars( infrule.conclusion, specmap)
	)
end

#-----------------------------------------------------------------------------------------
"""
	merge( specmap1::Union{SpecialisationMap,Nothing},  specmap2::Union{SpecialisationMap,Nothing}
	) :: Union{SpecialisationMap,Nothing}

Merge the two SpecialisationMaps while checking their consistency. The merged map is nothing if
either argument map is nothing or if the maps contain a common key with different values.
Otherwise, the merged map contains the union of all Pairs from both maps.

Use-case:
	merge( SpecialisationMap("x"=>"a","y"=>"b"), SpecialisationMap("y"=>"b","z"=>"c")
	) == SpecialisationMap("x"=>"a","y"=>"b","z"=>"c")
"""
function merge(
	specmap1::Union{SpecialisationMap,Nothing}, specmap2::Union{SpecialisationMap,Nothing}
) :: Union{SpecialisationMap,Nothing}
	if isnothing(specmap1) || isnothing(specmap2)
		return nothing
	end
	@assert all(Propositions.isvariable.(keys(specmap1)))
	@assert all(Propositions.isvariable.(keys(specmap2)))

	# Learning activity:
#	nothing
	specmap = copy(specmap1)
	ks = keys(specmap)
	for (k,v) in specmap2
		if k in ks
			if specmap[k] != v
				return nothing
			end
		else
			specmap[k] = v
		end
	end

	specmap
end

#-----------------------------------------------------------------------------------------
"""
	specialisation_map( gwff::WFF, swff::WFF) :: Union{SpecialisationMap,Nothing}

Compute the minimal SpecialisationMap that maps the general WFF onto the special WFF. Return
nothing if you cannot find this map.

Use-case:
	specialisation_map( wff("(x->y)"), wff("(F->T)")) == SpecialisationMap("x"=>"F","y"=>"T")
	specialisation_map( wff("(x->y)"), wff("((a&c)->c)")) == SpecialisationMap("x"=>"(a&c)","y"=>"c")
"""
function specialisation_map( gwff::WFF, swff::WFF) :: Union{SpecialisationMap,Nothing}
	# Learning activity:
#	nothing
	if isvariable(gwff.head)
		(gwff.head == swff.head) ? SpecialisationMap() : SpecialisationMap(gwff.head=>swff)
	elseif gwff.head == swff.head
		if isconstant(gwff.head)
			SpecialisationMap()
		elseif isunary(gwff.head)
			specialisation_map( gwff.arg1, swff.arg1)
		else
			merge( specialisation_map(gwff.arg1,swff.arg1),
				specialisation_map(gwff.arg2,swff.arg2)
			)
		end
	else
		nothing
	end
end

#-----------------------------------------------------------------------------------------
"""
	specialisation_map( ginfrule::InferenceRule, sinfrule::InferenceRule
	) :: Union{SpecialisationMap,Nothing}

Compute the minimal SpecialisationMap that maps the general InferenceRule onto the special
InferenceRule. Return nothing if you cannot find this map.

Use-case:
	specialisation_map(
		InferenceRule("(~p->~(q|T))"), InferenceRule("(~(x|y)->~((z&(w->~z))|T))")
	) == SpecialisationMap("p"=>"(x|y)","q"=>"(z&(w->~z))")
"""
function specialisation_map( ginfrule::InferenceRule, sinfrule::InferenceRule
) :: Union{SpecialisationMap,Nothing}
	if length(ginfrule.assumptions) != length(sinfrule.assumptions)
		return nothing
	end

	# Learning activity:
#	nothing
	mapping = specialisation_map(ginfrule.conclusion,sinfrule.conclusion)
	if isnothing(mapping)
		return nothing
	end

	for pair in zip(ginfrule.assumptions,sinfrule.assumptions)
		mapping = merge( mapping, specialisation_map(pair...))
		if isnothing(mapping)
			return nothing
		end
	end

	mapping
end

#-----------------------------------------------------------------------------------------
"""
	isspecialisation( ginfrule::InferenceRule, sinfrule::InferenceRule) :: Bool

Test whether sinfrule is a valid specialisation of ginfrule.

Use-case:
	isspecialisation(
		InferenceRule("(~p->~(q|T))"), InferenceRule("(~(x|y)->~((z&(w->~z))|T))")
	) == true
"""
function isspecialisation( ginfrule::InferenceRule, sinfrule::InferenceRule) :: Bool
	!isnothing(specialisation_map(ginfrule,sinfrule))
end

#-----------------------------------------------------------------------------------------
# Demonstration methods:
#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Proofs
"""
function demo()
	println( variables(InferenceRule(["(p|q)","(~p|r)"],"(q|r)")))
	println( specialisation_map( WFF("(~p->~(q|T))"), WFF("(~(x|y)->~((z&(w->~z))|T))")))
	println( isspecialisation(
		InferenceRule(["(p->q)","(p&p)"],"p"),
		InferenceRule(["(~T->(r&~z))","(~T&~T)"],"~T")
	))
end

end