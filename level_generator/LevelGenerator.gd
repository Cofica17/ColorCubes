extends Node

var GridRectScene = load("res://scenes/ColoredGridRect.tscn")
var MoveableGridRectScene = load("res://scenes/MoveableGridRect.tscn")

func generate_puzzle(grid:Grid, pack:int, puzzle:Dictionary) -> void:
	match pack:
		Levels.PACKS.CLASSIC:
			generate_classic_puzzle(grid, puzzle)


func generate_classic_puzzle(grid:Grid, puzzle:Dictionary) -> void:
	var idx = 0
	
	var board_side_size:int = sqrt(puzzle.board_size)
	var board_size:int = puzzle.board_size
	grid.rows = board_side_size
	grid.columns = board_side_size
	
	var column = 0
	var row = 0
	
	for grid_rect_data in puzzle.grid_rects:
		var grid_rect:GridRect = GridRectScene.instance()
		
		if grid_rect_data.is_control:
			grid_rect = MoveableGridRectScene.instance()
		else:
			grid_rect = GridRectScene.instance()

		grid.add_grid_rect(grid_rect)
		grid_rect.column = column
		grid_rect.row = row
		grid_rect.id = idx
		idx += 1
		
		if not grid_rect_data.is_control:
			grid_rect.set_color(Global.current_theme.colors[int(grid_rect_data.color)])
		
		if (board_size % (column + 1)) == 0 and not column == 0:
			row += 1
			column = 0
		else:
			column += 1
			print(column)
