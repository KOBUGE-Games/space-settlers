
extends TileMap

var basic_coord = [[14,0],[68,0],[96,48],[68,96],[14,96],[-14,48]] # basic coordinates relative to cell
var movable_cell = [] # contains the coordinates of all spots a spaceship can move to
var check_cell = [] # temporary array to check for colony spots
var colony_cell = [] # contains the coordinates of colony spots
var colony_res1 = {} # contains the first resource code of the colony spots
var colony_res2 = {} # contains the second resource code of the colony spots
var color_map = [Color(0,0,1),Color(1,.7,0),Color(0,1,0),Color(.1,.1,.1),Color(1,0,0)] # for testing

func _ready():
	var cell_size = get_cell_size()
	var add_offset
	for cell in get_used_cells():
		var cell_status = get_cell(cell.x,cell.y) # tile number of the cell
		if 0 == (int(cell.x) + 1) % 2:
			add_offset = 1 # add offset for every 2nd column
		else:
			add_offset = 0
		for coord in basic_coord:
			# create the global coordinates of a cell
			var new_coord = Vector2(coord[0],coord[1] + (add_offset * cell_size.y / 2)) + (cell * cell_size)
			
			if (cell_status == 0) and (not (new_coord in movable_cell)):
				movable_cell.append(new_coord) # add movable coordinate
			elif cell_status != 0:
				if not (new_coord in check_cell):
					check_cell.append(new_coord) # coordinate needs to be checked if 2 resources touch it
					colony_res1[new_coord] = cell_status # add the resource code to the coordinate
				else:
					colony_cell.append(new_coord) # coordinate touches 2 resources
					colony_res2[new_coord] = cell_status # add 2nd resource to the coordinate
	update() # draw dots for debugging
	pass

# DEBUG
func _draw():
	for value in movable_cell:
		draw_circle(value,10,Color(1,1,1)) # walkable spot
	for value in colony_cell:
		if value in movable_cell:
			draw_circle(value,7,color_map[colony_res1[value]-1]) # 1st resource
			draw_circle(value,4,color_map[colony_res2[value]-1]) # 2nd resource

