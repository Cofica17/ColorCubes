extends Control

onready var grid:Grid = get_node("Grid")

var added_connection_rects := false
var num_of_dif_con = 1
var num_of_p = 2

func _ready():
	Global.current_theme = BoardThemes.desert
	Global.RNG.randomize()
	var s = Global.RNG.randi() % 1000
	Global.RNG.seed = s
	Global.current_seed = s
	_generate_puzzle()
	$DEBUG_TBD/CurrentSeed.text = str(s)
	$DEBUG_TBD/Button.connect("pressed", self, "_add_connection_rects")
	$DEBUG_TBD/GeneratePuzzle.connect("pressed", self, "_generate_puzzle")


func _add_connection_rects(num_of_different_connection_rects:int = num_of_dif_con, num_of_pairs:int= num_of_p) -> void:
	if added_connection_rects:
		return
	else:
		added_connection_rects = true

		if num_of_different_connection_rects > Global.total_number_of_diff_connection_rects:
			num_of_different_connection_rects = Global.total_number_of_diff_connection_rects
	
	var excluding = [_get_moveable_rect_id()]
	var excluding_icons = []
	for i in num_of_different_connection_rects:
		var rnd_rect_icon = Utils.generate_random_int_excluding(0, Global.total_number_of_diff_connection_rects - 1, excluding_icons)
		
		var used_colors = []
		
		var counter:int = 0
		
		while counter < num_of_pairs:
			var rnd_rect_id = Utils.generate_random_int_excluding(0, grid.total_num_of_grid_rects - 1, excluding)
			var grid_rect:ColoredGridRect = grid.grid_container.get_child(rnd_rect_id)
			
			if grid_rect.get_rect_color() in used_colors:
				continue
			
			var rnd_tex = Global.current_theme.connection_rects_icons[rnd_rect_icon]
			grid_rect.set_texture(rnd_tex)
			excluding.append(rnd_rect_id)
			used_colors.append(grid_rect.color)
			counter += 1
		
		excluding_icons.append(rnd_rect_icon)


func _get_moveable_rect_id():
	for c in grid.grid_container.get_children():
		if c is MoveableGridRect:
			return c.id


func _generate_puzzle() -> void:
	var el_text = $DEBUG_TBD/LineEdit.text
	if not el_text.empty():
		var s = int(el_text)
		Global.RNG.seed = s
	
	added_connection_rects = false
	
	grid.clear_grid_container()
	
	var GridRectScene = load("res://scenes/ColoredGridRect.tscn")
	var MoveableGridRectScene = load("res://scenes/MoveableGridRect.tscn")
	
	var idx = 0
	
	var mgr_idx =  Global.RNG.randi() % (grid.rows * grid.columns)
	
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
				var random_color_idx = Global.RNG.randi() % Global.current_theme.total_number_of_possible_colors
				grid_rect.set_color(Global.current_theme.colors[random_color_idx])


func _on_OptionButton_item_selected(index):
	num_of_dif_con = index + 1


func _on_OptionButton2_item_selected(index):
	num_of_p = index + 2
