extends RayCast2D

#@onready var raycasts = [self, $"../RaycastStepTarget2", $"../RaycastStepTarget3"]

@export var stepTarget: Node2D

var lastHitPoint
var lastInclinaison = Vector2(0, -1)

func _physics_process(_delta: float) -> void:
	update()

func update():
	if is_colliding():
		var hitPoint = get_collision_point()
		var inclinaison = get_collision_normal()
		stepTarget.global_position = hitPoint
		lastHitPoint = hitPoint
		lastInclinaison = inclinaison

#func get_floor_and_collision_normal_position():
	#var collision_points: Array[Vector2] = []
	#var collision_normals: Array[Vector2] = []
	#var collision_normals_dot: Array[float] = []
	#for i in raycasts:
		#if i.is_colliding():
			#collision_points.append(i.get_collision_point())
			#collision_normals.append(i.get_collision_normal())
			#collision_normals_dot.append(i.get_collision_normal().dot(Vector2.UP))
	#if collision_normals_dot.size() > 0:
		#var index_min_dot = collision_normals_dot.find(collision_normals_dot.min())
		#return [collision_points[index_min_dot], collision_normals[index_min_dot]]
	#else:
		#return null
