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
	no_line_breaks = replace(text, "\",\"\",\"" => " ")			# Remove linebreaks
	ascii_quotes = replace(no_line_breaks, r"(“|”)" => "\"")	# Remove italic quotes
	only_blanks = replace( ascii_quotes, r"\s+" => " ")			# Remove surplus whitespace
	split( only_blanks, r"(\s)")								# Split words on whitespace
end

"""
	entry_counts( entrylist::Vector)

Generate a dictionary containing all entries in the entrylist, accompanied by their frequency
in the entrylist.
"""
function entry_counts( entrylist::Vector)
	counts = Dict()

	for entry in entrylist
		if haskey(counts,entry)
			counts[entry] += 1
		else
			counts[entry] = 1
		end
	end

	counts
end

"""
	ngrams( wordlist::Vector, n::Int)

Construct a list of all word-sequences of length n, contained in the given wordlist.
"""
function ngrams( wordlist::Vector, n::Int)
	decr = n-1
	[wordlist[i:i+decr] for i ∈ (1:length(wordlist)-decr)]
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
	for ngram in grams
		if haskey(cache,ngram[1:end-1])
			cache[ngram[1:end-1]] = [cache[ngram[1:end-1]] ngram[end]]
		else
			cache[ngram[1:end-1]] = [ngram[end]]
		end
	end
	
	cache
end

#-----------------------------------------------------------------------------------------
"""
	write_novel( source_text::String, num_words::Int; ngram_order=3)

Build an n-gram order language model of the given source text and use this to generate a string of
num_words written in the style of the source_text.
"""
function write_novel( source_text::String, num_words::Int, ngram_order=3)
	wordlist = splitwords(source_text)
	circular_wordlist = [wordlist..., wordlist[1:ngram_order-1]...]
	source_ngrams = ngrams( circular_wordlist, ngram_order)
	language_model = completion_cache(source_ngrams)

	# Build first ngram_order words of novel, starting from the beginning of a sentence:
	sentence_start = rand(1:(length(circular_wordlist)-100))
	while !isuppercase(circular_wordlist[sentence_start][1])
		sentence_start += 1
	end
	novel_wordlist = circular_wordlist[sentence_start:sentence_start+ngram_order-1]

	# Expand novel from the first ngram_order words:
	for _ in ngram_order+1:num_words
		previous_words = novel_wordlist[end-(ngram_order-2):end]
		potential_words = language_model[previous_words]
		new_word = rand(potential_words)
		push!(novel_wordlist, new_word)
	end

	join(novel_wordlist," ")
end

#-----------------------------------------------------------------------------------------
"""
	demo()

Use write_novel() to build an appropriate n-gram language model of the complete text of Pride and
Prejudice, and use this to generate a text file novel.txt containing num_words. The generated novel
is written in English in the style of Jane Austen (the author of Pride and Prejudice).
"""
function demo()
	println("\n============ Demonstrate Nineteenth-century novel-writing: ===============")
	println("Here are the first 100 characters of the novel Pride and Prejudice ...")
	pandp_site = "https://shorturl.ac/pandp"
	raw_text = read(download(pandp_site),String)
	start_index = findfirst( "It is a truth", raw_text)[1]
	stop_index = findlast( "of uniting them.",raw_text)[end]
	pandp_text = raw_text[start_index:stop_index]
	display( pandp_text[1:150])
	println()

	ngram_order = 5
	num_words = 150
	println("Now build our $num_words-word novel based on $ngram_order-grams ...")
	println()
	println( write_novel( pandp_text, num_words, ngram_order))
end

end