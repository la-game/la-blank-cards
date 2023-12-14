extends MarginContainer


const CardSearchBar := preload(
	"res://src/scenes/screens/deck_screen/card_search_bar/card_search_bar.gd"
)

const CardItem := preload(
	"res://src/scenes/screens/deck_screen/card_item/card_item.gd"
)

const CardItemScene := preload(
	"res://src/scenes/screens/deck_screen/card_item/card_item.tscn"
)

const CardEdit := preload(
	"res://src/scenes/screens/deck_screen/card_edit/card_edit.gd"
)

@export var cards_container: GridContainer

@export var subject_line_edit: LineEdit

static var deck: Deck

@onready var card_search_bar := %CardSearchBar as CardSearchBar

@onready var card_edit := %CardEdit as CardEdit


func _ready() -> void:
	reload_cards()
	
	card_search_bar.deck = deck
	subject_line_edit.text = deck.subject
	card_edit.visible = false


func reload_cards() -> void:
	clear_cards()
	load_cards(deck.cards)


func clear_cards() -> void:
	for child in cards_container.get_children():
		# Can take some time until removed, so let's hide until there.
		child.visible = false
		child.queue_free()


func load_cards(cards: Array[Card]) -> void:
	for card in cards:
		var card_item = CardItemScene.instantiate()
		card_item.init(card)
		card_item.card_selected.connect(open_edit_card)
		cards_container.add_child(card_item)


func change_to_decks_screen() -> void:
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/decks_screen/decks_screen.tscn")
	)


func load_search_result(
	match_question: Array[Card],
	match_answer: Array[Card] = []
) -> void:
	clear_cards()
	load_cards(match_question)
	load_cards(match_answer)


func update_subject(subject: String) -> void:
	deck.subject = subject
	DeckLib.save_deck(deck)


func open_edit_card(card: Card) -> void:
	card_edit.card = card
	card_edit.visible = true


func create_new_card() -> void:
	var new_card := Card.new()
	new_card.deck = deck
	new_card.identifier = CardLib.new_identifier(new_card)
	
	card_edit.card = new_card
	card_edit.visible = true


func remove_selected_cards() -> void:
	for card_item in cards_container.get_children():
		if card_item is CardItem:
			if card_item.is_selected:
				CardLib.remove_card_from_deck(card_item.card)
				card_item.queue_free()
	
	DeckLib.save_deck(deck)
