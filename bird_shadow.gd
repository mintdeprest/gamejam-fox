extends Node2D

const SPEED = 200            
const LEFT_BOUND = 100       
const RIGHT_BOUND = 700       

var direction = 1          
@onready var bird_spawn = preload("res://bird.tscn")
var attacking = false


func _process(delta):

	position.x += SPEED * direction * delta


	if position.x <= LEFT_BOUND:
		position.x = LEFT_BOUND
		direction = 1
	elif position.x >= RIGHT_BOUND:
		position.x = RIGHT_BOUND
		direction = -1

	if !attacking:
		var ray = $RayCast2D
		if ray.is_colliding():
			var hit = ray.get_collider()
			if hit.is_in_group("player"):
				var attack_bird = bird_spawn.instantiate()
				add_sibling(attack_bird)
				attack_bird.initialize(hit)
				attack_bird.position = position
				attacking = true
				
		
