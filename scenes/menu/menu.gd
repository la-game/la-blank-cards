extends MarginContainer


const SubjectOptionScene: PackedScene = preload("res://scenes/menu/subject_option/subject_option.tscn")

@onready var options = $Container/LeftContainer/Container/Options

@onready var import_dialog = $Container/LeftContainer/Container/Container/Container/Import/FileDialog

@onready var export_dialog = $Container/LeftContainer/Container/Container/Container/Export/FileDialog

@onready var new_deck_window = $Container/LeftContainer/Container/Container/Container/Add/Window

@onready var new_deck_subject = $Container/LeftContainer/Container/Container/Container/Add/Window/Container/Container/Container/LineEdit


func _ready() -> void:
	reload_decks()


func reload_decks() -> void:
	for child in options.get_children():
		child.queue_free()
	
	for deck in Decks.decks:
		options.add_child(SubjectOptionScene.instantiate().init(deck))


func _refresh_options(new_text: String) -> void:
	var words: Array[String] = []
	
	for word in new_text.split(" "):
		if word:
			words.append(word)
	
	for option in options.get_children():
		if option is SubjectOption:
			option.visible = option.contains(words) if words else true


func _import_decks() -> void:
	import_dialog.popup_centered(Vector2(750, 400))
	
	var filepath = await import_dialog.file_selected
	var reader = ZIPReader.new()
	var error = reader.open(filepath)
	
	if error:
		printerr("Fail to read zip. Error: ", error)
		return
	
	for file in reader.get_files():
		var bytes = reader.read_file(file)
		var filename = "%s/%s.tres" % [Decks.USER_TEMPLATES, Decks.decks.size()]
		var tmp = FileAccess.open(filename, FileAccess.WRITE)
		
		tmp.store_buffer(bytes)
		tmp.close()
		
		var deck = load(filename)
		
		if deck:
			Decks.decks.append(deck)
	
	reload_decks()


func _export_decks() -> void:
	export_dialog.popup_centered(Vector2(750, 400))
	
	var filepath = await export_dialog.file_selected
	
	Decks.backup_decks()
	
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	var bytes = FileAccess.get_file_as_bytes(Decks.USER_TEMPLATES_ZIP)
	
	file.store_buffer(bytes)


func _open_new_deck_window() -> void:
	new_deck_window.popup_centered(Vector2(500, 75))


func _add_deck() -> void:
	var deck = Deck.new()
	
	deck.subject = new_deck_subject.text
	
	new_deck_subject.clear()
	new_deck_window.hide()
	Decks.decks.append(deck)
	
	reload_decks()
