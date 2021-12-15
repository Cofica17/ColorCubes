extends Control
class_name GridRect
tool

var column:int
var row:int
var id:int

var color:Color setget set_color, get_rect_color


func get_rect_color() -> Color:
	return color


#Virtual method
func set_color(v:Color) -> void:
	pass


#Virtual method
func _on_clicked() -> void:
	pass
