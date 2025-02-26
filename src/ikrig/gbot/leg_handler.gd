extends Node2D
class_name LegHandler

@export var footCharacter :FootTargetController
@export var footTarget : Node2D
@export var footLookAt: Node2D
@export var opositeLegHandler: LegHandler
@export var idlePos : RayCast2D
@export var oppositeLegRaycast : RayCast2D

@onready var mvtController = $"../../../.."
@onready var hip_target = $"../../../IK Targets/Hip Target"

var onGround : bool = true
var lockStepSem : Mutex = Mutex.new()

var lookAtBefStep
var onGroundLookAt

var isMoving = false
var isWalking = false
var isRunning = false

var oppositePgStep = 1

var lastTarget:Vector2
var lastInclinaison:Vector2 = Vector2(0,0)

func ui_set(key: String, value):
	if key=="walk_run":
		isWalking = value
		isRunning = !value
	if key=="oppositePgStep":
		oppositePgStep = value

func _ready() -> void:
	lookAtBefStep = footLookAt.global_position
	isWalking = false
	footCharacter.connect("target_reached", _on_foot_target_reached)
	await oppositeLegRaycast.ready
	refresh_raycast()
	await  footCharacter.ready

func is_on_ground():
	return onGround

func get_target_global_position():
	return oppositeLegRaycast.lastHitPoint

func _on_foot_target_reached():
	onGround = true
	print("onGround true: ", name)

func get_progress():
	return footCharacter.get_target_progress()

func set_move(isMoveIn):
	isMoving = isMoveIn
	if not isMoving:
		if idlePos.is_colliding():
			lastTarget = idlePos.get_collision_point()
			set_foot_target(false, 10)
		
func _physics_process(_delta: float) -> void:
	lockStepSem.lock()
	if isWalking and onGround and opositeLegHandler.onGround\
	 and get_distance_to_target()>=opositeLegHandler.get_distance_to_target():
		lookAtBefStep = footLookAt.global_position
		step()
	if isRunning and onGround and (opositeLegHandler.get_progress() == null ||
	opositeLegHandler.get_progress() > oppositePgStep) and get_distance_to_target()>=opositeLegHandler.get_distance_to_target():
		lookAtBefStep = footLookAt.global_position
		step()
	lockStepSem.unlock()

	#if (isWalking or isRunning) and get_distance_to_target()>=opositeLegHandler.get_distance_to_target():
		#print("raycast_target.position.x ", raycast_target.position.x, " diff ", (hip_target.position.x - footTarget.position.x))
		#raycast_target.position.x = raycast_target.position.x +(hip_target.position.x - footTarget.position.x)
		#print("raycast_target.position.x ", raycast_target.position.x)

func step():
	print("step: ", name)
	onGround = false
	refresh_target(true, 8)

func refresh_target(from_ground: bool, dist_to_ground: int = 8):
	refresh_raycast()
	if not onGround:
		set_foot_target(from_ground, dist_to_ground)

func set_foot_target(from_ground, dist_to_ground):
	#if name == "LegHandlerL":
		#lastTarget += Vector2(135*0.23, 0) * get_step_sign()
	if get_distance_to_target() > 500:
		print("target to far away!")
	else:
		footCharacter.set_target(lastTarget, from_ground, dist_to_ground, get_step_sign())
		$Polygon2D.global_position = lastTarget
	

func refresh_raycast():
	oppositeLegRaycast.force_update_transform()
	oppositeLegRaycast.force_raycast_update()
	oppositeLegRaycast.update()
	if oppositeLegRaycast.lastHitPoint != null:
		lastTarget = oppositeLegRaycast.lastHitPoint


func get_distance_to_target():
	return abs(footCharacter.global_position.distance_to(oppositeLegRaycast.lastHitPoint))


func get_step_sign():
	if mvtController.is_heading_right():
		return 1
	else:
		return -1
	
