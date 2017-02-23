extends Node2D

var star = null # Star board object... err.. actually a location for now since it's probably enough

# Stub for star
func _draw():
	if star == null:
		return

	draw_circle(Vector2(0,0),8,Color(.7,.8,.3))