extends Panel

onready var level_number = $LevelNumber

var color
var level


func _ready():
	$Button.connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	Global.emit_signal("level_chosen", level)


func set_color(v) -> void:
	color = v
	
	if color == Puzzle.solved_color or color == Puzzle.chosen_color:
		level_number.set("custom_colors/font_color", "#ffffff")
	else:
		level_number.set("custom_colors/font_color", Puzzle.chosen_color)
	
	var current_style = get_stylebox("panel")
	var new_style = current_style.duplicate()
	new_style.bg_color = color
	add_stylebox_override("panel", new_style)


func set_level(v:int) -> void:
	level = v
	level_number.text = str(level)
