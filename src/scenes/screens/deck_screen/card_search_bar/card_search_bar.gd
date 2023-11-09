extends LineEdit


signal search_finished(match_question: Array[Card], match_answer: Array[Card])

var deck: Deck


# Naive approach, doesn't take many factors in count (like word order).
func search_card(new_text: String) -> void:
	# No deck, no search.
	if not deck:
		return
	
	# No text, show everything.
	if not new_text:
		search_finished.emit(deck.cards)
		return
	
	var match_question: Array[Card] = []
	var match_answer: Array[Card] = []
	var words := new_text.to_lower().split(" ")
	
	for card in deck.cards:
		# Lowercase everybody
		var question = card.question.to_lower()
		var answer = card.answer.to_lower()
		
		if SearchLib.any_text_in_string(words, question):
			match_question.append(card)
		elif SearchLib.any_text_in_string(words, answer):
			match_answer.append(card)
	
	search_finished.emit(match_question, match_answer)
