extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D


const SPEED = 20


var fox = Vector2.ZERO
var fox_ref


var start_point = Vector2.ZERO
var end_point = Vector2.ZERO
var bl_control = Vector2.ZERO
var br_control = Vector2.ZERO


var going_right = true
var t = 0.0
var screen

func _ready():
	global_position = Vector2(-50.0, -50.0)
	screen = get_viewport_rect()
	get_bezier_info()

func initialize(target):
	fox_ref = target
	fox = target.global_position

func _process(delta: float) -> void:
	if fox_ref:
		fox = fox_ref.global_position


	global_position = start_point.bezier_interpolate(bl_control, br_control, end_point, t / 2.0)
	t += delta


	#var next_pos = start_point.bezier_interpolate(bl_control, br_control, end_point, min((t + 0.1) / 2.0, 1.0))
	#var direction = (next_pos - global_position).normalized()
	


	if t >= 2.0:
		await get_tree().create_timer(1.5).timeout
		t = 0.0
		going_right = !going_right
		get_bezier_info()

func get_bezier_info():
	
	var swoop_depth = 200
	var above_fox = fox - Vector2(0.0, swoop_depth)

	if going_right:
		global_position = Vector2(-100, -50)
		end_point = Vector2(screen.size.x + 100, -50) 
		bl_control = Vector2(screen.position.x, above_fox.y)
		br_control = Vector2(screen.end.x, above_fox.y)
		sprite.flip_h = true
		sprite.flip_v = true
		sprite.global_rotation = (7.0 * PI / 6.0)
	else:
		global_position = Vector2(screen.size.x + 100, -50) 
		end_point = Vector2(-100, -50)  
		bl_control = Vector2(screen.end.x, above_fox.y)
		br_control = Vector2(screen.position.x, above_fox.y)
		sprite.global_rotation = (5.0 * PI / 6.0)
		sprite.flip_h = false
	start_point = global_position
