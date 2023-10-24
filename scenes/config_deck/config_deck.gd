class_name ConfigDeck
extends MarginContainer


const AliasOptionScene: PackedScene = preload("res://scenes/config_deck/alias_option/alias_option.tscn")

const CardOptionScene: PackedScene = preload("res://scenes/config_deck/card_option/card_option.tscn")

static var deck: Deck

var _current_card: Card

@onready var subject_line = $Container/LeftContainer/Container/SubjectContainer/LineEdit

@onready var aliases_options = $Container/LeftContainer/Container/AliasesContainer/AliasesOptions

@onready var cards_container = $Container/LeftContainer/Container/CardsContainer

@onready var card_image = $Container/RightContainer/Container/BlankCard/Container/Image

@onready var card_question = $Container/RightContainer/Container/BlankCard/Container/Image/Container/Question

@onready var flip_button = $Container/RightContainer/Flip

func _ready() -> void:
	subject_line.text = deck.subject
	reload_aliases()
	reload_cards()


func reload_aliases() -> void:
	for child in aliases_options.get_children():
		child.queue_free()
	
	for index in deck.aliases.size():
		var alias = deck.aliases[index]
		var alias_option = AliasOptionScene.instantiate()
		
		alias_option.init(index, alias)
		alias_option.updated.connect(update_alias)
		alias_option.removed.connect(remove_alias)
		aliases_options.add_child(alias_option)


func reload_cards() -> void:
	for child in cards_container.get_children():
		child.queue_free()
	
	for card in deck.cards:
		var card_option = CardOptionScene.instantiate()
		
		card_option.init(card)
		card_option.updated.connect(update_card)
		card_option.removed.connect(remove_card)
		cards_container.add_child(card_option)


func update_alias(index: int, new_text: String) -> void:
	deck.aliases[index] = new_text


func remove_alias(index: int) -> void:
	deck.aliases.remove_at(index)
	reload_aliases()


func add_new_alias() -> void:
	deck.aliases.append("")
	reload_aliases()


func update_card(card: Card) -> void:
	_current_card = card
	flip_card(flip_button.button_pressed)


func remove_card(card: Card) -> void:
	deck.cards.erase(card)
	reload_cards()


func add_new_card() -> void:
	deck.cards.append(Card.new())
	reload_cards()


func go_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func flip_card(is_flipped: bool) -> void:
	if not _current_card:
		return
	
	if is_flipped:
		card_question.text = _current_card.answer
		
		if _current_card.image_answer:
			card_image.texture = ImageTexture.create_from_image(_current_card.image_answer)
		else:
			card_image.texture = null
	else:
		card_question.text = _current_card.question
		
		if _current_card.image_question:
			card_image.texture = ImageTexture.create_from_image(_current_card.image_question)
		else:
			card_image.texture = null
