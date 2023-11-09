extends Node2D


@export var card_image: Sprite2D

var image_path: String


func set_card_image(path: String) -> void:
	var texture := CardLib.load_image(path)
	var new_scale := CardLib.scale_to_fit(texture)
	
	image_path = path
	card_image.texture = texture
	card_image.scale = new_scale
