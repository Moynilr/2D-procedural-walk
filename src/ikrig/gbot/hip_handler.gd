extends Node2D

@export var footR : CharacterBody2D
@export var footL : CharacterBody2D
@export var legHandlerR : LegHandler
@export var legHandlerL : LegHandler
@export var hipTarget : Node2D

var max_leg_height: float = 200*0.23
var min_leg_height: float
var stepDistance

func _ready() -> void:
	await hipTarget.ready
	await get_parent().ready

func set_step_var(distance, min_leg_heightIn, leg_height):
	stepDistance = distance
	min_leg_height = min_leg_heightIn
	max_leg_height = leg_height

func _physics_process(_delta: float) -> void:
	var mid_pos_x = (footL.global_position.x + footR.global_position.x)/2
	var min_pos_y = max(footL.global_position.y, footR.global_position.y)
	
	hipTarget.global_position.x = mid_pos_x
	hipTarget.global_position.y =  lerp(hipTarget.global_position.y, min_pos_y - get_height(), 0.8)

func get_height():
	var progress = get_step_progress()
	if progress != null:
		if progress > 0.5:
			progress = 1 - progress
		return get_max_length() * (1- (progress*2)) + get_min_length() * (progress * 2)
	return get_max_length()

func get_step_progress():
	if legHandlerL.onGround == false:
		return legHandlerL.get_progress()
	if legHandlerR.onGround == false:
		return legHandlerR.get_progress()
	return null

func get_max_length():
	return max_leg_height
	
func get_min_length():
	return min_leg_height
