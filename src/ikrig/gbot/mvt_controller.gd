extends Node2D

@onready var characterAnim = $"CharacterAnim"
var current_dir : DIR = DIR.RIGHT
var current_state: STATE
enum DIR {RIGHT, LEFT}
enum STATE {RUN, IDLE}

var secondRefresh = 0
var begin = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		pass
	if secondRefresh > 0:
		secondRefresh -= 1
		get_tree().call_group("targetable", "refresh_target", false)
		
	var right = Input.is_action_just_pressed("ui_right")
	var left = Input.is_action_just_pressed("ui_left")
	
	if right or left:
		if not begin:
			begin = true
			get_tree().call_group("ui_set", "ui_set", "walk_run", true) 
		if right and current_dir != DIR.RIGHT:
			current_dir = DIR.RIGHT
			get_tree().call_group("invert", "inverse", Vector2(1, 1))
			get_tree().call_group("targetable", "refresh_target", false)
			secondRefresh = 2
		if left and current_dir != DIR.LEFT:
			current_dir = DIR.LEFT
			get_tree().call_group("invert", "inverse", Vector2(-1, 1))
			get_tree().call_group("targetable", "refresh_target", false)
			secondRefresh = 2
		if current_state == STATE.IDLE:
			get_tree().call_group("targetable", "refresh_target", false)
			current_state = STATE.RUN
			characterAnim.set_move(true)
	else:
		if current_state == STATE.RUN:
			get_tree().call_group("targetable", "refresh_target", false)
			current_state = STATE.IDLE
			characterAnim.set_move(false)

func is_heading_right():
	return current_dir == DIR.RIGHT
