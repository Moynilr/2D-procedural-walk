extends Node2D
class_name InvertPositionFromParent

@export var parent : Node2D

var original_pos

func _ready() -> void:
	original_pos = abs(parent.global_position.x - global_position.x)


func inverse(inverse_to: Vector2):
	if inverse_to.x == -1:
		global_position.x = parent.global_position.x + original_pos
	else:
		global_position.x = parent.global_position.x - original_pos
	print(name, " inverse: ", inverse_to, " or: ", original_pos, " glob.x: ", global_position.x)
	
		
	
