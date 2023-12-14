extends Control


func change_to_start_screen() -> void:
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/start_screen/start_screen.tscn")
	)


func change_to_deck_selection_screen() -> void:
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/deck_selection_screen/deck_selection_screen.tscn")
	)
