extends MarginContainer


signal deck_selected(deck: Deck)

const DeckView = preload(
	"res://src/scenes/screens/decks_screen/deck_item/deck_view/deck_view.gd"
)

@export var checkbox: CheckBox

var deck: Deck

var is_selected: bool:
	get:
		return checkbox.button_pressed

@onready var deck_view := %DeckView as DeckView


func init(d: Deck) -> void:
	ready.connect(
		func():
			deck = d
			checkbox.text = d.subject
			deck_view.set_cards_images(d)
	)


func select_deck(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		deck_selected.emit(deck)
