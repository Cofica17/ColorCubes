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
onready var shop = $Shop
onready var audio = $AudioStreamPlayer

var time_elapsed = 0

func _ready():
	audio.stream = Global.cur_song
	audio.play(Global.audio_position)
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

func _process(delta):
	if audio.get_playback_position() >= audio.stream.get_length() * 0.99:
		audio.emit_signal("finished")

func _on_next_level_pressed() -> void:
	level_cleared_container.hide()
	Global.emit_signal("level_chosen", Puzzle.level + 1)
	time_elapsed = -1
	_update_time_elapsed()
	level.text = "Level " + str(Puzzle.level)
	$Timer.start()
	_generate_puzzle(Puzzle.content[str(Puzzle.level)])

func _on_home_pressed() -> void:
	Global.audio_position = audio.get_playback_position()
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

func _on_BgBtn_pressed():
	shop.hide()

func _on_ShopButton_pressed():
	shop.show()

func _on_AudioStreamPlayer_finished():
	Global.set_next_song()
	audio.stream = Global.cur_song
	audio.play()
