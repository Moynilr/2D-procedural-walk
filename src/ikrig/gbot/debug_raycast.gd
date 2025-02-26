extends RayCast2D

@onready var polygon = $"Polygon"

func _physics_process(delta: float) -> void:
	if is_colliding():
		polygon.global_position = get_collision_point()
