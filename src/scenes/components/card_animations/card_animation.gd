class_name CardAnimation
extends Node2D


@export var animation_player: AnimationPlayer

var question_image: Texture2D:
	set(t):
		question_image = t
		on_question_image_changed()


var answer_image: Texture2D:
	set(t):
		answer_image = t
		on_answer_image_changed()


func draw() -> void:
	animation_player.play("DRAW")


func flip() -> void:
	animation_player.play("FLIP")


func discard() -> void:
	animation_player.play("DISCARD")


func on_question_image_changed():
	pass


func on_answer_image_changed():
	pass
