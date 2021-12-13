extends Node


var configuration := {
	Levels.PACKS.CLASSIC : {
		Levels.DIFFICULTY.LEVEL_1 : Classic_DF1.new().configuration
	}
}

func get_configuration(pack, difficulty) -> Dictionary:
	return configuration[pack][difficulty]
