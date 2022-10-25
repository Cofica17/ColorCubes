extends Control
class_name GridRect
tool

onready var exact_space = $ExactSpace

var column:int
var row:int
var id:int

var color:Color setget set_color, get_rect_color
var exact_space_color:Color setget set_exact_space_color

func get_rect_color() -> Color:
	return color

#Virtual method
func set_color(v:Color) -> void:
	pass

#Virtual method
func _on_clicked() -> void:
	pass

func set_exact_space_color(v:Color) -> void:
	exact_space_color = v
	var current_style = exact_space.get_stylebox("panel")
	var new_style = current_style.duplicate()
	v.a = v.a*0.7
	new_style.bg_color = v
	exact_space.add_stylebox_override("panel", new_style)
