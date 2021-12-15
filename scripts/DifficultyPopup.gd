extends Panel


func _ready():
	var i = 0
	for idx in Levels.DIFFICULTY:
		var btn:Button = load(Scenes.DifficultyButtonScene).instance()
		btn.text = Levels.difficulty_level_names[i].to_upper()
		btn.connect("pressed", Puzzle, "change_difficulty", [i])
		$VBoxContainer.add_child(btn)
		i += 1
