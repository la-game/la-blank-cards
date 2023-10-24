class_name PlayDeck
extends MarginContainer


static var deck: Deck

var order: Array[int] = []

var card_index: int = 0

var first_card: bool = true

var showing_question: bool = true

var rng = RandomNumberGenerator.new()

@onready var card_container = $Card/Container

@onready var card_image = $Card/Container/Image

@onready var card_question = $Card/Container/Image/Container/Question

@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	rng.randomize()
	decide_order()


func decide_order() -> void:
	var options = range(deck.cards.size())
	var pick: int
	
	order = []
	
	while options:
		pick = rng.randi_range(0, options.size() - 1)
		order.append(options.pop_at(pick))


func draw_card() -> void:
	if animation_player.is_playing():
		return
	
	if deck.cards.is_empty():
		return
	
	if order.is_empty():
		decide_order()
	
	card_index = order.pop_back()
	showing_question = false
	
	if not first_card:
		animation_player.queue("DISCARD")
	else:
		first_card = false
	
	animation_player.queue("DRAW")
	animation_player.queue("FLIP")


func flip_card() -> void:
	if deck.cards.is_empty():
		return
	
	if first_card:
		return
	
	var card: Card = deck.cards[card_index]
	
	showing_question = not showing_question
	
	if showing_question:
		card_question.text = card.question
		
		if card.image_question:
			card_image.texture = ImageTexture.create_from_image(card.image_question)
		else:
			card_image.texture = null
	else:
		card_question.text = card.answer
		
		if card.image_answer:
			card_image.texture = ImageTexture.create_from_image(card.image_answer)
		else:
			card_image.texture = null
	
