extends Reference

# Resources
enum {RES_METAL, RES_GAS, RES_RATION, RES_MINERAL, RES_GOLD}

# Planet Tag requirements
enum {REQ_NONE, REQ_WEALTH, REQ_STRENGTH, REQ_SPEED}

# Planet Tag types
enum {TAG_START_A, TAG_START_B, TAG_START_C, TAG_START_D, TAG_SPECIAL, TAG_NUM_ONE, TAG_NUM_TWO, TAG_REPLACE}

# Ship type
enum {SHIP_TERRAFORMER, SHIP_COLONY, SHIP_CARGO, SHIP_EMBASSY}

# Default game star configuration (could be replaced to have different maps)
const DEF_STAR_CFG = [
	[2,3, [TAG_START_A,TAG_START_A,TAG_START_A], [RES_RATION,RES_GAS,RES_MINERAL]], # Alpha
	[2,8, [TAG_START_B,TAG_START_B,TAG_START_B], [RES_GAS,RES_GOLD,RES_METAL]], # Beta
	[2,15, [TAG_START_C,TAG_START_C,TAG_START_C], [RES_METAL,RES_MINERAL,RES_RATION]], # Gamma
	[2,20, [TAG_START_D,TAG_START_D,TAG_START_D], [RES_GOLD, RES_METAL, RES_GAS]], # Delta
	[9,5, [TAG_SPECIAL,TAG_NUM_ONE,TAG_NUM_TWO], [RES_RATION, RES_METAL, RES_GAS]],
	[9,17, [TAG_SPECIAL,TAG_NUM_ONE,TAG_NUM_TWO], [RES_GAS, RES_MINERAL, RES_RATION]],
	[13,10, [TAG_NUM_ONE,TAG_NUM_TWO,TAG_SPECIAL], [RES_RATION,RES_GOLD,RES_MINERAL]],
	[19,14, [TAG_SPECIAL,TAG_NUM_ONE,TAG_NUM_TWO], [RES_GOLD,RES_GAS,RES_METAL]],
	[21,6, [TAG_SPECIAL,TAG_NUM_ONE,TAG_NUM_TWO], [RES_METAL,RES_GOLD,RES_MINERAL]],
	[28,8, [TAG_NUM_ONE,TAG_SPECIAL,TAG_NUM_TWO], [RES_MINERAL,RES_GOLD,RES_GAS]],
	[28,19, [TAG_NUM_TWO,TAG_NUM_ONE,TAG_SPECIAL], [RES_GOLD,RES_RATION,RES_METAL]]
]

# Default game tags configuration (could be replaced to have different maps)
const DEF_MARKER_CFG = {
	TAG_START_A: {"nums": [4, 8, 11], "tag": TAG_START_A},
	TAG_START_B: {"nums": [8, 10, 12], "tag": TAG_START_B},
	TAG_START_C: {"nums": [3, 5, 6], "tag": TAG_START_C},
	TAG_START_D: {"nums": [2, 6, 9], "tag": TAG_START_D},
	TAG_SPECIAL: {"nums": [[4, REQ_STRENGTH], [5, REQ_STRENGTH], [7, REQ_STRENGTH], [3, REQ_WEALTH], [4, REQ_WEALTH], [10, REQ_NONE], [10, REQ_NONE]], "tag": TAG_SPECIAL},
	TAG_NUM_ONE: {"nums": [2, 5, 5, 6, 8, 9, 9], "tag": TAG_NUM_ONE},
	TAG_NUM_TWO: {"nums": [3, 3, 4, 4, 11, 11, 12], "tag": TAG_NUM_TWO},
	TAG_REPLACE: {"nums": [2, 3, 4, 10, 11], "tag": TAG_REPLACE},
}

# Planet tags/markers. Has a number, a backtype, an optional requirement, and an hidden/shown state
class PTag extends Reference:
	var number = 1
	var requirement = REQ_NONE
	var type = TAG_START_A
	var hidden = true

	func _init(number, type, req=REQ_NONE):
		self.number = number
		self.type = type
		self.requirement = req

# A Planet. Holds the id, resource, tag, and connected locations
# It also comes with an handy function to get the center of the hexagon
# it's supposed to be in
class Planet extends Reference:
	var id = 0
	var res = RES_METAL
	var tag = null
	var locations = []

	func _init(id, tag, resource, locations):
		self.id = id
		self.tag = tag
		self.res = resource
		self.locations = locations

	func get_pos():
		var s = locations[0].get_pos()
		var p1 = locations[1].get_pos()
		var p2 = locations[2].get_pos()
		var out = s - ((s - p1) + (s - p2))
		if locations[0].is_northface():
			out.y -= .5
		else:
			out.y += .5
		return out


# Locations are vertexes of the exagons.
# They can have an occupant.
# Not all x,y combination are valid vertexes, check Board.setup_board() for details
class Location extends Reference:
	var x = 0
	var y = 0
	var occupant = null

	func _init(x,y,occpant=null):
		self.x = x
		self.y = y
		self.occupant = occupant

	# Return x,y as vector
	func get_pos():
		return Vector2(x,y)

	# Return true if the vertex "facing is north".
	#          |           \ /
	# north = / \, south =  |
	func is_northface():
		return y % 2 == 0

	func get_id():
		return get_id_for(x,y)

	static func get_id_for(x,y):
		return str(x) + "-" + str(y)

	# Return adjacent locations that are present in the given map
	func get_adj(map):
		var adj = []
		# DO NOT CHANGE ORDER. WOULD BREAK STAR CONFIG
		if is_northface():
			_add_if_exists(adj, map, get_id_for(x,y-1))
			_add_if_exists(adj, map, get_id_for(x+1,y+1))
			_add_if_exists(adj, map, get_id_for(x-1,y+1))
		else:
			_add_if_exists(adj, map, get_id_for(x-1,y-1))
			_add_if_exists(adj, map, get_id_for(x+1,y-1))
			_add_if_exists(adj, map, get_id_for(x,y+1))
		return adj

	func _add_if_exists(list, map, id):
		if map.has(id):
			list.append(map[id])

# A ship, not implemented yet
class Ship extends Reference:
	var type = SHIP_TERRAFORMER

	func _init(team, type=SHIP_TERRAFORMER):
		self.team = team
		self.type = type

# A team, not implemented yet
class Team extends Reference:
	var honor = 0
	var resources = {
		RES_MINERAL: 0,
		RES_GAS: 0,
		RES_RATION: 0,
		RES_METAL: 0,
		RES_GOLD: 0,
	}

	func add_res(res):
		assert(resources.has(res))
		resources[res] += 1
