extends Panel
class_name Grid
tool

export var columns:int = 0 setget set_columns
export var rows:int = 0 setget set_rows

var total_num_of_grid_rects := columns * rows

onready var grid_container:GridContainer = get_node("GridContainer")


func _ready() -> void:
	Global.connect("switch_grid_rects", self, "_on_switch_grid_rects")
	Global.connect("puzzle_generated", self, "_adjust_board_size")


func adjust_board_size() -> void:
	if rect_size.y > rect_size.x:
		rect_size.y = rect_size.x
	elif rect_size.x > rect_size.y:
		rect_size.x = rect_size.y


func get_moveable_rect_id():
	for c in grid_container.get_children():
		if c is MoveableGridRect:
			return c.id


#TODO: refactor if needed
func _on_switch_grid_rects(colored_grid_rect:ColoredGridRect) -> void:
	var moveable_grid_rect = grid_container.get_child(get_moveable_rect_id())
	
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
	_update_columns_and_rows_for_grid_rects()
	
	Global.emit_signal("grid_rect_switched")


func _update_columns_and_rows_for_grid_rects() -> void:
	var column = 0
	var row = 0
	
	var board_size = columns * rows
	
	for grid_rect in grid_container.get_children():
		grid_rect.column = column
		grid_rect.row = row
		
		if column == columns - 1:
			row += 1
			column = 0
		else:
			column += 1


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
