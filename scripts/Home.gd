extends Control
tool

onready var grid:Grid = $VBoxContainer/HBoxContainer2/Grid
onready var previous:TextureButton = $VBoxContainer/HBoxContainer2/Previous
onready var next:TextureButton = $VBoxContainer/HBoxContainer2/Next
onready var puzzle_level:Label = $VBoxContainer/VBoxContainer/HBoxContainer/PuzzleLevel
onready var play:Button = $VBoxContainer/Play
onready var grid_btn:Button = $VBoxContainer/HBoxContainer2/Grid/GridButton
onready var level_select:Control = $LevelSelect
onready var difficulty_label:Label = $VBoxContainer/VBoxContainer/HBoxContainer/DifficultyLabel
onready var audio = $AudioStreamPlayer

var current_level = 1 
var max_levels = 100

func _ready():
	audio.stream = Global.cur_song
	audio.play(Global.audio_position)
	previous.connect("pressed", self, "_on_previous_pressed")
	next.connect("pressed", self, "_on_next_pressed")
	play.connect("pressed", self, "_on_play_pressed")
	#grid_btn.connect("pressed", self, "_on_grid_btn_pressed")
	Global.connect("level_chosen", self, "_on_level_chosen")
	Puzzle.connect("difficulty_changed", self, "_on_difficulty_changed")
	#difficulty_btn.connect("pressed", self, "_on_difficulty_btn_pressed")
	
	Global.current_theme = BoardThemes.classic
	_set_puzzle_content()
	fill_level_select()
	difficulty_label.text = Levels.difficulty_level_names[Puzzle.difficulty].to_upper()
	
	Global.emit_signal("level_chosen", Puzzle.level)

func _on_difficulty_changed() -> void:
	difficulty_label.text = Levels.get_current_difficulty()
	_set_puzzle_content()
	Global.emit_signal("level_chosen", 1 , true)

func _on_level_chosen(new_level:int, because_of_difficulty_change=false) -> void:
	current_level = new_level
	_set_puzzle_level() 
	_generate_puzzle(Puzzle.content[str(current_level)])

func fill_level_select() -> void:
	level_select.fill_levels(max_levels)

func _exit_level_select() -> void:
	level_select.hide()

func _on_grid_btn_pressed() -> void:
	level_select.show()

func _on_play_pressed() -> void:
	Puzzle.level = current_level
	Global.audio_position = audio.get_playback_position()
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

func _set_puzzle_content() -> void:
	var file = File.new()
	var file_name = Levels.get_file_name(Puzzle.pack, Puzzle.difficulty)
	file.open("res://levels_jsons/" + file_name, File.READ)
	var content:Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	Puzzle.content = content

func _on_LevelSelectBtn_pressed():
	level_select.show()

func _on_AudioStreamPlayer_finished():
	print("heloo")
	Global.set_next_song()
	audio.stream = Global.cur_song
	audio.play()

func _process(delta):
	if audio.get_playback_position() >= audio.stream.get_length() * 0.99:
		audio.emit_signal("finished")

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
