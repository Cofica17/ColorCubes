extends Node

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

enum DIRECTION {
	LEFT,
	RIGHT,
	DOWN,
	UP
}

var game_data = {}

func _ready():
	load_game()

func load_game():
	var file = File.new()
	var err = file.open("user://game_data.json", File.READ_WRITE)
	if err == OK:
		var file_data = file.get_as_text()
		game_data = JSON.parse(file_data).result
		print(game_data)
		file.close()
	else:
		game_data = {
			Levels.PACKS.CLASSIC: default_pack_dict()
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
	game_data[str(Puzzle.pack)][str(Puzzle.difficulty)].append(Puzzle.level)
	save_game()

func get_levels_array_from_game_data():
	return game_data[str(Puzzle.pack)][str(Puzzle.difficulty)]

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
