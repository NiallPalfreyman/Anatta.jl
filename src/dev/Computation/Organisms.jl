#========================================================================================#
"""
	Organisms

Module Organisms: This is an organism module. It contains a data type Organism, plus a list of
methods that users can use to work with this data type. Use this file as a template for creating
your own julia programs.

Author: Niall Palfreyman, 23/10/2025
"""
module Organisms

# Externally callable symbols of the Organisms module:
export Weasel, greeting, Organism, Animal, Rabbit, Tree, encounter

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"Organism: a general living organisation."
abstract type Organism end

"Animal: an animate Organism."
abstract type Animal <: Organism end

"""
	Weasel

This is a Weasel data type.
"""
struct Weasel <: Animal
	name::String			# The name of the Weasel
	age::Int				# The age of the Weasel

	function Weasel( name::String, age)
		int_age = round(Int,age)
		new(name,int_age)
	end
end

"""
	Rabbit

This is a (mutable) Rabbit data type.
"""
mutable struct Rabbit <: Animal
	name::String
	age::Integer
end

"This is a Tree data type."
struct Tree <: Organism; name::String; age::Integer end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	greeting( organism)

Create a greeting from an Organism. This is just an example method to show you how to write your own
methods for manipulating the Organism data type defined above.
"""
function greeting( orgy:: Organism)
	string( "Hello, I am a $(typeof(orgy)) named ", orgy.name, ". I am ", orgy.age, " years old! :)")
end

#-----------------------------------------------------------------------------------------
"""
	encounter( meeter::Organism, meetee::Organism)

Simulate an encounter between two organisms.
"""
function encounter( meeter::Organism, meetee::Organism)
	println( meeter.name, " meets ", meetee.name, " and ", meet(meeter,meetee), ".")
end

#-----------------------------------------------------------------------------------------
"""
	meet( organism1, organism2)

Implement interactional behaviour between two organisms.
"""
meet( meeter::Weasel, meetee::Rabbit) = "attacks"
meet( meeter::Weasel, meetee::Weasel) = "challenges"
meet( meeter::Rabbit, meetee::Rabbit) = "sniffs"
meet( meeter::Rabbit, meetee::Weasel) = "hides"
meet( meeter::Organism, meetee::Organism) = "ignores"

#-----------------------------------------------------------------------------------------
"""
	demo()

Your module should have a demo() method at the end to show users how to use your module.
Notice that I haven't exported the demo() method - users should call it explicitly like this:
	Organisms.demo()
"""
function demo()
	println("\n============ Demonstrate Organisms: ===============")
	println("First create two Weasels:")
	wendy = Weasel( "Wendy", 3)
	willy = Weasel( "Willy", 2)
	display( willy)
	display( wendy)

	println("Now display a Weasel's greeting:")
	println( greeting(wendy))
	println()

	println( "Is Willy an Organism? $((typeof(willy) <: Organism) ? "Yes" : "No")")
	println( "The supertype of Weasel is: ", supertype( typeof(willy)))
	println( "The fields of the Weasel type are: ", fieldnames( Weasel))
	println()

	println("Now create a rabbit:")
	rabia = Rabbit( "Rabia", 5)
	println( greeting(rabia))
	println("... and after changing rabia's age:")
	rabia.age = 4
	println( greeting(rabia))
	println()

	tilly = Tree( "Tilly", 200)
	println( greeting( tilly))
	println()

	println( "Here is a simulation of several encounters:")
	encounter( wendy, willy)
	encounter( willy, rabia)
	encounter( rabia, wendy)
	encounter( rabia, tilly)
	encounter( tilly, wendy)
end

end