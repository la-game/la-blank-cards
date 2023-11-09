extends ScrollContainer


signal saved()

const CardView := preload(
	"res://src/scenes/screens/deck_screen/card_item/card_view/card_view.gd"
)

@export var question_edit: TextEdit

@export var question_image_dialog: FileDialog

@export var answer_edit: TextEdit

@export var answer_image_dialog: FileDialog

var card: Card:
	set(c):
		card = c
		question_edit.text = c.question
		answer_edit.text = c.answer
		set_question_image(c.question_image)
		set_answer_image(c.answer_image)

@onready var question_card := %QuestionCardView as CardView

@onready var answer_card := %AnswerCardView as CardView


func popup_question_image_dialog(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		question_image_dialog.popup_centered()


func popup_answer_image_dialog(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		answer_image_dialog.popup_centered()


func set_question_image(path: String) -> void:
	question_card.set_card_image(path)


func set_answer_image(path: String) -> void:
	answer_card.set_card_image(path)


func save_changes() -> void:
	if not card:
		return
	
	card.question = question_edit.text
	card.answer = answer_edit.text
	
	CardLib.save_card_images(card, question_card.image_path, answer_card.image_path)
	
	# If is a new card, it will not be in the deck.
	if card not in card.deck.cards:
		card.deck.cards.append(card)
	
	DeckLib.save_deck(card.deck)
	
	saved.emit()
	
	visible = false


func cancel_changes() -> void:
	visible = false
