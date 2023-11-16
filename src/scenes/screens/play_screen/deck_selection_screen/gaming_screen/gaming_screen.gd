extends Node2D


enum Waiting {
	DRAW,
	FLIP,
	DISCARD,
}

@export var action_button: Button

@export var question_text: Label

@export var answer_text: Label

@export var animation_player: AnimationPlayer

static var cards: Array[Card] = []

var current_card: Card

var waiting := Waiting.DRAW

var rng := RandomNumberGenerator.new()

@onready var current_animation = $FlipAnimation as CardAnimation

@onready var default_animation = $FlipAnimation as CardAnimation

@onready var special_animations = [
	$BoomerangAnimation,
	$SummonAnimation,
	$SlotMachineAnimation
]


func change_to_deck_selection_screen() -> void:
	get_tree().change_scene_to_packed(
		load(
			"res://src/scenes/screens/play_screen/deck_selection_screen/deck_selection_screen.tscn"
		)
	)


func on_action_button_pressed() -> void:
	if current_animation.animation_player.is_playing():
		return
	
	match waiting:
		Waiting.DRAW:
			setup_new_card()
			setup_new_animation()
			
			current_animation.draw()
			action_button.text = "Flip"
			waiting = Waiting.FLIP
			animation_player.play("SHOW_QUESTION")
		Waiting.FLIP:
			current_animation.flip()
			action_button.text = "Discard"
			waiting = Waiting.DISCARD
			animation_player.play("SHOW_ANSWER")
		Waiting.DISCARD:
			current_animation.discard()
			action_button.text = "Draw"
			waiting = Waiting.DRAW
			animation_player.play("HIDE_ALL")


func setup_new_card() -> void:
	current_card = cards.pick_random() as Card
	answer_text.text = current_card.answer
	question_text.text = current_card.question


func setup_new_animation() -> void:
	if rng.randi_range(1, 100) >= 95:
		current_animation = special_animations.pick_random()
	else:
		current_animation = default_animation
	
	current_animation.question_image = CardLib.load_image(current_card.question_image)
	current_animation.answer_image = CardLib.load_image(current_card.answer_image)
