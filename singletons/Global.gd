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
