extends Control
tool

onready var grid:Grid = get_node("Grid")
onready var pack:Label = $VBoxContainer/Pack
onready var difficulty:Label = $VBoxContainer/Difficulty
onready var level:Label = $VBoxContainer/Level
onready var time_elapsed_lbl:Label = $VBoxContainer/TimeElapsed
onready var restart:TextureButton = $Restart
onready var home:TextureButton = $Home
onready var level_cleared_container:Control = $LevelClearedContainer
onready var lvl_solved_popup:Panel = $LevelClearedContainer/Popup

var time_elapsed = 0

func _ready():
	Global.connect("grid_rect_switched", self, "_check_solution")
	_generate_puzzle(Puzzle.content[str(Puzzle.level)])
	pack.text = Levels.pack_names[Puzzle.pack] + " Pack"
	difficulty.text = Levels.difficulty_level_names[Puzzle.difficulty]
	level.text = "Level " + str(Puzzle.level)
	$Timer.connect("timeout", self, "_update_time_elapsed")
	restart.connect("pressed", self, "_on_restart_pressed")
	home.connect("pressed", self, "_on_home_pressed")
	lvl_solved_popup.connect("next_level_pressed", self, "_on_next_level_pressed")
	lvl_solved_popup.connect("home_pressed", self, "_on_home_pressed")
	lvl_solved_popup.connect("restart_pressed", self, "_on_restart_pressed")

func _on_next_level_pressed() -> void:
	level_cleared_container.hide()
	Global.emit_signal("level_chosen", Puzzle.level + 1)
	time_elapsed = -1
	_update_time_elapsed()
	level.text = "Level " + str(Puzzle.level)
	$Timer.start()
	_generate_puzzle(Puzzle.content[str(Puzzle.level)])

func _on_home_pressed() -> void:
	get_tree().change_scene(Scenes.HomeScene)

func _on_restart_pressed() -> void:
	level_cleared_container.hide()
	time_elapsed = -1
	_update_time_elapsed()
	$Timer.start()
	_generate_puzzle(Puzzle.puzzle)

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
		yield(get_tree().create_timer(0.3), "timeout")
		level_cleared_container.show()
		$Timer.stop()
		
		if Puzzle.level == Puzzle.max_levels:
			$LevelClearedContainer/Popup/Next.hide()
		
		Global.level_finished()

func _generate_puzzle(puzzle:Dictionary) -> void:
	grid.clear_grid_container()
	LevelGenerator.generate_puzzle(grid, Puzzle.pack, puzzle)
	grid.call_deferred("adjust_board_size")

func save_game():
	return
	#	var file = File.new()
	#	file.open(score_file, File.WRITE)
	#	file.store_var(highscore)
	#	file.close()

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
