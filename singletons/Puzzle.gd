extends Node

var pack:int
var difficulty:int
var level:int = 1
var content:Dictionary
var max_levels:int = 100
var puzzle:Dictionary

var chosen_color = "#373A40"
var solved_color = "#83E694"
var unsolved_color = "#ffffff"

func _ready():
	Global.connect("level_chosen", self, "_on_level_chosen")


func _on_level_chosen(lvl) -> void:
	level = lvl
