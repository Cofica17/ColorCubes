extends Control

###
#HOW TO USE: place Swipe scene as direct child of the Control node you want to have the ability of swiping
###

#Defines in which direction parent control can be swiped
export var swipe_left:bool = false
export var swipe_right:bool = false
export var swipe_down:bool = false
export var swipe_up:bool = false

var SWIPE_DIRECTION = Global.DIRECTION

var parent:GridRect
var swipe:bool = false
var swipe_start:Vector2 = Vector2.ZERO
var start_parent_pos:Vector2 = Vector2.ZERO
var last_parent_pos:Vector2 = Vector2.ZERO
var current_swipe_direction
var start_parent_modulate_a:float

var change_dir_treshold = 1

signal swipe_finished
signal switch_grid_rects


func _ready():
	parent = get_parent()


func _input(event):
	#Making sure there can be no situation where parent has different position than specified as result of the swipe
	#This sometimes occured on mobile on fps drops
	if swipe and event is InputEventScreenTouch and event.is_pressed():
		if start_parent_pos:
			parent.rect_position = start_parent_pos
	
	if visible and has_point(get_local_mouse_position()) and (event.is_action_pressed("swipe") or event is InputEventScreenTouch and event.is_pressed()):
		swipe = true
		swipe_start = get_local_mouse_position()
		start_parent_pos = parent.rect_position
		start_parent_modulate_a = parent.modulate.a
		parent.change_z_index(2)
	
	if swipe:
		#TODO: check this
		var new_swipe_pos = _calculate_swipe(get_local_mouse_position())
		var new_parent_pos = parent.rect_position + new_swipe_pos

		if current_swipe_direction == null:
			#TODO: check this
			current_swipe_direction = _get_current_swipe_direction(new_parent_pos)
		
		if current_swipe_direction == null:
			return
		
#		var temp_swipe_dir = _get_current_swipe_direction(new_parent_pos)
#		if temp_swipe_dir != current_swipe_direction:
#			if new_parent_pos.x >= start_parent_pos.x - change_dir_treshold or\
#			new_parent_pos.x <= start_parent_pos.x + change_dir_treshold or\
#			new_parent_pos.y >= start_parent_pos.y - change_dir_treshold or\
#			new_parent_pos.y <= start_parent_pos.y + change_dir_treshold:
#				current_swipe_direction = temp_swipe_dir
#				parent.rect_position = start_parent_pos
		
		if swipe_right and current_swipe_direction == SWIPE_DIRECTION.RIGHT and new_parent_pos.x >= start_parent_pos.x:
			parent.rect_position.x += new_swipe_pos.x
		
		if swipe_left and current_swipe_direction == SWIPE_DIRECTION.LEFT and new_parent_pos.x <= start_parent_pos.x:
			parent.rect_position.x += new_swipe_pos.x
		
		if swipe_up and current_swipe_direction == SWIPE_DIRECTION.UP and new_parent_pos.y <= start_parent_pos.y:
			parent.rect_position.y += new_swipe_pos.y
		
		if swipe_down and current_swipe_direction == SWIPE_DIRECTION.DOWN and new_parent_pos.y >= start_parent_pos.y:
			parent.rect_position.y += new_swipe_pos.y
		
		last_parent_pos = parent.rect_position
	
	
	if swipe and (event.is_action_released("swipe") or event is InputEventScreenTouch and not event.is_pressed()):
		swipe = false
		parent.change_z_index(0)
		parent.rect_position = start_parent_pos
		
		if _swipe_reached_treshold():
			Global.emit_signal("switch_grid_rects", parent, current_swipe_direction)
		
		current_swipe_direction = null
		
		emit_signal("swipe_finished")


func _swipe_reached_treshold() -> bool:
	if current_swipe_direction == SWIPE_DIRECTION.RIGHT or current_swipe_direction == SWIPE_DIRECTION.LEFT:
		if abs(last_parent_pos.x - start_parent_pos.x) > parent.rect_size.x/2:
			return true
	
	if current_swipe_direction == SWIPE_DIRECTION.DOWN or current_swipe_direction == SWIPE_DIRECTION.UP:
		if abs(last_parent_pos.y - start_parent_pos.y) > parent.rect_size.y/2:
			return true
	
	return false


func _get_current_swipe_direction(swipe_pos:Vector2):
	if swipe_right and swipe_pos.x > start_parent_pos.x:
		return SWIPE_DIRECTION.RIGHT
	elif swipe_left and swipe_pos.x < start_parent_pos.x:
		return SWIPE_DIRECTION.LEFT
	elif swipe_down and swipe_pos.y > start_parent_pos.y:
		return SWIPE_DIRECTION.DOWN
	elif swipe_up and swipe_pos.y < start_parent_pos.y:
		return SWIPE_DIRECTION.UP


func _calculate_swipe(current_swipe_pos) -> Vector2:
	if swipe_start == null: 
		return Vector2.ZERO
	
	return current_swipe_pos - swipe_start


func has_point(point:Vector2) -> bool:
	if(rect_size.x == 0):
		rect_size.x= rect_size.x
	if(rect_size.y == 0):
		rect_size.y= rect_size.y

	return point.x >= rect_position.x and point.x <= rect_position.x + rect_size.x and point.y >= rect_position.y and point.y <= rect_position.y + rect_size.y
