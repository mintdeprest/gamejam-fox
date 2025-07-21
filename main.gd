extends Node2D

var wall_scene = preload("res://floor_base.tscn")

func _ready():
	var flooring = wall_scene.instantiate()
	add_child(flooring)
	flooring.scale.x = 40.0
	flooring.position = Vector2(400.0, 600.0)
	
	var wall = wall_scene.instantiate()
	add_child(wall)
	wall.position = Vector2(600.0, 540.0)
	wall.scale = Vector2(10.0, 5.0)
	
	
	
