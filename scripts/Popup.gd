extends Panel

signal next_level_pressed
signal home_pressed
signal restart_pressed


func _ready():
	pass


func _on_Next_pressed():
	emit_signal("next_level_pressed")


func _on_Home_pressed():
	emit_signal("home_pressed")


func _on_Restart_pressed():
	emit_signal("restart_pressed")
