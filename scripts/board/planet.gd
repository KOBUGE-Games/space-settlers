extends Node2D

const BObj = preload("res://scripts/core/board_objects.gd")

var planet = null # Planet board object

# Stub for planet (The marker could be a sub scene... or not :) )
func _draw():
	if planet == null:
		return
	
	draw_circle(Vector2(), 12, _get_planet_color(planet.get_resource()))
	draw_circle(Vector2(), 6, _get_mark_color(planet.get_tag().get_type()))

func _get_planet_color(res):
	if res == BObj.RES_METAL: return Color(1,0.2,0.2)
	if res == BObj.RES_GAS: return Color(.6,.6,.3)
	if res == BObj.RES_RATION: return Color(0,.7,0)
	if res == BObj.RES_MINERAL: return Color(0,0,.7)
	if res == BObj.RES_GOLD: return Color(1,0,1)
	return Color(0,0,0,0) # should not happen

func _get_mark_color(type):
	if type == BObj.TAG_SPECIAL: return Color(1,0,0)
	if type == BObj.TAG_NUM_ONE: return Color(.5,.5,.1)
	if type == BObj.TAG_NUM_TWO: return Color(.2,.2,1)
	return Color(1,1,1)
