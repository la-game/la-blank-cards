extends MarginContainer


signal card_selected(card: Card)

const CardView = preload(
	"res://src/scenes/screens/deck_screen/card_item/card_view/card_view.gd"
)

@export var checkbox: CheckBox

var card: Card

var is_selected: bool:
	get:
		return checkbox.button_pressed

@onready var card_view := %CardView as CardView

func init(c: Card) -> void:
	ready.connect(
		func():
			card = c
			card_view.set_card_image(c.question_image)
	)


func select_card(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		card_selected.emit(card)
