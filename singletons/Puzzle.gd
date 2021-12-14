extends Node

var current_preview:int = 1

var pack:int
var difficulty:int
var level:int
var content:Dictionary

var chosen_color = "#373A40"
var solved_color = "#83E694"
var unsolved_color = "#ffffff"

func _ready():
	Global.connect("level_chosen", self, "_on_level_chosen")


func _on_level_chosen(lvl) -> void:
	current_preview = lvl
