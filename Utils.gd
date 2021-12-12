extends Node


func generate_random_int_excluding(from:int, to:int, excluding:Array = []) -> int:
	var rnd = randi() % (to+1)
	
	while rnd in excluding or rnd < from:
		rnd = randi() % (to+1)
	
	return rnd
