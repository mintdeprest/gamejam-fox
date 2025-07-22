extends CharacterBody2D

var fox = Vector2.ZERO
var fox_ref
const SPEED = 20

func _ready():
	global_position = Vector2(100.0, 100.0)


func initialize(target):
	fox = target.global_position
	fox_ref = target

func _process(delta: float) -> void:
	if fox_ref:
		fox = fox_ref.position
	if global_position.distance_squared_to(fox) > 1.0:
		global_position = global_position.lerp((fox * 0.9), 0.01)
