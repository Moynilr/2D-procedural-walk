extends CharacterBody2D

@onready var anim := $"../AnimationPlayer"
@onready var floorRaycast : ShapeCast2D = $floorRayCast
@onready var stepWidthRayCast : RayCast2D = $stepWidthRayCast
var speed = 300.0
const JUMP_VELOCITY = -600.0
const MAX_STEP_HEIGHT = 85

var previous_dir = 1
var curr_anim
var isGrounded

func _ready() -> void:
	play_anim("idle")
	
func teleport(point_to: Vector2):
	global_position = point_to

func ui_set(key: String, value):
	if key=="speed":
		speed = value

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_grounded():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_grounded():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		if direction/abs(direction) != previous_dir:
			previous_dir = direction/abs(direction)
			get_tree().call_group("invert", "inverse", Vector2(previous_dir, 1))
			
		velocity.x = direction * speed
		play_anim("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		play_anim("idle")

	move_with_steps(delta)

func move_with_steps(delta: float):
	floorRaycast.global_position.x = global_position.x + velocity.x * delta
	
	if is_grounded():
		floorRaycast.force_shapecast_update()
		if floorRaycast.is_colliding() and velocity.y >= 0.0 and \
		 floorRaycast.get_collision_normal(0).angle_to(Vector2.UP) < floor_max_angle:
			
			stepWidthRayCast.global_position.x = global_position.x + velocity.x * delta
			stepWidthRayCast.global_position.y = floorRaycast.get_collision_point(0).y - 10
			stepWidthRayCast.force_raycast_update()
			if !stepWidthRayCast.is_colliding():
				global_position.y = floorRaycast.get_collision_point(0).y
				velocity.y = 0.0
				isGrounded = true
		else:
			isGrounded = false

	move_and_slide()

func run_body_test_motion(from: Transform2D, motion: Vector2, result):
	var params = PhysicsTestMotionParameters2D.new()
	params.from = from
	params.motion = motion
	params.exclude_objects = [floorRaycast.get_instance_id()]
	return PhysicsServer2D.body_test_motion(self.get_rid(), params, result)

func play_anim(anim_nam: String):
	if curr_anim != anim_nam:
		anim.play(anim_nam)
		curr_anim = anim_nam

func is_grounded():
	return is_on_floor() or isGrounded
