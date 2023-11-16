# Holds information about all decks from player.
# This methods are also dependents of acessing all decks,
# for this reason they cannot be at DeckLib.
extends Node


var decks: Array[Deck] = []


func _ready() -> void:
	load_decks()


func load_decks() -> void:
	DirAccess.make_dir_recursive_absolute(DeckLib.DECKS_PATH)
	
	var dir_access := DirAccess.open(DeckLib.DECKS_PATH)
	
	assert(dir_access, "Fail to open decks directory. Error: %s." % DirAccess.get_open_error())
	
	for dir_name in dir_access.get_directories():
		var deck_path := "%s/%s/deck.tres" % [DeckLib.DECKS_PATH, dir_name]
		var deck := load(deck_path) as Deck
		
		for card in deck.cards:
			card.deck = deck
		
		decks.append(deck)


func remove_deck(deck: Deck) -> void:
	var deck_path := DeckLib.get_deck_path(deck)
	var error := OS.move_to_trash(ProjectSettings.globalize_path(deck_path))
	
	assert(error == OK, "Fail to delete deck directory. Error: " % error)
	
	decks.erase(deck)
	
