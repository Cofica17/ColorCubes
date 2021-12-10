extends Control
class_name GridRect
tool

onready var color_rect = get_node("ColorRect")
onready var border = get_node("Panel")

var color:Color setget set_color, get_rect_color

var column:int
var row:int
var id:int


func set_color(v:Color) -> void:
	color = v
	color_rect.color = color


func get_rect_color() -> Color:
	return color


func _gui_input(event):
	if event.is_pressed():
		_on_clicked()


#Virtual method
func _on_clicked() -> void:
	pass
