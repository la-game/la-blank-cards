extends Node


const PATH = "user://config.ini"

var config: ConfigFile = load_config()

################ Video ################

var window_mode := DisplayServer.WINDOW_MODE_FULLSCREEN:
	set(v):
		window_mode = v
		DisplayServer.window_set_mode(v)
		update_config("video", "window_mode", v)


# TODO: Fix to actually change the resolution and not just the window size.
var resolution_size := Vector2i(1920, 1080):
	set(v):
		# At startup the resolution_size will not be the correct window size,
		# so we need to get the current window size by method.
		var window_size := DisplayServer.window_get_size()
		var window_position := DisplayServer.window_get_position()
		resolution_size = v
		DisplayServer.window_set_size(v)
		DisplayServer.window_set_position.call_deferred(
			window_position + (window_size - v) / 2
		)
		update_config("video", "resolution_size", v)


func _ready() -> void:
	load_config()
	activate_config()


func load_config() -> ConfigFile:
	var c = ConfigFile.new()
	
	# Create an empty config if doesn't exist.
	if not FileAccess.file_exists(PATH):
		c.save(PATH)
	
	c.load(PATH)
	
	return c


func activate_config() -> void:
	window_mode = config.get_value("video", "window_mode", window_mode)
	resolution_size = config.get_value("video", "resolution_size", resolution_size)


func update_config(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)
	config.save(PATH)
