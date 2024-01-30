extends Node

var settings = {}
var enable_sfx_on_rect_move = true


func _ready():
	load_settings()

func load_settings():
	var file = File.new()
	var err = file.open("user://settings.json", File.READ_WRITE)
	if err == OK:
		var file_data = file.get_as_text()
		settings = JSON.parse(file_data).result
		file.close()
		for setting in settings:
			set(setting, settings[setting])
	else:
		settings = {
			"enable_sfx_on_rect_move" : true
		}
		save_settings()

func save_settings():
	settings = {
			"enable_sfx_on_rect_move" : enable_sfx_on_rect_move
	}
	print(settings)
	var new_file = File.new()
	new_file.open("user://settings.json", File.WRITE)
	new_file.store_string(to_json(settings))
	new_file.close()
