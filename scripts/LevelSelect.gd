extends Control

signal close_level_select

onready var grid = $ScrollContainer/GridContainer
onready var choose_difficulty_popup = $DifficultyBG/ChooseDifficultyPopup
onready var difficulty_label = $VBoxContainer/HBoxContainer/DifficultyLabel
onready var difficulty_bg = $DifficultyBG

func _ready():
	Global.connect("level_chosen", self, "_on_new_level_chosen")
	Puzzle.connect("difficulty_changed", self, "_on_difficulty_changed")
	difficulty_label.text = Levels.get_current_difficulty()

func _on_new_level_chosen(new_level, because_of_difficulty_change=false) -> void:
	_set_solved_and_unsolved_colors()
	grid.get_child(new_level - 1).set_color(Puzzle.chosen_color)
	if not because_of_difficulty_change:
		hide()

func _set_solved_and_unsolved_colors() -> void:
	var i = 1
	var levels_cleared = Global.get_levels_array_from_game_data()
	for c in grid.get_children():
		if i in levels_cleared:
			c.set_color(Puzzle.solved_color)
		else:
			c.set_color(Puzzle.unsolved_color)
		i += 1

func fill_levels(max_level) -> void:
	for i in max_level:
		var level_grid = load(Scenes.LevelGridRect).instance()
		grid.add_child(level_grid)
		level_grid.set_level(i+1)

func _on_ChangeBtn_pressed():
	difficulty_bg.show()

func _on_difficulty_changed():
	difficulty_bg.hide()
	difficulty_label.text = Levels.get_current_difficulty()

func _on_CloseBtn_pressed():
	hide()


func _on_ChooseDifficultyBGBtn_pressed():
	difficulty_bg.hide()
