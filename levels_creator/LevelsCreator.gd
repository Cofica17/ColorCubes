extends Node2D

signal levels_generated

var root_folder = "res://levels_jsons/"
var current_pack = Levels.PACKS.CLASSIC
var current_difficulty = Levels.DIFFICULTY.LEVEL_1
var current_generated_levels

func _ready():
	randomize()

func on_pack_selected(item):
	current_pack = item

func on_difficulty_selected(item):
	current_difficulty = item

func generate_levels(pack, difficulty) -> void:
	var configuration = LevelsCreatorConfiguration.get_configuration(pack, difficulty)
	var generated_levels
	
	match pack:
		Levels.PACKS.CLASSIC:
			generated_levels = generate_classic_levels(configuration)
	
	if not generated_levels:
		return
	
	current_generated_levels = generated_levels

func generate_classic_levels(config_array:Array) -> Dictionary:
	var result := {}
	
	var level:int = 1
	
	for configuration in config_array:
		var board_size = configuration.board_size
		var colors = configuration.colors
		var levels = configuration.levels
		var gimmicks = configuration.gimmicks
		
		for i in levels:
			result[level] = {
				"board_size" : board_size,
				"total_colors" : colors,
				"grid_rects" : []
			}
			
			var mgr_idx =  randi() % board_size
			
			var all_chosen_colors:Array = []
			
			while all_chosen_colors.size() != colors:
				result[level]["grid_rects"] = []
				
				for j in board_size:
					var random_color_idx = randi() % colors
					
					if not all_chosen_colors.has(random_color_idx) and mgr_idx != j:
						all_chosen_colors.append(random_color_idx)
					
					var grid_rect := {
						"color" : random_color_idx,
						"is_control" : false
					}
					
					if mgr_idx == j:
						grid_rect.is_control = true
						grid_rect.color = -1
					
					result[level]["grid_rects"].append(grid_rect)
			
			result[level]["grid_rects"] = check_colors_and_adjust(configuration.min_amount_same_color_cubes, result[level]["grid_rects"])
			
			for gimmick in gimmicks:
				result[level]["grid_rects"] = add_gimmick(gimmick, result[level])
			
			level += 1
	
	return result

func add_gimmick(gimmick, level):
	match gimmick:
		Puzzle.GIMMICKS.EXACT_SPACES:
			return add_exact_spaces_gimmick(level)

func add_exact_spaces_gimmick(level):
	for rect in level["grid_rects"]:
		rect.color_space = randi() % level.total_colors
	return level["grid_rects"]

func check_colors_and_adjust(min_amount_same_color_cubes:int, level_details:Array) -> Array:
	var color_counter = {}
	
	for grid_rect in level_details:
		
		if grid_rect.is_control:
			continue
		
		var color = grid_rect.color
		
		if color in color_counter:
			color_counter[color] += 1
		else:
			color_counter[color] = 1
	
	while true:
		var all_good = true
			
		for color_idx in color_counter:
			if color_counter[color_idx] < min_amount_same_color_cubes:
				all_good = false
				
				var color_with_max_sum = _get_color_with_max_sum(color_counter.duplicate())

				for grid_rect in level_details:
					
					if grid_rect.is_control:
						continue
					
					if grid_rect.color == color_with_max_sum:
						grid_rect.color = color_idx
						color_counter[color_with_max_sum] -= 1
						color_counter[color_idx] += 1
						break
			
		if all_good:
			break
	
	return level_details

func _get_color_with_max_sum(color_counter) -> int:
	var m = 0
	var idx
	for c in color_counter:
		if color_counter[c] > m:
			m = color_counter[c]
			idx = c
	return idx

func save_levels(file_path, content:Dictionary):
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(JSON.print(content))
	file.close()

func _on_generate_btn_pressed():
	generate_levels(current_pack, current_difficulty)
	emit_signal("levels_generated")

func _on_save_all_pressed():
	if not current_generated_levels:
		print("Generate levels first -.-")
		return
	
	var file_name = Levels.get_file_name(current_pack, current_difficulty)
	var file_path = root_folder + file_name
	save_levels(file_path, current_generated_levels)
	print("--Successfully saved all the levels--\nPack: %s\nDifficulty: %s\nFile name: %s" % [Levels.get_pack_name(current_pack), Levels.get_difficulty_name(current_difficulty), Levels.get_file_name(current_pack, current_difficulty)])

func _on_save_level_pressed():
	var file_name = Levels.get_file_name(current_pack, current_difficulty)
	var file_path = root_folder + file_name
	var file = File.new()
	var err = file.open(file_path, File.READ)
	
	if err != OK or not current_generated_levels:
		print("Cannot save the level -.-")
		return
	
	var content:Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	content[get_parent().current_level] = current_generated_levels[get_parent().current_level]
	save_levels(file_path, content)
	print("--Successfully saved the level--\nLevel: %s\nPack: %s\nDifficulty: %s\nFile name: %s" % [str(get_parent().current_level), Levels.get_pack_name(current_pack), Levels.get_difficulty_name(current_difficulty), Levels.get_file_name(current_pack, current_difficulty)])
