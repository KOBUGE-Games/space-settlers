extends Node2D

var location = null # Location board object

# Stub for locations
func _draw():
	if location == null:
		return

	var c = Color(1,0,0)
	if location.is_terminal():
		c = Color(0,1,1)
	
	draw_circle(Vector2(0,0),4,c)