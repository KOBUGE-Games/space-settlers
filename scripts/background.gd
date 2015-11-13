
extends Node2D

class Star:
	var bounds
	var texture
	var modulate
	func _init(b, t, m):
		bounds = b
		texture = t
		modulate = m

export(Texture) var texture_star_small
export(Texture) var texture_star_big
export(Texture) var texture_nebula
export(Rect2) var bounds = Rect2(0,0,800,600)
export(ColorArray) var colors_small
export(ColorArray) var colors_big
export(ColorArray) var colors_nebula
export var count_small = 64
export var count_big = 10
export var count_nebula = 64

var stars = []

func _draw():
	for star in stars:
		draw_texture_rect( star.texture, star.bounds, false, star.modulate)

func _ready():
	randomize()
	regenerate()

func regenerate():
	stars=[]
	generate_stars(bounds, count_nebula, texture_nebula, colors_nebula)
	generate_stars(bounds, count_small, texture_star_small, colors_small)
	generate_stars(bounds, count_big, texture_star_big, colors_big)
	update()

func generate_stars(bounds, count, texture, colors):
	var size = texture.get_size()
	bounds.pos -= size/2
	bounds.size += size
	for i in range(count):
		var position = Vector2(randf(), randf()) * (bounds.size) + bounds.pos
		var rect = Rect2(position, size * lerp(0.5,1,randf()))
		var color = Color(1,1,1)
		if colors.size() > 0:
			color = colors[randi() % colors.size()].linear_interpolate(colors[randi() % colors.size()], randf())
		stars.push_back(Star.new(rect, texture, color))
