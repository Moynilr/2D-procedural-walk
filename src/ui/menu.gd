extends Control

@onready var total_parent := $"../../.."

@onready var procedural = preload("res://src/ikrig/gbot/gbot_anim.tscn")
@onready var anim = preload("res://src/ikrig/gbot/gbot_anim_2.tscn")

@onready var current_gbot := $"../../../procedural"
var is_procedural = true

func _on_procedural_pressed() -> void:
	change_gb(procedural, is_procedural)

func _on_animationik_pressed() -> void:
	change_gb(anim, !is_procedural)

func change_gb(to_instantiate, return_if):
	if return_if:
		return
	is_procedural = !is_procedural
	total_parent.remove_child(current_gbot)
	current_gbot.queue_free()
	current_gbot = null
	current_gbot = to_instantiate.instantiate()
	current_gbot.scale = Vector2(0.23, 0.23)
	current_gbot.global_position = Vector2(1642, 0)
	total_parent.add_child(current_gbot)


func _on_teleport_to_begin_pressed() -> void:
	current_gbot.global_position = Vector2(1642, 0)
