extends Node

enum PACKS {
	CLASSIC,
	CONNECTION
}

enum DIFFICULTY {
	LEVEL_1,
	LEVEL_2,
	LEVEL_3
}

var difficulty_level_names := {
	0 : "Introduction",
	1 : "Challenging",
	2 : "Insane"
}

var pack_names := {
	0 : "Classic",
	1 : "Connection"
}

var file_names := {
	PACKS.CLASSIC : {
		DIFFICULTY.LEVEL_1 : "classic_dfl_1.json",
		DIFFICULTY.LEVEL_2 : "classic_dfl_2.json",
		DIFFICULTY.LEVEL_3 : "classic_dfl_3.json"
	}
}

func get_file_name(pack, difficulty) -> Dictionary:
	return file_names[pack][difficulty]


