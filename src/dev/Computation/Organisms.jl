#========================================================================================#
"""
	Organisms

Module Organisms: This is a weasel module. It contains a data type Weasel, plus a list of methods
that users can use to work with your data type. Use this file as a template for creating your
own julia programs.

Author: Niall Palfreyman, 05/07/2023
"""
module Organisms

# Externally callable symbols of the Organisms module:
export Weasel, greeting, Organism, Animal

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------
"Organism: a general living being."
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
	length::Integer
end

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	greeting( weasel)

Create a greeting from the Weasel. This is just an example method to show you how to write your own
methods for manipulating the Weasel data type defined above.
"""
function greeting( weasel::Weasel)
	string( "Hello, I am a Weasel named ", weasel.name, ". I am ", weasel.age, " years old! :)")
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Your module should have a demo() method at the end to show users how to use your module.
Notice that I haven't exported the demo() method - users should call it explicitly like this:
	Organisms.demo()
"""
function demo()
	println("\n============ Demonstrate Organisms: ===============")
	println("First create a Weasel:")
	wendy = Weasel( "Wendy", 3.1415)
	display( wendy)
	println()

	println("Now display the Weasel's greeting:")
	println( greeting(wendy))
	println()
end

end