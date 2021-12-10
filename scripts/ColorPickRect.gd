extends Control
tool

export var color:Color setget set_color


func _ready():
	$Button.connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	 Global.current_color = $ColorRect.color


func set_color(v) -> void:
	color = v
	$ColorRect.color = color
