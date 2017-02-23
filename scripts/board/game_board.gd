extends Node2D

const Board = preload("res://scripts/core/board.gd")

# These are the graphic nodes that will handle the board objects.
# Modify them to modify the look and feel of stars, planets, locations, etc
const GameStar = preload("res://scenes/board/star.tscn")
const GamePlanet = preload("res://scenes/board/planet.tscn")
const GameLocation = preload("res://scenes/board/location.tscn")

# Offset from 0,0
var _offset = Vector2(20,20)

# Size of each row and column of the locations grid.
# Note: it's a grid of vertexes. For this reason, regular hexagons are
#       not posible right now. This could be fixed with some math in
#       Location.get_pos() and Planet.get_pos()
var _size = Vector2(45,45*sin(deg2rad(60)))

# Board data
var _board = Board.new()
var _paths = []
var _stars = []
var _planets = []

# Object layers
onready var _planets_layer = get_node("Planets")
onready var _paths_layer = get_node("Locations")
onready var _stars_layer = get_node("Stars")

func _ready():
	_board.setup_board()
	_paths = _board.get_paths()
	_stars = _board.get_stars()
	_planets = _board.get_planets()

	# Populate stars
	for k in _stars:
		var star = _stars[k]
		var node = GameStar.instance()
		node.set_pos(star.get_pos() * _size + _offset)
		node.star = star
		_stars_layer.add_child(node)

	# Populate planets
	for k in _planets:
		var planet = _planets[k]
		var node = GamePlanet.instance()
		node.set_pos(planet.get_pos() * _size + _offset)
		node.planet = planet
		_planets_layer.add_child(node)

	# Populate locations
	for k in _paths:
		var loc = _paths[k]
		var node = GameLocation.instance()
		node.set_pos(loc.get_pos() * _size + _offset)
		node.location = _paths[k]
		_paths_layer.add_child(node)

	update()

# We could use a TileMap for the grid after some fun time with Math, but I think it's low priority.
func _draw():
	for k in _paths:
		var loc = _paths[k]
		for a in loc.get_adj(_paths):
			draw_line(loc.get_pos() * _size + _offset, a.get_pos() * _size + _offset, Color(0,0,1), 2.0)
