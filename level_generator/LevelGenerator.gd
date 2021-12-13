extends Node2D

var root_folder = "user://"

func _ready():
	randomize()
	generate_levels(Levels.PACKS.CLASSIC, Levels.DIFFICULTY.LEVEL_1)


func generate_levels(pack, level) -> void:
	var configuration = LevelGeneratorConfiguration.get_configuration(pack, level)
	var file_name = Levels.get_file_name(pack, level)
	
	var generated_levels = generate_classic_levels(configuration)
	
	var file_path = root_folder + "/" + file_name
	
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(JSON.print(generated_levels))
	file.close()


func generate_classic_levels(config_array:Array) -> Dictionary:
	var result := {}
	
	var level = 1
	
	for configuration in config_array:
		var board_size = configuration.board_size * configuration.board_size
		var colors = configuration.colors
		var levels = configuration.levels
		
		var mgr_idx =  randi() % board_size
		
		for i in levels:
			result[level] = {}
			
			for j in board_size:
				var random_color_idx = randi() % colors
				
				var grid_rect := {
					"color" : random_color_idx,
					"is_control" : false
				}
				
				if mgr_idx == j:
					grid_rect.is_control = true
					grid_rect.color = -1
				
				result[level][j] = grid_rect
			
			result[level] = check_colors_and_adjust(configuration.min_amount_same_color_cubes, result[level])
			
			level += 1
	
	return result


func check_colors_and_adjust(min_amount_same_color_cubes:int, level_details:Dictionary) -> Dictionary:
	var color_counter = {}
	
	for i in level_details:
		var grid_rect = level_details[i]
		
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

				for j in level_details:
					var grid_rect = level_details[j]
					
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
