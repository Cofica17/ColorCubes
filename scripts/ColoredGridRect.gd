extends GridRect
class_name ColoredGridRect

onready var border = get_node("Panel")
onready var inside_panel = get_node("InsidePanel")


func set_color(v:Color) -> void:
	color = v
	var current_style = inside_panel.get_stylebox("panel")
	var new_style = current_style.duplicate()
	new_style.bg_color = color
	inside_panel.add_stylebox_override("panel", new_style)


func _on_clicked() -> void:
	Global.finish_switch_grid_rects(self)
