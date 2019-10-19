extends Node2D


export var size = Vector2(16,16)
export (NodePath) var world_tilemap 
var tile_set
var tile_ids_amt
var tile_id_name_lookup = []

var first_run = true



# used to control the placement and conection of road tiles
export var road_tile_truth_table = { 0: 0,
								1:	264,
								2:	260,
								3:	34,
								4:	264,
								5:	136,
								6:	36,
								7:	24,
								8:	260,
								9:	33,
								10:	132,
								11:	20,
								12:	40,
								13:	18,
								14:	17,
								15:	72}

#
# ASTAR VARIABLES
var astar = AStar.new()
var astar_id_lookup = {}
export var tile_weights = {"Grass" : 4,
						   "Road"  : 1,
							"Tile" : 8}

##
# Random numbers
var rnd = RandomNumberGenerator.new()


#TESTING GENERATION VARIABLES
export var generating = false
var generated = false
onready var testing_timer = $Timer


#
# Called when the node enters the scene tree for the first time.
func _ready():
	self.world_tilemap = get_node(world_tilemap)
	print(self.size)
	


func load_tile_ids():
	self.tile_set = world_tilemap.get_tileset()
	self.tile_ids_amt = len(tile_set.get_tiles_ids())
	
	for i in range(tile_ids_amt):
		self.tile_id_name_lookup.append(tile_set.tile_get_name(i))
		#print(i,":", self.tile_id_name_lookup[i])

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_run:
		load_tile_ids()
		first_run = false
		generate_random_map()

		

	if generating:
		if !generated:
			generate_random_map()
			testing_timer.start()
			generated = true
		

func _on_Timer_timeout():
	generated = false


func generate_random_map():
	for i in range(size.x):
		for j in range(size.y):
			world_tilemap.set_cell(i, j, rnd.randi_range(0, len(tile_id_name_lookup) - 1))
			var tile_type = tile_id_name_lookup[world_tilemap.get_cell(i,j)].rsplit('_')
			print(tile_type)
			tile_type = tile_type[0]
			var astar_id = i*size.y + j
			var tile_coords = world_tilemap.map_to_world(Vector2(i,j))
			self.astar_id_lookup[astar_id] = Vector2(i,j)
			tile_coords = Vector3(tile_coords.x, tile_coords.y, 0)
			astar.add_point(astar_id, tile_coords, tile_weights[tile_type] )
	initialize_connections()

func initialize_connections():
	for crnt_id in self.astar_id_lookup:
		var neighbors = [crnt_id - size.y,  # Top
					 	 crnt_id + 1,       # Right
					 	 crnt_id + size.y,  # Bottom
					  	 crnt_id - 1        # Left
					]
		
		for crnt_neighbor in neighbors:
			if crnt_neighbor<0 || crnt_neighbor> size.y:
				pass
			else:
				astar.connect_points(crnt_id, crnt_neighbor)