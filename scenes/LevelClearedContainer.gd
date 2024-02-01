extends Control

onready var tween:Tween = $Tween
onready var star_particles = $Popup/StarParticles

func show():
	star_particles.restart()
	star_particles.emitting = false
	$Popup.modulate.a = 0.0
	modulate.a = 0.0
	var start_pos = $Popup.rect_position
	tween.interpolate_property($Popup, "rect_position", start_pos + Vector2(0,500), start_pos, 1.0, Tween.TRANS_ELASTIC)
	tween.interpolate_property($Popup, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO)
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO)
	tween.start()
	.show()


func _on_Tween_tween_all_completed():
	star_particles.emitting = true