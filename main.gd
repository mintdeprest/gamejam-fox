extends Node2D

var terrain_scene = preload("res://floor_base.tscn")
var tree_scene = preload("res://tree.tscn")


func _ready():
	
	var flooring = terrain_scene.instantiate()
	add_child(flooring)
	flooring.set_points(PackedVector2Array([Vector2(-600, 900), Vector2(-600, 540), Vector2(1400, 540), Vector2(1400, 900)]))
	
	var ramp = terrain_scene.instantiate()
	add_child(ramp)
	ramp.set_points(PackedVector2Array([
		Vector2(150, 540),
		Vector2(450, 540),
		Vector2(400, 410),
		Vector2(320, 410),
		Vector2(320, 460),
		Vector2(250, 460),
		Vector2(250, 500),
		Vector2(200, 500),
		Vector2(150, 500)
	]))
	ramp.add_to_group("ledgeable")
	
	
	var tree1 = tree_scene.instantiate()
	add_child(tree1)
	tree1.position = Vector2(930.0, 540.0)
	#tree_branch.scale = Vector2(8.0, 0.5)
	#tree_branch.rotate(- PI / 12.0)
	
	var tree2 = tree_scene.instantiate()
	add_child(tree2)
	tree2.position = Vector2(1120.0, 540.0)
	tree2.get_child(1).frame = 1
	tree2.get_child(1).flip_h = true
	tree2.scale *= 1.1
	tree2.rotate(-PI / 64.0)
	
	
	var wall = terrain_scene.instantiate()
	add_child(wall)
	wall.set_points(PackedVector2Array([Vector2(1250, 400), Vector2(1500, 400), Vector2(1500, 140), Vector2(1250, 140)]))
	wall.add_to_group("ledgeable")
	
	var cave = terrain_scene.instantiate()
	add_child(cave)
	cave.set_points(PackedVector2Array([
	Vector2(165.0 + 1399.0, -233.0 + 773.0),
	Vector2(214.0 + 1399.0, -233.0 + 773.0),
	Vector2(234.0 + 1399.0, -215.0 + 773.0),
	Vector2(262.0 + 1399.0, -204.0 + 773.0),
	Vector2(291.0 + 1399.0, -200.0 + 773.0),
	Vector2(320.0 + 1699.0, -200.0 + 773.0),
	Vector2(319.0 + 1699.0, -195.0 + 773.0),
	Vector2(313.0 + 1649.0, -189.0 + 773.0),
	Vector2(312.0 + 1639.0, -183.0 + 773.0),
	Vector2(301.0 + 1629.0, -176.0 + 773.0),
	Vector2(294.0 + 1599.0, -157.0 + 773.0),
	Vector2(282.0 + 1599.0, -128.0 + 773.0),
	Vector2(273.0 + 1599.0, -49.0 + 773.0),
	Vector2(272.0 + 1599.0, -17.0 + 973.0),
	Vector2(272.0 + 1599.0, -8.0 + 973.0),
	Vector2(272.0 + 1599.0, -4.0 + 973.0),
	Vector2(1.0 + 1399.0, -1.0 + 973.0),
	Vector2(1.0 + 1399.0, -233.0 + 773.0),
	Vector2(89.0 + 1399.0, -233.0 + 773.0),
	Vector2(120.0 + 1399.0, -250.0 + 773.0),
	Vector2(165.0 + 1399.0, -250.0 + 773.0),
]))
	
