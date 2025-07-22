extends StaticBody2D

@onready var polygon = $Polygon2D
@onready var collision = $CollisionPolygon2D

func set_points(points: PackedVector2Array):
	polygon.polygon = points
	collision.polygon = points
