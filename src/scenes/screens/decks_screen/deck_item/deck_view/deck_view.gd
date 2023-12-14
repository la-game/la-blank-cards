extends Node2D


@export var front_card_image: Sprite2D

@export var middle_card_image: Sprite2D

@export var back_card_image: Sprite2D


# Pick the first 3 cards to appear to player.
func set_cards_images(deck: Deck) -> void:
	for step in deck.cards.size():
		if step == 3: # No more than 3 cards
			break
		
		var card := deck.cards[step]
		var texture := CardLib.load_image(card.question_image)
		var new_scale := CardLib.scale_to_fit(texture)
		
		match step:
			0:
				front_card_image.texture = texture
				front_card_image.scale = new_scale
			1:
				middle_card_image.texture = texture
				middle_card_image.scale = new_scale
			2:
				back_card_image.texture = texture
				back_card_image.scale = new_scale
	
