extends Node2D
class_name HandCheckPoint

@onready var back := $back
@onready var middle := $middle
@onready var front := $front

func get_front_pos():
	return front.global_position

func get_middle_pos():
	return middle.global_position

func get_back_pos():
	return back.global_position


func set_front_x(x_pos: float):
	front.global_position.x = x_pos

func set_back_x(x_pos: float):
	back.global_position.x = x_pos
