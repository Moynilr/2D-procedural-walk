extends Node2D

@onready var walkController = $Animations/Walking
#
#func _ready() -> void:
	#set_walk(false)


func set_move(isMoving):
	walkController.set_move(isMoving)

	
