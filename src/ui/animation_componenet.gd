class_name AnimationComponent extends Node

@export_group("Options")
@export var from_center : bool = true
@export var parallel_animation: bool = true
@export var properties :Array = [
	"scale",
	"position",
	"rotation",
	"size",
	"self_modulate"
]


@export_group("Hover Settings")
@export var hover_time : float = 0.1
@export var hover_transition: Tween.TransitionType
@export var hover_easing : Tween.EaseType
@export var hover_scale : Vector2 = Vector2(1, 1)
@export var hover_position : Vector2 = Vector2.ZERO
@export var hover_rotation : float = 0
@export var hover_size : Vector2 = Vector2.ZERO
@export var hover_modulate : Color = Color.WHITE

var target : Control
var default_scale : Vector2
var default_values: Dictionary
var hover_values: Dictionary

func _ready() -> void:
	target  = get_parent()
	call_deferred("setup")

func connect_signals() -> void:
	target.mouse_entered.connect(add_tween.bind(
		hover_values,
		parallel_animation,
		hover_time,
		hover_transition,
		hover_easing
	))
	target.mouse_exited.connect(add_tween.bind(
		default_values,
		parallel_animation,
		hover_time,
		hover_transition,
		hover_easing
	))

func setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	default_values = {
	"scale": target.scale,
	"position": target.position,
	"rotation": target.rotation,
	"size" : target.size,
	"self_modulate": target.self_modulate
	}
	hover_values = {
	"scale": hover_scale,
	"position": target.position + hover_position,
	"rotation": target.rotation + deg_to_rad(hover_rotation),
	"size" : target.size + hover_size,
	"self_modulate": hover_modulate
	}
	connect_signals()

func add_tween(values: Dictionary, parallel: bool, seconds: float,\
 transistion: Tween.TransitionType, easing: Tween.EaseType) -> void:
	if get_tree() == null:
		return
	var tween = get_tree().create_tween()
	#tween.tween_property(target, property, value, seconds).set_trans(transition_type)
	tween.set_parallel(parallel)
	for property in properties:
		tween.tween_property(target, str(property), values[property], seconds).set_trans(transistion).set_ease(easing)
