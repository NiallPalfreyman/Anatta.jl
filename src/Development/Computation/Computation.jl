#========================================================================================#
"""
	Computation

Module Computation investigates issues of computational complexity.
	
Author: Niall Palfreyman (May 2023).
"""
module Computation

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	count_seq( needle::String, haystack::String)

Count how many occurrences of the needle sequence occur in the haystack sequence.
"""
function count_seq( needle::String, haystack::String)
	if length(needle) > length(haystack)
		return 0
	end

	count = 0
	for i in 1:(length(haystack)-length(needle)+1)
		if haystack[i:i+length(needle)-1] == needle
			count = count + 1
		end
	end

	count
end

#-----------------------------------------------------------------------------------------
"""
count_common( seq1::String, seq2::String, len::Int)

Return the number of common substrings of the sequences seq1 and seq2 having length len.
"""
function count_common( seq1::String, seq2::String, len::Int)
	5													# This is dummy code
end

#-----------------------------------------------------------------------------------------
"""
fast_common( seq1::String, seq2::String, len::Int)

Fast implementation of count_common()
"""
function fast_common( seq1::String, seq2::String, len::Int)
	5
end

#-----------------------------------------------------------------------------------------
"""
fib( n::Int)

Recursive implementation of the Fibonacci function.
"""
function fib( n::Int)
	if n < 3
		return 1
	end

	fib(n-1) + fib(n-2)
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Run a use-case scenario of Computation
"""
function demo()
	seq1 = "abcde"
	seq2 = "xyzcdegh"

	println( "Testing the call count_seq(\"bc\",\"$seq1\") :")
	println( count_seq( "bc", seq1))
	println()

	println( "Testing count_common() using the strings \"$seq1\" and \"$seq2\",")
	println( "searching for common substring with lengths in the range 0:6 :")
	println(
		map(0:6) do n
			count_common( seq1, seq2, n)
		end
	)
	println()

	println( "Testing fast_common() using the strings \"$seq1\" and \"$seq2\",")
	println( "searching for common substring with lengths in the range 0:6 :")
	println(
		map(0:6) do n
			fast_common( seq1, seq2, n)
		end
	)
end

end