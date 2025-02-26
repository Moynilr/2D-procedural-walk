extends Node2D

@export var min_max_interpolation := Vector2(0, 1)
@export var foot_height_offset := 0.05

@onready var target_right := $"interpolations/intermediate_targets/FootR Target"
@onready var target_left := $"interpolations/intermediate_targets/FootL Target"
@onready var target_look_at_right := $"interpolations/intermediate_targets/FootR LookAt"
@onready var target_look_at_left := $"interpolations/intermediate_targets/FootL LookAt"
@onready var ray_right := $raycasts/right
@onready var ray_left := $raycasts/left
@onready var ray_look_at_right := $raycasts/right2
@onready var ray_look_at_left := $raycasts/left2
@onready var interpolation_right := $interpolations/right
@onready var interpolation_left := $interpolations/left

@onready var anim_target_right := $"../FootR Target"
@onready var anim_target_left := $"../FootL Target"
@onready var anim_target_look_at_right := $"../FootR LookAt"
@onready var anim_target_look_at_left := $"../FootL LookAt"

func update_ik_target_position(soft, target: Node2D, anim_target: Node2D, look_at: Node2D, anim_lookAt: Node2D, raycast: RayCast2D, raycast_look_at: RayCast2D,  foot_height_offset : float) -> void:
	if raycast.is_colliding():
		var hit_point := raycast.get_collision_point().y + foot_height_offset
		target.global_transform.origin.y = lerp(anim_target.global_position.y, hit_point, soft)
		
		# collsision normal does not always work well
		#var hit_angle := raycast.get_collision_normal().rotated(deg_to_rad(-90))
		#look_at.position = target.position - hit_angle
		if raycast_look_at.is_colliding():
			var hit_point2 =  raycast_look_at.get_collision_point().y + foot_height_offset
			look_at.global_transform.origin.y = lerp(anim_lookAt.global_position.y, hit_point2, soft)
		else:
			look_at.global_transform.origin.y = anim_lookAt.global_position.y
	else:
		target.global_transform.origin.y = anim_target.global_position.y
		look_at.global_transform.origin.y = anim_lookAt.global_position.y
	target.global_transform.origin.x = anim_target.global_position.x
	look_at.global_transform.origin.x = anim_lookAt.global_position.x

func _physics_process(delta: float) -> void:
	var soft_right = clamp(interpolation_right.position.y, min_max_interpolation.x, min_max_interpolation.y)
	update_ik_target_position(soft_right , target_left, anim_target_left, target_look_at_left, anim_target_look_at_left, ray_left, ray_look_at_left, foot_height_offset)
	var soft_left = clamp(interpolation_left.position.y, min_max_interpolation.x, min_max_interpolation.y)
	update_ik_target_position(soft_left, target_right, anim_target_right, target_look_at_right, anim_target_look_at_right, ray_right, ray_look_at_right, foot_height_offset)
	
