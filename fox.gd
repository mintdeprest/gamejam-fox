extends CharacterBody2D

const SPEED = 200
const GRAVITY = 1000
const JUMP_VELOCITY = -400
const COOLDOWN_TIMER = 0.2
const PUSH_FORCE = 1500
const MAX_POUNCE_CHARGE = 1.0
const MIN_POUNCE_FORCE = -400
const MAX_POUNCE_FORCE = -700
const SHORT_PRESS_THRESHOLD = 0.15


var can_hide = false
var hiding = false
var is_charging_pounce = false
var pounce_charge = 0.0

@onready var sprite = get_child(1)
@onready var collision_block = get_child(0)
@onready var ray = $RayCast2D



var time_since_ground = 0.0

func _physics_process(delta):

	var input_direction = Input.get_axis("left", "right")
	velocity.x = move_toward(velocity.x, input_direction * SPEED, 20.0)
	
	if hiding:
		velocity = Vector2.ZERO
	
	if input_direction != 0:
		ray.scale.x = sign(input_direction)
		sprite.play("default")
		sprite.flip_h = input_direction < 0
	else:
		sprite.play("idle")
		sprite.pause()


	# collision checks
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("pushable"):
			if collider is RigidBody2D:
				var push_dir = Vector2(sign(input_direction), 0)
				collider.apply_force(push_dir * PUSH_FORCE, ray.get_collision_point() - collider.global_position)


	if not is_on_floor():
		velocity.y += GRAVITY * delta
		time_since_ground += delta
	else:
		time_since_ground = 0

		# jump charge
		if Input.is_action_pressed("jump"):
	
			is_charging_pounce = true
			pounce_charge = clamp(pounce_charge + delta, 0.0, MAX_POUNCE_CHARGE)

		elif Input.is_action_just_released("jump") and is_charging_pounce:
			if pounce_charge < SHORT_PRESS_THRESHOLD:
				velocity.y = JUMP_VELOCITY  # jump
			else:
				var charge_ratio = pounce_charge / MAX_POUNCE_CHARGE
				var pounce_force = lerp(MIN_POUNCE_FORCE, MAX_POUNCE_FORCE, charge_ratio)
				velocity.y += pounce_force / 2.0 * sqrt(3.0)
				velocity.x -= pounce_force * input_direction / 2.0

			is_charging_pounce = false
			pounce_charge = 0.0


	if hiding:
		# blah blah
		if input_direction != 0:
			hiding = false
			sprite.visible = true
			collision_block.disabled = false
			position.y -= 5.0

	if can_hide:
		if Input.is_action_just_pressed("down"):
			sprite.visible = false
			collision_block.disabled = true
			hiding = true


	move_and_slide()
	velocity.x = move_toward(velocity.x, 0.0, 2.0)
	if velocity.y < 0:
		velocity.y = move_toward(velocity.y, 0.0, 5.0)
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		can_hide = true
		
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == self:
		can_hide = false
