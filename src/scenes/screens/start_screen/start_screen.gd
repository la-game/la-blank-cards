extends MarginContainer


func change_to_play_screen() -> void:
	get_tree().change_scene_to_packed(load("res://src/scenes/screens/play_screen/play_screen.tscn"))


func change_to_decks_screen() -> void:
	get_tree().change_scene_to_packed(load("res://src/scenes/screens/decks_screen/decks_screen.tscn"))


func change_to_options_screen() -> void:
	get_tree().change_scene_to_packed(load("res://src/scenes/screens/options_screen/options_screen.tscn"))


func exit_game() -> void:
	get_tree().quit()
