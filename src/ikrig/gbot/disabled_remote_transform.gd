extends RemoteTransform2D
class_name DisabledRemoteTransform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_position = false
	update_rotation = false
	update_scale = false
