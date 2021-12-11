extends Control

onready var grid:Grid = get_node("Grid")


func _ready():
	_generate_puzzle()
	randomize()
	$DEBUG_TBD/Button.connect("pressed", self, "_check_solution")
	$DEBUG_TBD/GeneratePuzzle.connect("pressed", self, "_generate_puzzle")


func _check_solution() -> void:
	var check_solution = CheckSolution.new()
	if check_solution.check_solution(grid):
		$DEBUG_TBD/Label.text = "rjeseno je miliiii"
	else:
		$DEBUG_TBD/Label.text = "Nije rjeseno kretenu"


func _generate_puzzle() -> void:
	grid.clear_grid_container()
	
	var GridRectScene = load("res://scenes/GridRect.tscn")
	var MoveableGridRectScene = load("res://scenes/MoveableGridRect.tscn")
	
	var idx = 0
	
	var mgr_idx =  randi() % (grid.rows * grid.columns)
	
	for i in grid.rows:
		for j in grid.columns:
			var grid_rect:GridRect = GridRectScene.instance()
			
			var is_grid_rect = true
			
			if mgr_idx == idx:
				grid_rect = MoveableGridRectScene.instance()
				is_grid_rect = false
			else:
				grid_rect = GridRectScene.instance()
			
			grid.add_grid_rect(grid_rect)
			grid_rect.column = j
			grid_rect.row = i
			grid_rect.id = idx
			idx += 1
			
			if is_grid_rect:
				var random_color_idx = randi() % Global.total_number_of_possible_colors
				grid_rect.set_color(Global.colors[random_color_idx])
