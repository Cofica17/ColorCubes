extends Control
tool

onready var grid:Grid = get_node("Grid")
onready var previous:TextureButton = $Previous
onready var next:TextureButton = $Next
onready var puzzle_level:Label = $PuzzleLevel
onready var play:Button = $Play
onready var grid_btn:Button = $Grid/GridButton
onready var level_select:Control = $LevelSelect
onready var exit_level_select:Button = $ExitLevelSelect

var content:Dictionary
var current_level = 1 
var max_levels = 100


func _ready():
	previous.connect("pressed", self, "_on_previous_pressed")
	next.connect("pressed", self, "_on_next_pressed")
	play.connect("pressed", self, "_on_play_pressed")
	grid_btn.connect("pressed", self, "_on_grid_btn_pressed")
	Global.connect("level_chosen", self, "_on_level_chosen")
	exit_level_select.connect("pressed", self, "_exit_level_select")
	
	Global.current_theme = BoardThemes.classic
	content = _read_classic_levels_file()
	Puzzle.content = content
	fill_level_select()
	
	Global.emit_signal("level_chosen", Puzzle.level)


func _on_level_chosen(new_level:int) -> void:
	current_level = new_level
	_set_puzzle_level() 
	_generate_puzzle(content[str(current_level)])
	_exit_level_select()


func fill_level_select() -> void:
	level_select.fill_levels(max_levels)


func _exit_level_select() -> void:
	level_select.hide()
	exit_level_select.hide()


func _on_grid_btn_pressed() -> void:
	level_select.show()
	exit_level_select.show()


func _on_play_pressed() -> void:
	Puzzle.pack = Levels.PACKS.CLASSIC
	Puzzle.difficulty = Levels.DIFFICULTY.LEVEL_1
	Puzzle.level = current_level
	
	get_tree().change_scene(Scenes.GameScene)


func _on_previous_pressed() -> void:
	if current_level == 1:
		return
	
	Global.emit_signal("level_chosen", current_level - 1)


func _on_next_pressed() -> void:
	if current_level == max_levels:
		return
	
	Global.emit_signal("level_chosen", current_level + 1)


func _set_puzzle_level() -> void:
	puzzle_level.text = str(current_level) + "/" + str(max_levels)


func _generate_puzzle(puzzle:Dictionary) -> void:
	grid.clear_grid_container()
	
	LevelGenerator.generate_puzzle(grid, Levels.PACKS.CLASSIC, puzzle)
	
	grid.call_deferred("adjust_board_size")
	
	Puzzle.puzzle = puzzle


func _read_classic_levels_file() -> Dictionary:
	var file = File.new()
	file.open("user://classic_dfl_1.json", File.READ)
	var _content:Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	return _content


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
