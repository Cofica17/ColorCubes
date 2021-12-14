extends Control
tool

onready var grid:Grid = get_node("Grid")
onready var pack:Label = $VBoxContainer/Pack
onready var difficulty:Label = $VBoxContainer/Difficulty
onready var level:Label = $VBoxContainer/Level
onready var time_elapsed_lbl:Label = $VBoxContainer/TimeElapsed
onready var restart:TextureButton = $Restart
onready var home:TextureButton = $Home

var time_elapsed = 0

func _ready():
	#Global.connect("grid_rect_switched", self, "_check_solution")
	_generate_puzzle(Puzzle.content)
	pack.text = Levels.pack_names[Puzzle.pack] + " Pack"
	difficulty.text = Levels.difficulty_level_names[Puzzle.difficulty]
	level.text = "Level " + str(Puzzle.level)
	$Timer.connect("timeout", self, "_update_time_elapsed")
	restart.connect("pressed", self, "_on_restart_pressed")
	home.connect("pressed", self, "_on_home_pressed")


func _on_home_pressed() -> void:
	get_tree().change_scene(Scenes.HomeScene)


func _on_restart_pressed() -> void:
	_generate_puzzle(Puzzle.content)


func _update_time_elapsed() -> void:
	time_elapsed += 1
	
	var minutes:int = time_elapsed / 60
	var seconds:int = time_elapsed % 60
	
	var minutes_str:String
	var seconds_str:String
	
	if minutes < 10:
		minutes_str = "0" + str(minutes)
	else:
		minutes_str = str(minutes)
	
	if seconds < 10:
		seconds_str = "0" + str(seconds)
	else:
		seconds_str = str(seconds)
	
	time_elapsed_lbl.text = minutes_str + ":" + seconds_str


func _check_solution() -> void:
	if CheckSolution.is_grid_solved(grid):
		$AcceptDialog.popup()


func _generate_puzzle(puzzle:Dictionary) -> void:
	grid.clear_grid_container()
	
	LevelGenerator.generate_puzzle(grid, Puzzle.pack, puzzle)
	
	grid.call_deferred("adjust_board_size")


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
