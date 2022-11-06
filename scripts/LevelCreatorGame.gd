extends Control
tool

onready var grid:Grid = get_node("Grid")
onready var pack_option_btn:OptionButton = $LevelsCreator/Pack
onready var difficulty_option_btn:OptionButton = $LevelsCreator/Difficulty
onready var levels_creator = $LevelsCreator

const root_folder = "res://levels_jsons/"

var content:Dictionary
var current_level = 1 


func _ready():
	Global.current_theme = BoardThemes.classic
	Global.connect("grid_rect_switched", self, "_check_solution")
	pack_option_btn.connect("item_selected", levels_creator , "on_pack_selected")
	fill_option_buttons()

func fill_option_buttons():
	for pack in Levels.PACKS:
		pack_option_btn.add_item(Levels.get_pack_name(Levels.PACKS[pack]))
	
	for difficulty in Levels.DIFFICULTY:
		difficulty_option_btn.add_item(Levels.get_difficulty_name(Levels.DIFFICULTY[difficulty]))

func _check_solution() -> void:
	if CheckSolution.is_grid_solved(grid):
		$AcceptDialog.popup()

func _generate_puzzle(puzzle:Dictionary) -> void:
	Puzzle.puzzle = puzzle
	grid.clear_grid_container()
	LevelGenerator.generate_puzzle(grid, Levels.PACKS.CLASSIC, puzzle)
	grid.call_deferred("adjust_board_size")

func _on_LevelsCreator_levels_generated():
	content = levels_creator.current_generated_levels
	_generate_puzzle(content[1])
	Puzzle.content = content

func _read_classic_levels_file(pack, difficulty) -> Dictionary:
	var file = File.new()
	file.open(root_folder + "%s" % Levels.get_file_name(pack, difficulty), File.READ)
	var content:Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	return content

func _on_LevelNum_text_changed(new_text):
	if new_text in content:
		_generate_puzzle(content[new_text])

func _on_Previous_pressed():
	current_level -= 1
	
	if current_level < 1:
		current_level = 1
	
	_generate_puzzle(content[current_level])

func _on_next_pressed():
	current_level += 1
	
	if current_level > 100:
		current_level = 100
	
	_generate_puzzle(content[current_level])
