extends ColorRect

onready var enable_sfx_checkbox = $VBoxContainer/HBoxContainer/CheckBox
onready var credits = $Credits
onready var privacy_policy = $PrivacyPolicy
onready var terms_conditions = $TermsConditions

func _ready():
	Settings.load_settings()
	enable_sfx_checkbox.set_checked(Settings.enable_sfx_on_rect_move)

func _on_CloseBtn_pressed():
	Settings.save_settings()
	hide()

func _on_CheckBox_checked_changed():
	Settings.enable_sfx_on_rect_move = enable_sfx_checkbox.checked
	Settings.save_settings()


func _on_CloseBtn2_pressed():
	credits.hide()


func _on_Credits_pressed():
	credits.show()


func _on_PrivacyPolicy_pressed():
	privacy_policy.show()


func _on_CloseBtn3_pressed():
	privacy_policy.hide()


func _on_TermsConditions_pressed():
	terms_conditions.show()


func _on_CloseBtn4_pressed():
	terms_conditions.hide()
