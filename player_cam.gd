extends Camera2D

@onready var player = $"../fox"
@onready var background = $Node2D


func _ready():
	if player:
		position = player.position
	background.scale = get_viewport_rect().size / Vector2(1481, 601) 

func _physics_process(delta: float) -> void:
	if player:
		position = position.lerp(player.position + Vector2(0.0, -100), 0.1)
	background.global_position = global_position
