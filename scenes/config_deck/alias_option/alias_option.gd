extends MarginContainer


signal updated(index: int, new_text: String)

signal removed(index: int)

var _index: int

var _alias: String

@onready var line_edit = $Container/LineEdit


func _ready() -> void:
	line_edit.text = _alias


func init(index: int, alias: String):
	_index = index
	_alias = alias
	return self


func update_text(new_text: String) -> void:
	updated.emit(_index, new_text)


func remove() -> void:
	removed.emit(_index)
