class_name Card
extends Resource


@export var identifier: String

@export_multiline var question: String = ""

@export_multiline var answer: String = ""

# Old card: Which deck this card belongs to.
# New card: Which deck this card will belong to.
var deck: Deck

@export var question_image: String = "res://sprites/missing_image.svg"

@export var answer_image: String = "res://sprites/missing_image.svg"
