class_name CardLib
extends RefCounted


const QUESTION_IMG_FILENAME = "question_image"

const ANSWER_IMG_FILENAME = "answer_image"

const CARDS_LIMIT := 1_000_000

const CardTexture := preload("res://sprites/blank_card.svg")


# How much it needs to scale the card image to fit the card.
# For example, 
# 		Card image width: 300
#		Card width: 600
# It needs to scale width by 2 (600 divided 300) the card image.
# As we don't want to fill the border too, we will decrease in 10% the card size.
static func scale_to_fit(texture: Texture2D) -> Vector2:
	var scale_width := CardTexture.get_width() * 0.9 / texture.get_width()
	var scale_height := CardTexture.get_height() * 0.9 / texture.get_height()
	
	return Vector2(scale_width, scale_height)


static func load_image(path: String) -> Texture2D:
	var texture: Texture2D
	
	# Imges that are included with the executable can be loaded with `load()`,
	# otherwise you have to load using Image.
	if path.begins_with("res://"):
		texture = load(path) as Texture2D
	else:
		var image := Image.load_from_file(path)
		texture = ImageTexture.create_from_image(image)
	
	assert(texture, "Fail to load image %s" % path)
	
	return texture


static func get_card_path(card: Card) -> String:
	return "%s/%s" % [DeckLib.get_deck_path(card.deck), card.identifier]


static func get_dir(card: Card) -> DirAccess:
	var card_path := get_card_path(card)
	
	DirAccess.make_dir_recursive_absolute(card_path)
	
	return DirAccess.open(card_path)


static func new_identifier(card: Card) -> String:
	var dir_path := DeckLib.get_deck_path(card.deck)
	var dir_access := DirAccess.open(dir_path)
	
	assert(
		dir_access,
		"Fail to open cards directory. Error: %s." % DirAccess.get_open_error()
	)
	
	for i in CARDS_LIMIT:
		if not dir_access.dir_exists(str(i)):
			return str(i)
	
	assert(
		false,
		"You have more than %s cards in ONE deck... Delete some cards" % CARDS_LIMIT
	)
	
	return "" # Ignore this


# Copy card images to the card directory and update card with the images paths. Example:
#	Copy:	"/home/username/image.jpg"
#	To:		"user://decks/[deck_id]/[card_id]/question_image.jpg"
static func save_card_images(card: Card, question_image_source: String, answer_image_source: String) -> void:
	var question_format := question_image_source.get_extension()
	var answer_format := answer_image_source.get_extension()
	var card_dir_path := get_card_path(card)
	var question_image_target := "%s/%s.%s" % [card_dir_path, QUESTION_IMG_FILENAME, question_format]
	var answer_image_target := "%s/%s.%s" % [card_dir_path, ANSWER_IMG_FILENAME, answer_format]
	var dir := get_dir(card)
	
	# Copying means that you will make the target file equal to the source file.
	# Before you start writing to the target file, you have to truncate it.
	# If source and target are the same, your source file will be truncate before reading.
	if question_image_source != question_image_target:
		dir.copy(question_image_source, question_image_target)
	
	if answer_image_source != answer_image_target:
		dir.copy(answer_image_source, answer_image_target)
	
	card.question_image = question_image_target
	card.answer_image = answer_image_target


static func remove_card_from_deck(card: Card) -> void:
	card.deck.cards.erase(card)
	OS.move_to_trash(ProjectSettings.globalize_path(get_card_path(card)))
