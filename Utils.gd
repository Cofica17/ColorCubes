extends Node


func generate_random_int_excluding(from:int, to:int, excluding:Array = []) -> int:
	var rnd = Global.RNG.randi() % (to+1)
	
	while rnd in excluding or rnd < from:
		rnd = Global.RNG.randi() % (to+1)
	
	return rnd
