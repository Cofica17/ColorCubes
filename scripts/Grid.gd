extends Panel
class_name Grid
tool

export var columns:int = 0 setget set_columns
export var rows:int = 0 setget set_rows

var total_num_of_grid_rects := columns * rows

onready var grid_container:GridContainer = get_node("GridContainer")


func _ready() -> void:
	Global.connect("switch_grid_rects", self, "_on_switch_grid_rects")


#TODO: refactor if needed
func _on_switch_grid_rects(moveable_grid_rect:MoveableGridRect, colored_grid_rect:ColoredGridRect) -> void:
	var dir
	
	if moveable_grid_rect.id == colored_grid_rect.id + 1:
		dir = Global.DIRECTION.LEFT
	elif moveable_grid_rect.id == colored_grid_rect.id - 1:
		dir = Global.DIRECTION.RIGHT
	elif moveable_grid_rect.id == colored_grid_rect.id - columns:
		dir = Global.DIRECTION.DOWN
	elif moveable_grid_rect.id == colored_grid_rect.id + columns:
		dir = Global.DIRECTION.UP
	
	if dir == null:
		Global.cancel_switch_grid_rects()
		return
	
	if dir == Global.DIRECTION.LEFT:
		grid_container.move_child(moveable_grid_rect, moveable_grid_rect.id - 1)
	
	if dir == Global.DIRECTION.RIGHT:
		grid_container.move_child(moveable_grid_rect, moveable_grid_rect.id + 1)
	
	if dir == Global.DIRECTION.UP:
		var other_grid_rect = grid_container.get_child(moveable_grid_rect.id - columns)
		grid_container.move_child(moveable_grid_rect, moveable_grid_rect.id - columns)
		grid_container.move_child(other_grid_rect, moveable_grid_rect.id)
	
	if dir == Global.DIRECTION.DOWN:
		var other_grid_rect = grid_container.get_child(moveable_grid_rect.id + columns)
		grid_container.move_child(moveable_grid_rect, moveable_grid_rect.id + columns)
		grid_container.move_child(other_grid_rect, moveable_grid_rect.id)
	
	_update_ids_for_grid_rects()


func _update_ids_for_grid_rects() -> void:
	var idx = 0
	for c in grid_container.get_children():
		c.id = idx
		idx += 1


func add_grid_rect(grid_rect:GridRect) -> void:
	grid_container.add_child(grid_rect)


func clear_grid_container() -> void:
	for c in grid_container.get_children():
		c.free()


func set_columns(v) -> void:
	if not $GridContainer:
		return
	
	columns = v
	$GridContainer.columns = columns
	total_num_of_grid_rects = columns * rows


func set_rows(v) -> void:
	rows = v
	total_num_of_grid_rects = columns * rows
