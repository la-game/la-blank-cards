class_name SubjectOption
extends MarginContainer


const ConfigScene: PackedScene = preload("res://scenes/config_deck/config_deck.tscn")

const PlayScene: PackedScene = preload("res://scenes/play_deck/play_deck.tscn")

var _deck: Deck

@onready var subject_button: Button = $Container/SubjectButton

@onready var config_button: Button = $Container/ConfigButton


func _ready() -> void:
	subject_button.text = _deck.subject


func init(deck: Deck) -> SubjectOption:
	_deck = deck
	return self


func contains(texts: Array[String]) -> bool:
	# Note: Lowercase for search only. Don't change the real text!
	
	# Search on subjects
	for text in texts:
		if text.to_lower() in _deck.subject.to_lower():
			return true
	
	# Search on aliases
	for text in texts:
		for alias in _deck.aliases:
			var words = alias.to_lower().split(" ")
			
			for word in words:
				if text.to_lower() in word:
					return true
		
	return false


func change_to_config_scene() -> void:
	ConfigDeck.deck = _deck
	
	get_tree().change_scene_to_packed(ConfigScene)


func change_to_play_scene() -> void:
	PlayDeck.deck = _deck
	
	get_tree().change_scene_to_packed(PlayScene)
	
