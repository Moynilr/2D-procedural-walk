extends Node2D

@onready var raycast_targetR : RayCast2D = $"../../IK Targets/FootR Target/RaycastStepTargetR"
@onready var raycast_targetL : RayCast2D = $"../../IK Targets/FootL Target/RaycastStepTargetL"
@onready var hip_target = $"../../IK Targets/Hip Target"

@export var step_size: int = 200
@export var leg_offset: int = 160
@export var max_leg_height = 220*0.23
@export var min_leg_height = 80*0.23

func ui_set(key: String, value):
	if key=="leg_offset":
		leg_offset = value
		set_step_var()
	if key=="step_size":
		step_size = value
		set_step_var()
	if key=="max_leg_height":
		max_leg_height = value
		set_step_var()
	if key=="min_leg_height":
		min_leg_height = value
		set_step_var()

func set_step_var():
	raycast_targetR.position.x = step_size + leg_offset
	raycast_targetL.position.x = step_size
	for i in get_children():
		if i.has_method("set_step_var"):
			i.set_step_var(step_size, min_leg_height, max_leg_height)

func _ready() -> void:
	await raycast_targetR.ready
	await raycast_targetL.ready
	set_step_var()

func set_move(isMoving: bool):
	for i in get_children():
		if i.has_method("set_move"):
			i.set_move(isMoving)
	
	#await handsRefR.ready
	#handsRefR.set_back_x(handsRefR.global_position.x - step_size.x/4)
	#handsRefR.set_front_x(handsRefR.global_position.x + step_size.x/3)
#enum STATE {ON_GROUND, BEFORE_PASS, AFTER_PASS}
#
#var foots_state :Array[STATE] = [STATE.ON_GROUND, STATE.ON_GROUND]
#
#func _physics_process(delta: float) -> void:
	#for i in range(foots.size()):
		#if is_on_ground(i) and is_on_ground(get_other_foot(i)):
			#if abs(foots[i].position.x - hip_target.position.x) > step_size:
				#foots_state[i] = STATE.BEFORE_PASS
				#foots_target[i] = Vector2(get_next_step_position(), foots_target[i].y)
				#foots_target_mid[i] = Vector2(hip_target.position.x, foots_target[i].y - raise_foot_pass)
#
	#for i in range(foots.size()):
		#if foots_state[i] == STATE.BEFORE_PASS:
			#if abs(foots[i].position.x - foots_target_mid[i].x) > 0.1:
				#foots[i].position = lerp(foots[i].position, foots_target_mid[i], 0.6)
			#else:
				#foots_state[i] = STATE.AFTER_PASS
		#if foots_state[i] == STATE.AFTER_PASS and abs(foots[i].position.x - foots_target[i].x) > 0.1:
			#foots[i].position = lerp(foots[i].position, foots_target[i], 0.5)
		#elif foots_state[i] != STATE.BEFORE_PASS:
			#foots_state[i] = STATE.ON_GROUND
#
#func is_on_ground(i):
	#return foots_state[i] == STATE.ON_GROUND
#
#func get_other_foot(i):
	#if i==1:
		#return 0
	#return 1
#
#func get_next_step_position():
	#return hip_target.position.x + step_size
