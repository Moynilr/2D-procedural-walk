extends CharacterBody2D
class_name FootTargetController

@export var footLookAt: Node2D
@export var raycast_mid2Target : RayCast2D

@onready var areaCollision := $Area2D
@onready var defaultLookAt: Node2D = $"lookAtDefault"
@onready var raycasts_front: RayCast2D = $"Raycasts/front/RayCast2D"
@onready var raycasts_floor: Array[RayCast2D] = [$"Raycasts/floor/RayCast2D4", $"Raycasts/floor/RayCast2D2"]

const JUMP_VELOCITY := -400.0
const feet_length := 80 * 0.23

var offssetFootBefore := Vector2(-14, -40)

var SPEED_MIN := 100.0
var SPEED_MAX := 200

var is_speed_constant = true
var previous_speed = SPEED_MAX
var position_bf : Vector2
var start_pos : Vector2
var currTarget: Target = null
var final_target: Target = null
var firstTimeNotOnGround = false

class Target:
	var tarName: String
	var tarPosition: Vector2
	var nextTarget: Target
	var distToReach: int
	var useOnlyX: bool
	var useParent: bool
	var overrideYParent: bool
	func _init(tarNameIn: String, posIn: Vector2, nextIn: Target, distToReachIn: int = 8, 
	useOnlyXIn: bool = true, useParentIn: bool = false, overY: bool = false):
		tarName = tarNameIn
		tarPosition = posIn
		nextTarget = nextIn
		distToReach = distToReachIn
		useOnlyX = useOnlyXIn
		useParent = useParentIn
		overrideYParent = overY

signal target_reached

func ui_set(key: String, value):
	if key =="is_speed_constant":
		is_speed_constant = value
	if key=="speed_min":
		SPEED_MIN = value
	if key=="speed_max":
		SPEED_MAX = value
	if key=="offssetFootBefore.x":
		offssetFootBefore.x = value
	if key=="offssetFootBefore.y":
		offssetFootBefore.y = value

func get_target_name():
	if currTarget == null:
		return null
	return currTarget.tarName

func _ready() -> void:
	floor_constant_speed = true
	position_bf = global_position

func get_target_progress():
	if currTarget != null:
		return 1 - min(1, abs(get_global_position().x - final_target.tarPosition.x) \
		/ abs(start_pos.x - final_target.tarPosition.x))
	return null

func set_target(target_in: Vector2, from_ground: bool, dist_to_reach: int,
step_sign: int):
	print(name, " set target=", target_in, " curr: ", currTarget)
	previous_speed = SPEED_MAX
	firstTimeNotOnGround = false
	currTarget = null
	var newTar
	if target_in == null:
		velocity = Vector2.ZERO
		currTarget = Target.new("position_bf", position_bf, null)
		final_target = currTarget
	else:
		newTar = Target.new("target", target_in, null, dist_to_reach)
		final_target = newTar
		if from_ground:
			position_bf = global_position
			
			var mid2TargetPos= get_mid2_target_position(target_in + offssetFootBefore*Vector2(step_sign, 1))
			var mid2Target = Target.new("mid2_target", mid2TargetPos, newTar, 15, false)
			$"../Polygon2D2".global_position = mid2TargetPos
			
			var mid_target_pos = get_mid_target_position(target_in)
			var midTarget = Target.new("mid_target", mid_target_pos, mid2Target, 15, false)
			currTarget = midTarget
		else:
			currTarget = newTar
	start_pos = global_position


func get_mid2_target_position(new_raycast_pos: Vector2):
	raycast_mid2Target.global_position = new_raycast_pos
	raycast_mid2Target.force_raycast_update()
	if raycasts_front.is_colliding():
		var collisionPoint = raycasts_front.get_collision_point()
		if collisionPoint.y < new_raycast_pos.y:
			return Vector2(new_raycast_pos.x, collisionPoint.y -10)
	return new_raycast_pos

func get_mid_target_position(nexTarPos: Vector2):
	return global_position + Vector2(global_position.direction_to(nexTarPos).normalized().x \
		* feet_length , -(feet_length + 10))

func get_curr_speed():
	if is_speed_constant:
		return SPEED_MAX
	var progress = get_target_progress()
	if progress == null:
		return previous_speed
	else:
		var new_speed = (1-progress)* SPEED_MAX + SPEED_MIN * progress
		if new_speed < previous_speed:
			previous_speed = new_speed
			return previous_speed
		else:
			return previous_speed

func _physics_process(_delta: float) -> void:
	set_foot_look_at()
	if currTarget != null:
		if !is_target_reached(currTarget):
			var currSpeed = get_curr_speed()
			move_to(currSpeed)
			if areaCollision.has_overlapping_bodies():
				velocity.y = - currSpeed
				var front_position = get_front_floor_position()
				if front_position != null:
					var tarParent = currTarget
					if get_target_name() == "rise_target":
						tarParent = currTarget.nextTarget
					currTarget = Target.new("rise_target", front_position - Vector2(0, 10), \
					tarParent, 5, true, true, true)
				if is_target_reached(final_target):
					switch_to_next_target()
			elif get_target_name() == "rise_target":
				switch_to_next_target()
				
		else:
			if currTarget.nextTarget != null:
				switch_to_next_target()
			else:
				on_target_reached()
	
	if currTarget == null and not is_on_floor():
		velocity.y += previous_speed
	if is_on_floor() and velocity.y > 0:
		velocity.y = 0
	move_and_slide()

func set_foot_look_at():
	var targetName = get_target_name()
	if  targetName !="mid_target":
		footLookAt.global_position.x = defaultLookAt.get_front().x
	if targetName == "target" or targetName == "mid2_target":
		footLookAt.global_position = lerp(defaultLookAt.get_down(), \
		defaultLookAt.get_high(), get_target_progress())
	if is_on_floor() and raycasts_floor[1].is_colliding() and raycasts_floor[0].is_colliding():
		var floor_incl = raycasts_floor[1].get_collision_point() - raycasts_floor[0].get_collision_point()
		footLookAt.global_position = defaultLookAt.get_front() + floor_incl


func get_front_floor_position():
	if raycasts_front.is_colliding():
		return raycasts_front.get_collision_point()
	else:
		return null

func is_final_target_reached():
	if currTarget.nextTarget != null:
		return false
		

func is_target_reached(targetIn: Target):
	if targetIn.useParent:
		return is_target_reached(targetIn.nextTarget)
		
	if targetIn.useOnlyX:
		return abs(global_position.x - targetIn.tarPosition.x) < targetIn.distToReach
	return global_position.distance_to(targetIn.tarPosition) < targetIn.distToReach 

func move_to(currSpeed):
	var direction = global_position.direction_to(currTarget.tarPosition)
	velocity = direction.normalized() * currSpeed

func switch_to_next_target():
	var newTar = currTarget.nextTarget
	if newTar != null and newTar.tarName == "mid_target":
		newTar.tarPosition = get_mid_target_position(newTar.nextTarget.tarPosition)
	if currTarget.overrideYParent and currTarget.tarPosition.y < newTar.tarPosition.y:
		newTar.tarPosition.y = currTarget.tarPosition.y
	currTarget = newTar

func on_target_reached():
	switch_to_next_target()
	position_bf = global_position
	
	if currTarget == null:
		velocity = Vector2.ZERO
		print(name, "target reached !")
		emit_signal("target_reached")
		firstTimeNotOnGround = true
		final_target = null
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY	
	#move_and_slide()

func teleport(point_to: Vector2):
	get_parent().global_position = point_to
