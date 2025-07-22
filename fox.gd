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

var can_climb = false
var can_hide = false
var hiding = false
var is_charging_pounce = false
var pounce_charge = 0.0
var climbing = false
var ledge_grabbed = false
var ledge_position = Vector2.ZERO


@onready var sprite = get_child(1)
@onready var collision_block = get_child(0)
@onready var ray = $RayCast2D
@onready var ledge_check = $ledgeCast


var time_since_ground = 0.0

func _physics_process(delta):
	
	if ledge_check.is_colliding():
		ledge_grabbed = false
	if ledge_grabbed:
		velocity = Vector2.ZERO
		#global_position = global_position.move_toward(ledge_position, 4.0)
		if Input.is_action_just_pressed("jump"):
			ledge_grabbed = false
			velocity = Vector2(0, -400)
		elif Input.is_action_just_pressed("down"):
			ledge_grabbed = false
			ledge_check.set_enabled(false)
			await get_tree().create_timer(0.25).timeout
			ledge_check.set_enabled(true)
		pass
	
	var input_direction = Input.get_axis("left", "right")
	velocity.x = move_toward(velocity.x, input_direction * SPEED, 20.0)
	
	if input_direction != 0:
		ray.scale.x = sign(input_direction)
		ledge_check.scale.x = sign(input_direction)
		sprite.play("default")
		sprite.flip_h = input_direction < 0
	else:
		sprite.play("idle")
		sprite.pause()


		
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("pushable"):
			if collider is RigidBody2D:
				var push_dir = Vector2(sign(input_direction), 0)
				collider.apply_force(push_dir * PUSH_FORCE, ray.get_collision_point() - collider.global_position)
		elif !is_on_floor() and velocity.y > 0 and collider.is_in_group("ledgeable"):
			if not ledge_grabbed and ledge_check.is_enabled() and ledge_check.is_colliding() == false:
				start_ledge_grab()


	if not is_on_floor() and not climbing:
		velocity.y += GRAVITY * delta
		time_since_ground += delta
	else:
		time_since_ground = 0

		# jump charge
		if Input.is_action_pressed("jump"):
			is_charging_pounce = true
			pounce_charge = clamp(pounce_charge + delta, 0.0, MAX_POUNCE_CHARGE)
			
			

		elif Input.is_action_just_released("jump") and is_charging_pounce:
			climbing = false
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

	if can_hide:
		if Input.is_action_just_pressed("down"):
			sprite.visible = false
			# collision_block.disabled = true
			hiding = true
	
	if can_climb:
		if Input.is_action_just_pressed("up"):
			climbing = true
	
	if climbing:
		
		position.y += 3.0 * Input.get_axis("up", "down")
			
	
	if hiding:
		velocity = Vector2.ZERO
		
	
	move_and_slide()
	velocity.x = move_toward(velocity.x, 0.0, 2.0)
	if velocity.y < 0:
		velocity.y = move_toward(velocity.y, 0.0, 5.0)
	


func start_ledge_grab():
	ledge_grabbed = true
	ledge_position = global_position + Vector2(1, -5)
	if !ledge_check.is_colliding():
		velocity = Vector2.ZERO
	





func _on_interaction_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("hideable"):
		can_hide = true
	elif area.is_in_group("climable"):
		can_climb = true




func _on_interaction_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("hideable"):
		can_hide = false
		hiding = false
	elif area.is_in_group("climable"):
		can_climb = false
		climbing = false
