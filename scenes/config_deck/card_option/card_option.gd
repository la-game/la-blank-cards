extends MarginContainer


signal updated(card: Card)

signal removed(card: Card)

var _card: Card

@onready var question_line = $Container/QuestionContainer/LineEdit

@onready var answer_line = $Container/AnswerContainer/LineEdit


func _ready() -> void:
	question_line.text = _card.question
	answer_line.text = _card.answer


func init(card: Card) -> void:
	_card = card


func gain_focus() -> void:
	updated.emit(_card)


func question_updated(new_text: String) -> void:
	_card.question = new_text
	updated.emit(_card)


func answer_updated(new_text: String) -> void:
	_card.answer = new_text
	updated.emit(_card)


func question_image_updated(new_text: String) -> void:
	_card.image_question = Image.load_from_file(new_text)
	updated.emit(_card)


func answer_image_updated(new_text: String) -> void:
	_card.image_answer = Image.load_from_file(new_text)
	updated.emit(_card)


func remove_card() -> void:
	removed.emit(_card)
	queue_free()
