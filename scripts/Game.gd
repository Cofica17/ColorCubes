extends Control
tool

var GridRectScene = load("res://scenes/ColoredGridRect.tscn")
var MoveableGridRectScene = load("res://scenes/MoveableGridRect.tscn")

onready var grid:Grid = get_node("Grid")


func _ready():
	Global.current_theme = BoardThemes.desert
	_generate_puzzle()
	Global.connect("grid_rect_switched", self, "_check_solution")


func _check_solution() -> void:
	pass #TBA


func _add_connection_rects(num_of_different_connection_rects:int, num_of_pairs:int) -> void:
	if num_of_different_connection_rects > Global.total_number_of_diff_connection_rects:
		num_of_different_connection_rects = Global.total_number_of_diff_connection_rects
	
	var excluding = [grid.get_moveable_rect_id()]
	var excluding_icons = []
	for i in num_of_different_connection_rects:
		var rnd_rect_icon = Utils.generate_random_int_excluding(0, Global.total_number_of_diff_connection_rects - 1, excluding_icons)
		
		var used_colors = []
		
		var counter:int = 0
		
		while counter < num_of_pairs:
			var rnd_rect_id = Utils.generate_random_int_excluding(0, grid.total_num_of_grid_rects - 1, excluding)
			var grid_rect:ColoredGridRect = grid.grid_container.get_child(rnd_rect_id)
			
			if grid_rect.get_rect_color() in used_colors:
				continue
			
			var rnd_tex = Global.current_theme.connection_rects_icons[rnd_rect_icon]
			grid_rect.set_texture(rnd_tex)
			excluding.append(rnd_rect_id)
			used_colors.append(grid_rect.color)
			counter += 1
		
		excluding_icons.append(rnd_rect_icon)


func _generate_puzzle() -> void:
	grid.clear_grid_container()
	
	var idx = 0
	
	var mgr_idx =  Global.RNG.randi() % (grid.rows * grid.columns)
	
	for i in grid.rows:
		for j in grid.columns:
			var grid_rect:GridRect = GridRectScene.instance()
			
			var is_grid_rect = true
			
			if mgr_idx == idx:
				grid_rect = MoveableGridRectScene.instance()
				is_grid_rect = false
			else:
				grid_rect = GridRectScene.instance()
			
			grid.add_grid_rect(grid_rect)
			grid_rect.column = j
			grid_rect.row = i
			grid_rect.id = idx
			idx += 1
			
			if is_grid_rect:
				var random_color_idx = Global.RNG.randi() % Global.current_theme.total_number_of_possible_colors
				grid_rect.set_color(Global.current_theme.colors[random_color_idx])
	
	grid.call_deferred("adjust_board_size")
