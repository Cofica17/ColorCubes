extends Control


onready var first_tip = $Panel/FirstTip
onready var second_tip = $Panel/SecondTip
onready var tween:Tween = $Tween

func _ready():
	call_deferred("show_tutorial")

func show_tutorial():
	if not visible:
		return
	
	tween.interpolate_property(self, "rect_position", rect_size/2, Vector2.ZERO, 2.5, Tween.TRANS_EXPO)
	tween.interpolate_property(self, "rect_scale", Vector2.ZERO, Vector2.ONE, 2.5, Tween.TRANS_EXPO)
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 2.5, Tween.TRANS_EXPO)
	tween.interpolate_property($ColorRect, "modulate:a", 0.0, 1.0, 4.5, Tween.TRANS_EXPO)
	tween.start()

func _on_NextBtn_pressed():
	first_tip.hide()
	second_tip.show()

func _on_CloseBtn_pressed():
	Global.game_data.tutorial_completed = true
	Global.save_game()
	hide()
