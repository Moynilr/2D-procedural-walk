extends Node2D

@export var footCharacter : CharacterBody2D
@export var footCharacter2 : CharacterBody2D
@export var armTarget : Node2D
@export var walkPathToFollow: PathFollow2D
@export var walkHandPath : Node2D
@export var runPathToFollow: PathFollow2D
@export var runHandPath : Node2D
@export var armOffset: float = 0

@onready var mvtController = $"../../../.."

var restPos = 0.5
var inverse =  true
var isWalking = false
var isRunning = false

var pathToFollow: PathFollow2D
var handPath : Node2D

func ui_set(key: String, value):
	if key=="armOffset" and name=="ArmHandlerL":
		print(name, " offset ", value)
		armOffset = value
	if key=="walk_run":
		isWalking = value
		isRunning = !value
		if isWalking:
			pathToFollow = walkPathToFollow
			handPath = walkHandPath
		else:
			pathToFollow = runPathToFollow
			handPath = runHandPath

func get_pg():
	var footPg = footCharacter.get_target_progress()
	var footPg2 = footCharacter2.get_target_progress()
	if footPg != null:
		if not inverse:
			inverse = true
		return get_indiv_pg(footPg)
	if footPg2 != null:
		if inverse:
			inverse = false
		return get_indiv_pg(footPg2)
	return 0.5
	
func get_indiv_pg(footPg: float):
	if inverse:
		return min(1, footPg)
	return min(1, 1 - footPg)

func _ready() -> void:
	pathToFollow = walkPathToFollow
	handPath = walkHandPath
	await pathToFollow.ready
	await handPath.ready
	await footCharacter.ready
	await footCharacter2.ready

func _physics_process(delta: float) -> void:
	var footPg = get_pg()
	if footPg != null:
		pathToFollow.progress_ratio = footPg
	armTarget.global_position = lerp(armTarget.global_position, handPath.global_position+ Vector2(get_step_sign()*armOffset, 0), 0.2)
	

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func get_a(pos1: Vector2, pos2:Vector2):
	return (pos2.y - pos1.y)/(pos2.x - pos1.x)

func get_b(pos1: Vector2, pos2:Vector2):
	return (pos1.y * pos2.x - pos2.y * pos1.x)/(pos2.x - pos1.x)


func get_step_sign():
	if mvtController.is_heading_right():
		return 1
	else:
		return -1
