extends Reference

const BObj = preload("res://scripts/core/board_objects.gd")
const PTag = BObj.PTag
const Location = BObj.Location
const Planet = BObj.Planet

# Walkable paths on the grid
var _paths = {}
# Location of the stars, those locations are not walkable and spawn planets around
var _stars = {}
# Planet informations. Have their own random ids
var _planets = {}
# All tag markers
var _tags = {}

func get_paths():
	return _paths

func get_stars():
	return _stars

func get_planets():
	return _planets

func setup_board(size=Vector2(31,24), star_config=BObj.DEF_STAR_CFG, marker_cfg=BObj.DEF_MARKER_CFG):
	# FIXME Should shuffle markers!

	# Populate tags/markers from config
	for k in marker_cfg:
		var m = marker_cfg[k]
		_tags[k] = create_tags(m.nums, m.tag)

	# Stars
	for s in star_config:
		_stars[Location.get_id_for(s[0],s[1])] = Location.new(s[0],s[1])

	# Setup as grid of vertexes (with holes)
	var max_x = 31
	var max_y = 24
	for y in range(0,max_y):
		# Detect if we need to pick vertexes at even or odd X locations
		var even = false
		var temp_y = y
		if y % 2 != 0:
			temp_y += 1
		if y == 0 or (temp_y / 2) % 2 == 0:
			even = true

		for x in range(0,max_x):
			# Exclude as detected above
			if even != x % 2 == 0:
				continue
			# The first X for first and last column is missing
			if x == 0 and (y == 0 or y == max_y-1):
				continue
			# In the original map the first and last two rows only have locations for column 0 to 5
			if (y < 2 or y > max_y - 3) and x > 5:
				continue

			var id = Location.get_id_for(x,y)
			if _stars.has(id):
				continue

			_paths[Location.get_id_for(x,y)] = Location.new(x,y)

	# Setup planets
	for i in range(0,_stars.size()):
		var s = _stars[Location.get_id_for(star_config[i][0],star_config[i][1])]
		var tag_type = star_config[i][2]
		var res_type = star_config[i][3]
		if i > 3:
			var tn = i-4
			create_planet(s, 0, res_type[0], _tags[tag_type[0]][tn])
			create_planet(s, 1, res_type[1], _tags[tag_type[1]][tn])
			create_planet(s, 2, res_type[2], _tags[tag_type[2]][tn])
		else:
			create_planet(s, 0, res_type[0], _tags[tag_type[0]][0])
			create_planet(s, 1, res_type[1], _tags[tag_type[1]][1])
			create_planet(s, 2, res_type[2], _tags[tag_type[2]][2])

func create_planet(star, pnum, res, tag):
	assert(pnum < 3)
	var id = randi()
	var adj = star.get_adj(_paths) # I know, can be optimized, but it's done once, who cares! I prefer clarity
	var locs = [star]
	locs.append(adj[pnum])
	if pnum+1 >= adj.size():
		locs.append(adj[0])
	else:
		locs.append(adj[pnum+1])
	_planets[id] = Planet.new(id, tag, res, locs) # FIXME Randomize

static func create_tags(numbers, type):
	var out = []
	var hidden = true
	for n in numbers:
		if type == BObj.TAG_SPECIAL:
			out.append(PTag.new(n[0], type, n[1]))
		else:
			out.append(PTag.new(n, type))
	return out
