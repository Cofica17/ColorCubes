extends Node

func is_grid_solved(grid:Grid) -> bool:
	if not _all_colors_connected(grid):
		return false
	
	return true


func _all_colors_connected(grid:Grid) -> bool:
	for i in Puzzle.content.total_colors:
		var current_color = Color(Global.current_theme.colors[i])
		
		var first_gr
		
		for grid_rect in grid.grid_container.get_children():
			if grid_rect is MoveableGridRect:
				continue
			
			if not first_gr and grid_rect.color == current_color:
				first_gr = grid_rect
				var all_connected = _are_grid_rects_connected(grid, first_gr)
				
				if not all_connected:
					return false
				
				break
	
	return true


func _are_grid_rects_connected(grid:Grid, first_gr:GridRect) -> bool:
	var connected_rects:Array = [first_gr]
	
	var connected_increased = true
	
	while connected_increased:
		var previous_connected_rects_size = connected_rects.size()
		
		for grid_rect in grid.grid_container.get_children():
			if grid_rect is MoveableGridRect:
				continue
			
			if grid_rect.column > 0:
				var gr = grid.grid_container.get_child(grid_rect.id - 1)
				
				if not gr is MoveableGridRect and gr.color == grid_rect.color:
					_check_are_connected(connected_rects, grid_rect, gr)
				
			if grid_rect.column < grid.columns - 1:
				var gr = grid.grid_container.get_child(grid_rect.id + 1)
				
				if not gr is MoveableGridRect and gr.color == grid_rect.color:
					_check_are_connected(connected_rects, grid_rect, gr)
			
			if grid_rect.row > 0:
				var gr = grid.grid_container.get_child(grid_rect.id - grid.columns)
				
				if not gr is MoveableGridRect and gr.color == grid_rect.color:
					_check_are_connected(connected_rects, grid_rect, gr)
			
			if grid_rect.row < grid.rows - 1:
				var gr = grid.grid_container.get_child(grid_rect.id + grid.columns)
				
				if not gr is MoveableGridRect and gr.color == grid_rect.color:
					_check_are_connected(connected_rects, grid_rect, gr)
		
		if previous_connected_rects_size == connected_rects.size():
			connected_increased = false
	
	return _get_same_gr_color_sum(grid, first_gr.color) == connected_rects.size()


func _get_same_gr_color_sum(grid:Grid, color:Color) -> int:
	var sum = 0
	for c in grid.grid_container.get_children():
		if c.color == color:
			sum += 1
	return sum


func _check_are_connected(connected_rects:Array, grid_rect:GridRect, gr:GridRect) -> void:
	if grid_rect in connected_rects and not connected_rects.has(gr):
		connected_rects.append(gr)
	elif not connected_rects.has(grid_rect) and gr in connected_rects:
		connected_rects.append(grid_rect)












