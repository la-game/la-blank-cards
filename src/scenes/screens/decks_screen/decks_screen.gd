extends MarginContainer


const DeckItem := preload(
	"res://src/scenes/screens/decks_screen/deck_item/deck_item.gd"
)

const DeckItemScene := preload(
	"res://src/scenes/screens/decks_screen/deck_item/deck_item.tscn"
)

const DeckScreen := preload(
	"res://src/scenes/screens/deck_screen/deck_screen.gd"
)

@export var decks_container: GridContainer


func _ready() -> void:
	clear_decks()
	load_decks()


func clear_decks() -> void:
	for child in decks_container.get_children():
		# Can take some time until removed, so let's hide until there.
		child.visible = false
		child.queue_free()


func load_decks() -> void:
	for deck in DeckCollection.decks:
		var deck_item = DeckItemScene.instantiate()
		deck_item.init(deck)
		deck_item.deck_selected.connect(change_to_deck_screen)
		decks_container.add_child(deck_item)


func change_to_start_screen() -> void:
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/start_screen/start_screen.tscn")
	)


func change_to_deck_screen(deck: Deck) -> void:
	DeckScreen.deck = deck
	
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/deck_screen/deck_screen.tscn")
	)


func create_new_deck() -> void:
	var deck := Deck.new()
	deck.identifier = DeckLib.new_identifier()
	
	DeckLib.save_deck(deck)
	DeckCollection.decks.append(deck)
	change_to_deck_screen(deck)


func remove_selected_decks() -> void:
	for deck_item in decks_container.get_children():
		if deck_item is DeckItem:
			if deck_item.is_selected:
				DeckCollection.remove_deck(deck_item.deck)
				deck_item.queue_free()
