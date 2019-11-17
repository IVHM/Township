extends Node2D


# OBJECT IMPORT VARIABLES 
export (String, DIR) var objects_filepath  = "null"

var object_lookup = {}  # Associates a key with a given activated node ie {"barrels": BarrelNode}


# OBJECT HANDLING VARIABLES
var world_objects_database = {} # contains all the different objects that have been placed on the map
var w_o_d_key = []  # used to look up  objects at a specific location ie {Vector(0,0): [BarrelObject0023, CandleObject0013]}


## TESTING VARIABLES
export (bool) var testing = false
export (bool) var t_print = false  # toggles test printing on and off
export (String, "null", "Barrel") var test_object = "null"
export (Vector2) var test_position = Vector2(50,50)
var test_ID = UTIL.map_pos_to_id(test_position)

##
# First call intializations
func _ready():
	if t_print: print("OBJECTHANDLER INTIALIZED ##################")

	for i in GLOBALS.OBJECTS_DATABASE:
		object_lookup[i] = load(objects_filepath + i + ".tscn")
		print(object_lookup)
		

	# TESTING
	if testing:
		create_item(test_object, test_position, self)
		print("world_pos_to_id test", UTIL.world_pos_to_id(test_position))

##
# Adds a new item to the map
func create_item(item, pos, owner):
	var map_pos = UTIL.world_pos_to_map(pos)
	var new_id = UTIL.map_pos_to_id(map_pos)  
	var cell_pos = 0  # Where on the cell stack the item is

	# Checks whether this cell has other objects in it
	if new_id in world_objects_database.keys():
		cell_pos = len(world_objects_database[new_id])
		world_objects_database[new_id].append(object_lookup[item].instance())
	
	# If not creates a new array to stack items in
	else:
		world_objects_database[new_id] = [object_lookup[item].instance()]
	
	# Then setup the parameters of the node and intialize the object
	world_objects_database[new_id][cell_pos].set_position(pos)
	world_objects_database[new_id][cell_pos].set_cell_id(new_id)
	world_objects_database[new_id][cell_pos].set_cell_pos(cell_pos)
	# Before parenting to handler for display
	self.add_child(world_objects_database[new_id][cell_pos])
	

##
# Moves an existing item returns false if illeagal move
func move_item(item, cell_id, cell_pos, new_pos):##### TO DO ######
	pass


##
# Returns the contents of a specific cell
func check_cell(i, j=null, world_pos=false):
	var cell_id = null
	if j == null:
		j = i.y
		i = i.x
	if world_pos:
		cell_id = UTIL.world_pos_to_id(i,j)
	else:
		cell_id = UTIL.map_pos_to_id(i,j)
	
	if cell_id in world_objects_database.keys():
		return world_objects_database[cell_id]
	else:
		return null



##
# Used to track changes to the objects on the map for easier reference
func update_object_database():
	pass