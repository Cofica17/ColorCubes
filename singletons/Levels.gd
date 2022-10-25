extends Node

enum PACKS {
	CLASSIC,
	CONNECTION
}

var pack_names := {
	0 : "Classic",
	1 : "Connection"
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

func get_file_name(pack, difficulty) -> String:
	return "%s_%s.json" % [pack_names[pack], difficulty_level_names[difficulty]]

func get_pack_name(pack):
	return pack_names[pack]

func get_difficulty_name(difficulty):
	return difficulty_level_names[difficulty]
