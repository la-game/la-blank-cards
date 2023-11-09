extends Node


var decks: Array[Deck] = []


func _ready() -> void:
	load_decks()


func load_decks() -> void:
	DirAccess.make_dir_recursive_absolute(DeckLib.DECKS_PATH)
	
	var dir_access := DirAccess.open(DeckLib.DECKS_PATH)
	
	assert(dir_access, "Fail to open decks directory. Error: %s." % DirAccess.get_open_error())
	
	for dir_name in dir_access.get_directories():
		var new_deck = Deck.new()
		new_deck.identifier = dir_name
		
		load_cards(new_deck)
		decks.append(new_deck)


func load_cards(deck: Deck) -> void:
	var dir_access := DeckLib.get_dir(deck)
	
	assert(dir_access, "Fail to open deck directory. Error: %s." % DirAccess.get_open_error())
	
	for dir_name in dir_access.get_directories():
		var new_card = Card.new()
		new_card.identifier = dir_name
		
		deck.cards.append(new_card)
