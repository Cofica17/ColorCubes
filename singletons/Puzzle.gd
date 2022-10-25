extends Node

signal difficulty_changed

var pack:int = 0
var difficulty:int = 0
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

func change_difficulty(new_dif) -> void:
	difficulty = new_dif
	emit_signal("difficulty_changed")
