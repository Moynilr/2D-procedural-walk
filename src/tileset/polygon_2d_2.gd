extends Polygon2D

@export var cool_shape : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = cool_shape.position
	var origin_pos = cool_shape.shape.get_rect().position
	var shape_size = cool_shape.shape.get_rect().size
	polygon = PackedVector2Array([origin_pos, origin_pos + Vector2(shape_size.x, 0), \
	origin_pos + shape_size, origin_pos + Vector2(0, shape_size.y)])
	
