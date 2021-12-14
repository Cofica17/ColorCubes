extends Control
tool

onready var grid:Grid = get_node("Grid")

var content:Dictionary
var current_level = 1 


func _ready():
	Global.current_theme = BoardThemes.desert
	#Global.connect("grid_rect_switched", self, "_check_solution")


func _check_solution() -> void:
	if CheckSolution.is_grid_solved(grid):
		$AcceptDialog.popup()


func _generate_puzzle(puzzle:Dictionary) -> void:
	grid.clear_grid_container()
	
	LevelGenerator.generate_puzzle(grid, Levels.PACKS.CLASSIC, puzzle)
	
	grid.call_deferred("adjust_board_size")


func _on_LevelsCreator_levels_generated():
	content = _read_classic_levels_file()
	_generate_puzzle(content["1"])


func _read_classic_levels_file() -> Dictionary:
	var file = File.new()
	file.open("user://classic_dfl_1.json", File.READ)
	var content:Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	return content


func _on_LevelNum_text_changed(new_text):
	if new_text in content:
		_generate_puzzle(content[new_text])


func _on_NExt_pressed():
	current_level += 1
	
	if current_level > 100:
		current_level = 100
	
	_generate_puzzle(content[str(current_level)])


func _on_Previous_pressed():
	current_level -= 1
	
	if current_level < 1:
		current_level = 1
	
	_generate_puzzle(content[str(current_level)])
