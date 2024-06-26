#========================================================================================#
"""
	TextAnalysis

Module TextAnalysis: This is a collection of methods for analysing text.

Author: Niall Palfreyman, 01/08/2023
"""
module TextAnalysis

# Externally callable symbols of the TextAnalysis module:
export splitwords, entry_counts, ngrams, ngram_counts, completion_cache

#-----------------------------------------------------------------------------------------
# Module types:
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Module methods:
#-----------------------------------------------------------------------------------------
"""
	splitwords( text)

Generate a list of words in the text, assuming the usual word-boundary separators.
"""
function splitwords( text)
	cleantext = replace( text, r"\s+" => " ")	# Clean up whitespace
	words = split( cleantext, r"(\s|\b)")		# Split words on whitespace or other word boundary

	words
end

"""
	entry_counts( list::Vector)

Generate a dictionary containing all entries in the entrylist, accompanied by their frequency
in the entrylist.
"""
function entry_counts( list::Vector)
	Dict([]=>5)
end

"""
	ngrams( wordlist::Vector, n::Int)

Construct a list of all word-sequences of length n contained in the given wordlist.
"""
function ngrams( wordlist::Vector, n::Int)
	[]
end

"""
	ngram_counts( wordlist::Vector, n::Int)

Construct a Dictionary of counts of all word-sequences of length n in the given wordlist.
"""
function ngram_counts( wordlist::Vector, n::Int)
	entry_counts( ngrams( wordlist, n))
end

"""
	completion_cache( grams)

Construct a Dictionary of all word-sequences of length n-1, and assign to each such key a vector
containing words that complete this to an n-gram in the given collection of grams.
"""
function completion_cache( grams)
	cache = Dict()
	
	cache
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Your module should have a demo() method at the end to show users how to use your module.
Notice that I haven't exported the demo() method - users should call it explicitly like this:
	TextAnalysis.demo()
"""
function demo()
	println("\n============ Demonstrate TextAnalysis: ===============")
	println("First create a sample_text:")
	sample_text = "A lazy   brown fox  trips,           over the    lazy brown dog."
	display( sample_text)
	println()

	word_list = splitwords(sample_text)
	println("Now divide up the sample_text into individual words:")
	display( word_list)
	println()

	println("Here is a dictionary of the word frequencies:")
	display( entry_counts(word_list))
	println()
end

end