extends MarginContainer


const DeckItem := preload(
	"res://src/scenes/screens/decks_screen/deck_item/deck_item.gd"
)

const DeckItemScene := preload(
	"res://src/scenes/screens/decks_screen/deck_item/deck_item.tscn"
)

const GamingScreen := preload(
	"res://src/scenes/screens/play_screen/deck_selection_screen/gaming_screen/gaming_screen.gd"
)

@export var decks_container: GridContainer


func _ready() -> void:
	clear_cards()
	load_cards(DeckCollection.decks)


func change_to_play_screen() -> void:
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/play_screen/play_screen.tscn")
	)


func clear_cards() -> void:
	for child in decks_container.get_children():
		# Can take some time until removed, so let's hide until there.
		child.visible = false
		child.queue_free()


func load_cards(decks: Array[Deck]) -> void:
	for deck in decks:
		var deck_item = DeckItemScene.instantiate()
		deck_item.init(deck)
		decks_container.add_child(deck_item)


func load_search_result(
	match_subject: Array[Deck],
	match_aliases: Array[Deck] = []
) -> void:
	clear_cards()
	load_cards(match_subject)
	load_cards(match_aliases)


func change_to_gaming_screen() -> void:
	var selected_decks: Array[Deck] = []
	
	for deck_item in decks_container.get_children():
		if deck_item is DeckItem:
			if deck_item.is_selected:
				selected_decks.append(deck_item.deck)
	
	if selected_decks.is_empty():
		return
	
	var cards: Array[Card] = []
	
	for deck in selected_decks:
		cards.append_array(deck.cards)
	
	GamingScreen.cards = cards
	
	get_tree().change_scene_to_packed(
		load(
			"res://src/scenes/screens/play_screen/deck_selection_screen/gaming_screen/gaming_screen.tscn"
		)
	)
