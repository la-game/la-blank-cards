class_name DeckLib
extends RefCounted


const DECKS_PATH := "user://decks"

const DECKS_LIMIT := 1_000_000


static func get_deck_path(deck: Deck) -> String:
	return "%s/%s" % [DECKS_PATH, deck.identifier]


static func get_dir(deck: Deck) -> DirAccess:
	var deck_path := get_deck_path(deck)
	
	DirAccess.make_dir_recursive_absolute(deck_path)
	
	return DirAccess.open(deck_path)


static func new_identifier() -> String:
	DirAccess.make_dir_recursive_absolute(DECKS_PATH)
	
	var dir_access := DirAccess.open(DECKS_PATH)
	
	assert(
		dir_access, 
		"Fail to open deck directory. Error: %s." % DirAccess.get_open_error()
	)
	
	for i in DECKS_LIMIT:
		if not dir_access.dir_exists(str(i)):
			return str(i)
	
	assert(
		false,
		"You have more than %s decks... Delete some decks" % DECKS_LIMIT
	)
	
	return "" # Ignore this


static func save_deck(deck: Deck) -> void:
	var dir_path := get_deck_path(deck)
	
	DirAccess.make_dir_recursive_absolute(dir_path)
	
	var file_path := "%s/deck.tres" % dir_path
	var error = ResourceSaver.save(deck, file_path)
	
	assert(error == OK, "Fail to save deck. Error: %s" % error)
