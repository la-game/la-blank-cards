extends Node


signal decks_updated

const DEFAULT_TEMPLATES: String = "res://templates"

const USER_TEMPLATES: String = "user://templates"

const USER_TEMPLATES_ZIP: String = "user://templates.zip"

var decks: Array[Deck]


func _ready() -> void:
	var success: bool = _load_templates(USER_TEMPLATES)
	
	if not success:
		_load_templates(DEFAULT_TEMPLATES)
	
	tree_exiting.connect(backup_decks)


## Backup decks into user storage.
## [br]This operation is NOT safe, user could lost it decks if it fail to save decks.
## [br]I should create a temporary copy or something but I'm lazy.
func backup_decks() -> void:
	var success: bool = _remove_old_decks()
	
	if not success:
		return
	
	_save_current_decks()
	_zip_decks()


func _load_templates(path: String) -> bool:
	var dir = DirAccess.open(path)
	
	if not dir:
		return false
	
	for file in dir.get_files():
		var filename = "%s/%s" % [path, file]
		var deck = load(filename)
		
		if not deck is Deck:
			printerr("File is not a deck. File name: ", filename)
			continue
		
		decks.append(deck)
	
	if decks.is_empty():
		return false
	
	return true


func _zip_decks() -> bool:
	DirAccess.remove_absolute(USER_TEMPLATES_ZIP)
	
	var packer = ZIPPacker.new()
	var error = packer.open(USER_TEMPLATES_ZIP)
	
	if error:
		printerr("Fail to create zip file to store the templates. Error: ", error)
		return false
	
	var dir = DirAccess.open(USER_TEMPLATES)
	
	if not dir:
		printerr("Fail to open template directory. Error: ", DirAccess.get_open_error())
		return false
	
	for filename in dir.get_files():
		var filepath = "%s/%s" % [USER_TEMPLATES, filename]
		var file = FileAccess.open(filepath, FileAccess.READ)
		
		if not file:
			printerr("Fail to read deck. File name: ", filename)
			return false
		
		packer.start_file(filename)
		packer.write_file(file.get_as_text().to_utf8_buffer())
		packer.close_file()
	
	packer.close()
	
	return true


func _remove_old_decks() -> bool:
	var error = DirAccess.make_dir_absolute(USER_TEMPLATES)
	
	if not error in [OK, ERR_ALREADY_EXISTS]:
		printerr("Fail to create template directory. Error code: ", error)
		return false
	
	var dir = DirAccess.open(USER_TEMPLATES)
	
	if not dir:
		printerr("Fail to open template directory. Error: ", DirAccess.get_open_error())
		return false
	
	for file in dir.get_files():
		if dir.remove("%s/%s" % [USER_TEMPLATES, file]):
			printerr("Fail to remove an old deck. File name: ", file)
			return false
	
	return true


func _save_current_decks() -> void:
	for i in decks.size():
		var deck = decks[i]
		var filename = "%s/%s.tres" % [USER_TEMPLATES, i]
		var error = ResourceSaver.save(deck, filename)
		
		if error:
			printerr("Fail to save deck. Error: ", error)
