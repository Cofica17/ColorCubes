extends Node

signal switch_grid_rects(moveable_grid_rect, colored_grid_rect)
signal cancel_switch_grid_rects()

var white:Color = "#ccffffff"
var black:Color = "#000000"
var yellow:Color = "#b32e263d" #dark blue almost
var blue:Color = "#b3ffe3b5" # light yellow
var green:Color = "#b3824254" # reddish
var red:Color = "#b3d67a66" # shit color

var colors := {
	0 : red,
	1 : yellow,
	2 : blue,
	3 : green,
}

var total_number_of_possible_colors := 4

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
