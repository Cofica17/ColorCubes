extends GridRect
class_name ColoredGridRect

onready var border = get_node("Panel")
onready var exact_space = $ExactSpace
onready var inside_panel = get_node("InsidePanel")
onready var texture:TextureRect = $TextureRect

var is_connection_rect := false


func set_texture(tex:Texture) -> void:
	texture.texture = tex
	texture.show()
	is_connection_rect = true

func set_exact_space_color(v:Color) -> void:
	exact_space.show()
	var current_style = exact_space.get_stylebox("panel")
	var new_style = current_style.duplicate()
	v.a = v.a/2
	new_style.bg_color = v
	exact_space.add_stylebox_override("panel", new_style)

func set_color(v:Color) -> void:
	color = v
	var current_style = inside_panel.get_stylebox("panel")
	var new_style = current_style.duplicate()
	new_style.bg_color = color
	inside_panel.add_stylebox_override("panel", new_style)

func _on_clicked() -> void:
	Global.finish_switch_grid_rects(self)

func _on_Button_pressed():
	_on_clicked()
