extends MarginContainer


@export var window_mode_option: OptionButton

@export var resolution_size_option: OptionButton


func _ready() -> void:
	match UserConfig.window_mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_option.selected = 0
		DisplayServer.WINDOW_MODE_WINDOWED:
			window_mode_option.selected = 1
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			window_mode_option.selected = 2
	
	match UserConfig.resolution_size:
		Vector2i(1900, 1200):
			resolution_size_option.selected = 0
		Vector2i(1900, 1080):
			resolution_size_option.selected = 1
		Vector2i(1680, 1050):
			resolution_size_option.selected = 2
		Vector2i(1600, 1200):
			resolution_size_option.selected = 3
		Vector2i(1600, 900):
			resolution_size_option.selected = 4


func change_to_start_screen() -> void:
	get_tree().change_scene_to_packed(
		load("res://src/scenes/screens/start_screen/start_screen.tscn")
	)


func change_window_mode(index: int) -> void:
	match index:
		0:
			UserConfig.window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		1:
			UserConfig.window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		2:
			UserConfig.window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN


func change_resolution_size(index: int) -> void:
	match index:
		0:
			UserConfig.resolution_size = Vector2i(1900, 1200)
		1:
			UserConfig.resolution_size = Vector2i(1900, 1080)
		2:
			UserConfig.resolution_size = Vector2i(1680, 1050)
		3:
			UserConfig.resolution_size = Vector2i(1600, 1200)
		4:
			UserConfig.resolution_size = Vector2i(1600, 900)
