extends GridRect
class_name MoveableGridRect


func _ready():
	Global.connect("cancel_switch_grid_rects", self, "set_color", [Global.white])


func _on_clicked() -> void:
	Global.initiate_switch_grid_rects(self)
	set_color(Global.black)


func has_point(point:Vector2) -> bool:
	if(rect_size.x == 0):
		rect_size.x= rect_size.x
	if(rect_size.y == 0):
		rect_size.y= rect_size.y

	return point.x >= rect_position.x and point.x <= rect_position.x + rect_size.x and point.y >= rect_position.y and point.y <= rect_position.y + rect_size.y

