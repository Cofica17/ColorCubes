extends Node2D

signal levels_generated

var root_folder = "res://levels_jsons/"

func _ready():
	randomize()

func generate_levels(pack, level) -> void:
	var configuration = LevelsCreatorConfiguration.get_configuration(pack, level)
	var file_name = Levels.get_file_name(pack, level)
	
	var generated_levels = generate_classic_levels(configuration)
	
	var file_path = root_folder + file_name
	
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(JSON.print(generated_levels))
	file.close()

func generate_classic_levels(config_array:Array) -> Dictionary:
	var result := {}
	
	var level:int = 1
	
	for configuration in config_array:
		var board_size = configuration.board_size
		var colors = configuration.colors
		var levels = configuration.levels
		
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
			
			level += 1
	
	return result

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

func _on_Button_pressed():
	generate_levels(Levels.PACKS.CLASSIC, Levels.DIFFICULTY.LEVEL_1)
	generate_levels(Levels.PACKS.CLASSIC, Levels.DIFFICULTY.LEVEL_2)
	generate_levels(Levels.PACKS.CLASSIC, Levels.DIFFICULTY.LEVEL_3)
	emit_signal("levels_generated")
