extends Node2D

const Board = preload("res://scripts/core/board.gd")

var _board = Board.new()
var _paths = []
var _stars = []
var _planets = []

func _ready():
	_board.setup_board()
	_paths = _board.get_paths()
	_stars = _board.get_stars()
	_planets = _board.get_planets()
	update()

func _draw():
	var offset = Vector2(20,20)
	var size = Vector2(45,45*sin(deg2rad(60)))
	for k in _paths:
		var loc = _paths[k]
		draw_circle(loc.get_pos() * size + offset, 3, Color(1,0,0))
		for a in loc.get_adj(_paths):
			draw_line(loc.get_pos() * size + offset, a.get_pos() * size + offset, Color(0,0,1), 2.0)
	for k in _stars:
		var star = _stars[k]
		draw_circle(star.get_pos() * size + offset, 8, Color(.7,.8,.3))

	for k in _planets:
		var planet = _planets[k]
		draw_circle(planet.locations[1].get_pos() * size + offset, 8, Color(0,1,1))
		draw_circle(planet.locations[2].get_pos() * size + offset, 8, Color(0,1,1))
		draw_circle(planet.get_pos() * size + offset, 12, get_planet_color(planet.res))
		draw_circle(planet.get_pos() * size + offset, 6, get_mark_color(planet.tag.type))

func get_mark_color(type):
	if type == 4: return Color(1,0,0)
	if type == 5: return Color(.5,.5,.1)
	if type == 6: return Color(.2,.2,1)
	return Color(1,1,1)

func get_planet_color(res):
	if res == 0: return Color(1,0.2,0.2)
	if res == 1: return Color(.6,.6,.3)
	if res == 2: return Color(0,.7,0)
	if res == 3: return Color(0,0,.7)
	if res == 4: return Color(1,0,1)
	return Color(0,0,0,0) # should not happen