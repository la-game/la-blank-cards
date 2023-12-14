extends LineEdit


signal search_finished(match_subject: Array[Deck], match_aliases: Array[Deck])


# Naive approach, doesn't take many factors in count (like word order).
#
# Split the search text in "words" and search each individually (making order indifferent),
# so searching "hello world" and "world hello" give the same result.
#
# Note: Technically doesn't split in words, just split using spaces as delimiter.
func search_deck(new_text: String) -> void:
	var match_subject: Array[Deck] = []
	var match_aliases: Array[Deck] = []
	var words := new_text.to_lower().split(" ")
	
	for deck in DeckCollection.decks:
		# Lowercase everybody
		var subject = deck.subject.to_lower()
		var aliases = deck.aliases.map(func(t: String): return t.to_lower())
		
		if SearchLib.any_text_in_string(words, subject):
			match_subject.append(deck)
		elif SearchLib.any_text_in_strings(words, aliases):
			match_aliases.append(deck)
	
	search_finished.emit(match_subject, match_aliases)
