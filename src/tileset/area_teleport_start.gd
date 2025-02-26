extends Area2D

@export var teleport_to : Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("teleport"):
		body.teleport(teleport_to.global_position)
