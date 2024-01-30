extends ColorRect

onready var enable_sfx_checkbox = $VBoxContainer/HBoxContainer/CheckBox

func _ready():
	Settings.load_settings()
	enable_sfx_checkbox.set_checked(Settings.enable_sfx_on_rect_move)

func _on_CloseBtn_pressed():
	Settings.save_settings()
	hide()

func _on_CheckBox_checked_changed():
	Settings.enable_sfx_on_rect_move = enable_sfx_checkbox.checked
	Settings.save_settings()
