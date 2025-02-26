extends Polygon2D

@export var coll_source: CollisionPolygon2D

func _ready() -> void:
	polygon = coll_source.polygon
