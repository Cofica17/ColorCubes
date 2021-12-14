extends Node

func is_grid_solved(grid:Grid) -> bool:
	if not _all_colors_connected(grid):
		return false
	
	return true


func _all_colors_connected(grid:Grid) -> bool:
	for grid_rect in grid.grid_container.get_children():
		if grid_rect is MoveableGridRect:
			continue
		
		var color = grid_rect.get_rect_color()
		var id = grid_rect.id
		
		var left_grid_rect
		if grid_rect.column > 0:
			left_grid_rect = grid.grid_container.get_child(id-1)
		
		var right_grid_rect
		if grid_rect.column < grid.columns:
			right_grid_rect = grid.grid_container.get_child(id+1)
		
		var above_grid_rect
		if grid_rect.row > 0:
			above_grid_rect = grid.grid_container.get_child(id - grid.columns)
		
		var below_grid_rect
		if grid_rect.row < grid.rows:
			below_grid_rect = grid.grid_container.get_child(id + grid.columns)
		
		var connected = false
		
		if left_grid_rect and left_grid_rect.get_rect_color() == color:
			connected = true
		
		if right_grid_rect and right_grid_rect.get_rect_color() == color:
			connected = true
		
		if above_grid_rect and above_grid_rect.get_rect_color() == color:
			connected = true
		
		if below_grid_rect and below_grid_rect.get_rect_color() == color:
			connected = true
		
		if not connected:
			return false
	
	return true
