extends Node2D

const SPEED = 200            
const LEFT_BOUND = 100       
const RIGHT_BOUND = 700       

var direction = 1          

func _process(delta):

	position.x += SPEED * direction * delta


	if position.x <= LEFT_BOUND:
		position.x = LEFT_BOUND
		direction = 1
	elif position.x >= RIGHT_BOUND:
		position.x = RIGHT_BOUND
		direction = -1


	var ray = $RayCast2D
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit.is_in_group("player"):
			print("Hit player")
			
