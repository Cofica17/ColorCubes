extends Control

onready var grid = $ScrollContainer/GridContainer


func _ready():
	Global.connect("level_chosen", self, "_on_new_level_chosen")


func _on_new_level_chosen(new_level) -> void:
	_set_solved_and_unsolved_colors()
	grid.get_child(new_level - 1).set_color(Puzzle.chosen_color)
	
	if visible:
		visible = !visible


func _set_solved_and_unsolved_colors() -> void:
	for c in grid.get_children():
		c.set_color(Puzzle.unsolved_color)


func fill_levels(max_level) -> void:
	for i in max_level:
		var level_grid = load(Scenes.LevelGridRect).instance()
		grid.add_child(level_grid)
		level_grid.set_level(i+1)
