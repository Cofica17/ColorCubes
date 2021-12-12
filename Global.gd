extends Node

signal switch_grid_rects(moveable_grid_rect, colored_grid_rect)
signal cancel_switch_grid_rects()

var white:Color = "#ccffffff"
var black:Color = "#000000"

var current_theme : Dictionary
var total_number_of_diff_connection_rects := 2

var moveable_grid_rect
var colored_grid_rect
var switch_grid_rects_initiated:bool = false

enum DIRECTION {
	LEFT,
	RIGHT,
	DOWN,
	UP
}


func initiate_switch_grid_rects(grid_rect:GridRect) -> void:
	switch_grid_rects_initiated = true
	moveable_grid_rect = grid_rect


func finish_switch_grid_rects(grid_rect:GridRect) -> void:
	if not switch_grid_rects_initiated:
		cancel_switch_grid_rects()
		return
	
	colored_grid_rect = grid_rect
	emit_signal("switch_grid_rects", moveable_grid_rect, colored_grid_rect)
	cancel_switch_grid_rects()


func cancel_switch_grid_rects() -> void:
	switch_grid_rects_initiated = false
	moveable_grid_rect = null
	colored_grid_rect = null
	emit_signal("cancel_switch_grid_rects")
