extends TextureButton

export var checked_tex:Resource = load("res://assets/checkbox.png")
export var unchecked_tex:Resource = load("res://assets/unchecked.png")

var checked = true

signal checked_changed

func _ready():
	texture_normal = checked_tex

func set_checked(v):
	checked = v
	texture_normal = checked_tex if checked else unchecked_tex
	emit_signal("checked_changed")

func _on_CheckBox_pressed():
	set_checked(!checked)
