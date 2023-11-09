extends MarginContainer


const DeckView = preload(
	"res://src/scenes/screens/decks_screen/deck_item/deck_view/deck_view.gd"
)

@export var checkbox: CheckBox

@onready var deck_view := %DeckView as DeckView


func init(deck: Deck) -> void:
	ready.connect(
		func():
			checkbox.text = deck.subject
			deck_view.set_cards_images(deck)
	)
