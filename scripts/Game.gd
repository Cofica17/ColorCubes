extends Control
tool

onready var grid:Grid = get_node("Grid")


func _ready():
	Global.current_theme = BoardThemes.desert
	Global.connect("grid_rect_switched", self, "_check_solution")


func _check_solution() -> void:
	if CheckSolution.is_grid_solved(grid):
		var popup = PopupDialog.new()
		popup.popup_exclusive = true
		popup.show()


func _generate_puzzle(puzzle:Dictionary) -> void:
	grid.clear_grid_container()
	
	LevelGenerator.generate_puzzle(grid, Levels.PACKS.CLASSIC, puzzle)
	
	grid.call_deferred("adjust_board_size")


func _on_LevelsCreator_levels_generated():
	var file = File.new()
	file.open("user://classic_dfl_1.json", File.READ)
	var content:Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	_generate_puzzle(content["1"])


#func _add_connection_rects(num_of_different_connection_rects:int, num_of_pairs:int) -> void:
#	if num_of_different_connection_rects > Global.total_number_of_diff_connection_rects:
#		num_of_different_connection_rects = Global.total_number_of_diff_connection_rects
#
#	var excluding = [grid.get_moveable_rect_id()]
#	var excluding_icons = []
#	for i in num_of_different_connection_rects:
#		var rnd_rect_icon = Utils.generate_random_int_excluding(0, Global.total_number_of_diff_connection_rects - 1, excluding_icons)
#
#		var used_colors = []
#
#		var counter:int = 0
#
#		while counter < num_of_pairs:
#			var rnd_rect_id = Utils.generate_random_int_excluding(0, grid.total_num_of_grid_rects - 1, excluding)
#			var grid_rect:ColoredGridRect = grid.grid_container.get_child(rnd_rect_id)
#
#			if grid_rect.get_rect_color() in used_colors:
#				continue
#
#			var rnd_tex = Global.current_theme.connection_rects_icons[rnd_rect_icon]
#			grid_rect.set_texture(rnd_tex)
#			excluding.append(rnd_rect_id)
#			used_colors.append(grid_rect.color)
#			counter += 1
#
#		excluding_icons.append(rnd_rect_icon)

