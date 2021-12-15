extends Node


var configuration := {
	Levels.PACKS.CLASSIC : {
		Levels.DIFFICULTY.LEVEL_1 : Classic_DFL_1.new().configuration,
		Levels.DIFFICULTY.LEVEL_2 : Classic_DFL_2.new().configuration,
		Levels.DIFFICULTY.LEVEL_3 : Classic_DFL_3.new().configuration
	}
}

func get_configuration(pack, difficulty) -> Dictionary:
	return configuration[pack][difficulty]
