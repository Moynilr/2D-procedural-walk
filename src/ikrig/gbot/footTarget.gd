extends InverseScale

@onready var high : Node2D = $high
@onready var down : Node2D = $down
@onready var front : Node2D = $front

func get_high():
	return high.global_position

func get_down():
	return down.global_position
	
func get_front():
	return front.global_position
