extends Node

var music = [
	load("res://assets/sounds/Colorful-Flowers(chosic.com).mp3"),
	load("res://assets/sounds/Memories-of-Spring(chosic.com).mp3"),
	load("res://assets/sounds/Morning-Station(chosic.com).mp3"),
	load("res://assets/sounds/Way-Home(chosic.com).mp3"),
	load("res://assets/sounds/When-I-Was-A-Boy(chosic.com).mp3")
	]

var RNG = RandomNumberGenerator.new()
var current_seed

var level_select_scrolling = false

signal switch_grid_rects(colored_grid_rect)
signal cancel_switch_grid_rects()
signal puzzle_generated()
signal grid_rect_switched()
signal level_chosen(new_level)
signal difficulty_changed(idx)

var white:Color = "#ffffff"
var black:Color = "#000000"

var current_theme : Dictionary
var total_number_of_diff_connection_rects := 2
var total_number_of_possible_colors := 8

var colored_grid_rect
var switch_grid_rects_initiated:bool = false

var one_touch_move = true

var audio_position = 0.0
var cur_song = 0

enum DIRECTION {
	LEFT,
	RIGHT,
	DOWN,
	UP
}

var game_data = {}

func _ready():
	RNG.randomize()
	cur_song = music[RNG.randi_range(0, music.size()-1)]
	load_game()
	Puzzle.change_difficulty(Global.game_data.difficulty)
	emit_signal("level_chosen", game_data.level)
	connect("level_chosen", self, "on_level_chosen")

func on_level_chosen(lvl, v=false):
	game_data.level = lvl
	save_game()

func set_next_song():
	var idx = music.find(cur_song)
	idx += 1
	if idx >= music.size():
		idx = 0
	cur_song = music[idx]

func load_game():
	var file = File.new()
	var err = file.open("user://game_data.json", File.READ_WRITE)
	if err == OK:
		var file_data = file.get_as_text()
		game_data = JSON.parse(file_data).result
		file.close()
	else:
		game_data = {
			Levels.PACKS.CLASSIC: default_pack_dict(),
			"difficulty" : 0,
			"level" : 1,
			"tutorial_completed" : false
		}
		save_game()

func save_game():
	var new_file = File.new()
	new_file.open("user://game_data.json", File.WRITE)
	new_file.store_string(to_json(game_data))
	new_file.close()

func default_pack_dict():
	return {
			Levels.DIFFICULTY.LEVEL_1 : [],
			Levels.DIFFICULTY.LEVEL_2 : [],
			Levels.DIFFICULTY.LEVEL_3 : []
		}

func level_finished():
	if not Puzzle.level in game_data.values()[Puzzle.pack].values()[Puzzle.difficulty]:
		game_data.values()[Puzzle.pack].values()[Puzzle.difficulty].append(Puzzle.level)
	save_game()

func get_levels_array_from_game_data():
	if game_data.empty():
		return []
	#print(game_data)
	return game_data.values()[Puzzle.pack].values()[Puzzle.difficulty]

func initiate_switch_grid_rects() -> void:
	switch_grid_rects_initiated = true

func finish_switch_grid_rects(grid_rect:GridRect) -> void:
	if not switch_grid_rects_initiated and not one_touch_move:
		cancel_switch_grid_rects()
		return
	
	colored_grid_rect = grid_rect
	emit_signal("switch_grid_rects", colored_grid_rect)
	cancel_switch_grid_rects()

func cancel_switch_grid_rects() -> void:
	switch_grid_rects_initiated = false
	colored_grid_rect = null
	emit_signal("cancel_switch_grid_rects")
