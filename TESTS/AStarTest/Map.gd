extends Node2D


export var size = Vector2(16,16)
export (NodePath) var world_tilemap 
export (int, "Blank",  "Random") var map_generation_mode = 0
export (String) var default_road_name = "Road_i1_1"
export (String) var default_grass_name = "Grass"
export (int) var num_grass_tiles = 7

var default_road_id
var tile_set
export var tile_size = 16
var tile_ids_amt
var tile_id_name_lookup = []

var first_run = true
var second_run = false

# Used to control the placement and conection of road tiles
export var road_tile_truth_table = [4, 64, 33, 131, 66, 16, 1, 513,        # Mapped to a binary value based on nieghbor's cardinal placement 
								    32, 128, 8, 256, 128, 513, 258, 1024]  # see included spreead sheet(townsfolk_roads_truth_table.ods) 
export (Array) var road_tile_cypher = ["i1", "s2", "s1", "d2", "d1", "c", "t2", "t1", "j1"]  # Use index 
export (Dictionary) var road_variant_amts = {"i1": 2, "s2": 3, "s1":3, "d2":2, "d1":2, "c":2, "t2":2, "t1":2, "j1":2}
##
# ASTAR VARIABLES
var astar = AStar.new()  # Calculates/stores the path between different weighted points
# Used to quickly reference different info about an astar node and its properties
var astar_id_lookup = {}  # {astar_id: [0:tile_map_pos, 1:tile_type, 2:tile_full_name, 3:tile_world_pos]}
export var tile_weights = {"Grass" : 4,  # Tells the a star alg what weight to set to each tile type
						   "Road"  : 1,
						   "Tile"  : 8}

##
# Random numbers
var rnd = RandomNumberGenerator.new()

# TESTING GENERATION VARIABLES
export var generating = false
var generated = false
onready var testing_timer = $Timer
onready var astar_visualizer = $AstarVisualization
export var line_colors = [Color(0,0,1,1), Color(1,0,0,1)]
var astar_lines = {}

##
# Called when the node enters the scene tree for the first time.
func _ready():
	self.world_tilemap = get_node(world_tilemap)
	print(self.size)
	

##
# Gets a list of the different ideas for each tile in the tileset
func load_tile_ids():
	self.tile_set = world_tilemap.get_tileset()
	
	self.tile_ids_amt = len(tile_set.get_tiles_ids())
	self.default_road_id = tile_set.find_tile_by_name(self.default_road_name)
	
	for i in range(tile_ids_amt):
		self.tile_id_name_lookup.append(tile_set.tile_get_name(i))

##
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# This runs on the second pass after a star has been initialized
	if second_run:
		draw_astar_connections()
		second_run = false 
	
	# Intializes the tiles in the tile map
	if first_run:
		load_tile_ids()
		if map_generation_mode == 0:
			generate_blank_map()
		if map_generation_mode == 1:
			generate_random_map()
		if map_generation_mode == 2:
			pass
		
		first_run = false
		second_run = true
		
	# used to stress test map generation
	if generating:
		if !generated:
			generate_random_map()
			testing_timer.start()
			generated = true
	
	##INPUT HANDLING##
	if Input.is_action_pressed("ui_mouse_right"):
		print("mouse_right_pressed")
		var crnt_mouse_pos = get_global_mouse_position()
		print("######crnt_mouse_pos", crnt_mouse_pos)
		change_tile_to_road(crnt_mouse_pos)
##
# Used to generate a random base map
func generate_random_map():
	for i in range(size.x):
		for j in range(size.y):
			# Set current cell to a random tile
			world_tilemap.set_cell(i, j, rnd.randi_range(0, len(tile_id_name_lookup) - 1))
			
			update_astar(i,j)
	initialize_connections()


##
# Generate a blank map of grass tiles
func generate_blank_map():
	for i in range(size.x):
		for j in range(size.y):
			var rnd_grass_tile = self.default_grass_name
			rnd_grass_tile += ("_" + str(rnd.randi_range(1,self.num_grass_tiles)))
			var rnd_grass_tile_id = tile_set.find_tile_by_name(rnd_grass_tile)
			world_tilemap.set_cell(i, j, rnd_grass_tile_id)

			update_astar(i,j)
	initialize_connections()
##
# Creates the lookup table for astar points 
func update_astar(i,j):
	# Here we intialize the info for the astar id to cell lookup
	var tile_name = tile_id_name_lookup[world_tilemap.get_cell(i,j)].rsplit('_')
	var tile_type = tile_name[0]  # now we get it's type for weight calculations
	var astar_id = tile_map_pos_to_astar_id(i, j)  # Assign the point an id based on its pos
	var tile_coords = world_tilemap.map_to_world(Vector2(i,j)) + Vector2(tile_size/2, tile_size/2) 
	tile_coords = Vector3(tile_coords.x, tile_coords.y, 0)

	# add all information to the lookup dictionary
	self.astar_id_lookup[astar_id] = [Vector2(i,j), tile_type, tile_name, tile_coords]
	#print("Update ", astar_id, self.astar_id_lookup[astar_id])
	# Add new astar entry to lookup dictionary
	astar.add_point(astar_id, tile_coords, tile_weights[tile_type] )

	
##
# Creates the oaths between all the astar points
func initialize_connections():
	# Conects a cell with its valid neighbors.
	for crnt_id in self.astar_id_lookup:
		# THIS WILL NOT WORK RIGHT MUST FIND FIX
		var crnt_pos = self.astar_id_lookup[crnt_id][0]

		var neighbors = get_cell_neighbors(crnt_pos)
		
		for crnt_neighbor in neighbors:
			if crnt_neighbor != null:
				var n_tile_type = self.astar_id_lookup[tile_map_pos_to_astar_id(crnt_pos.x, crnt_pos.y)][1]
				if n_tile_type == "Tile":
					pass
				elif crnt_neighbor.x < 0 || crnt_neighbor.y < 0 || crnt_neighbor.x >= size.x || crnt_neighbor.y >= size.y:
					pass
				elif self.astar_id_lookup[tile_map_pos_to_astar_id(crnt_neighbor.x, crnt_neighbor.y)][1] == "Tile":
					pass
				else:
					astar.connect_points(crnt_id, tile_map_pos_to_astar_id(crnt_neighbor.x,
																		   crnt_neighbor.y))

##
# Output an array of neighbors for a given map position
func get_cell_neighbors(pos, output_ID=false):
	var output = [pos - Vector2(0, 1),    # Top
				  pos + Vector2(1, 0),    # Right
				  pos + Vector2(0, 1),    # Bottom
				  pos - Vector2(1, 0)]    # Left
	
	# Return a null value for out of bound points 
	for i in range(len(output)):
		if output[i].x < 0 || output[i].y < 0 || output[i].x > size.x || output[i].y > size.y:
			output[i] = null
	if output_ID:
		for i in range(len(output)):
			if output[i] != null:
				output[i] = tile_map_pos_to_astar_id(output[i].x, output[i].y)

	return output
##
# Used to toubleshoot/visualize pathfinding bugs
func draw_astar_connections():
	var connections_drawn = []
	if len(self.astar_id_lookup) > 0:
		for crnt_point in self.astar_id_lookup.keys():
			var crnt_connections = astar.get_point_connections(crnt_point)
			var crnt_pos = self.astar_id_lookup[crnt_point][3]

			for crnt_neighbor in crnt_connections:
				var crnt_pair  = [crnt_point, crnt_neighbor]
				crnt_pair.sort()
				if !connections_drawn.has(crnt_pair):
					print("CN:", crnt_neighbor, "CP:", crnt_point, "CC", crnt_connections)
					print(crnt_neighbor, self.astar_id_lookup[crnt_neighbor])
					var crnt_neighbor_pos = self.astar_id_lookup[crnt_neighbor][3]
					connections_drawn.append(crnt_pair)
					self.astar_lines[crnt_pair] = Line2D.new()
					self.astar_lines[crnt_pair].add_point(Vector2(crnt_pos.x, crnt_pos.y))
					self.astar_lines[crnt_pair].add_point(Vector2(crnt_neighbor_pos.x,
																  crnt_neighbor_pos.y))
					if self.astar_id_lookup[crnt_point][1] == "Road" :
						self.astar_lines[crnt_pair].set_default_color(line_colors[1])
					else:
						self.astar_lines[crnt_pair].set_default_color(line_colors[0])
					self.astar_lines[crnt_pair].set_width(1)
					astar_visualizer.add_child(self.astar_lines[crnt_pair])


##
# Translates the map tile's pos to it's correspoding astar point's id
func tile_map_pos_to_astar_id(i,j):
	return int((i * self.size.y) + j) 	
##
# Utility function for adding road tles
func change_tile_to_road(world_pos):
	if world_pos.x >= 0 && world_pos.y >= 0:
		if world_pos.x <= size.x*self.tile_size && world_pos.y <= size.y*self.tile_size:
			# Calculate what kind of road tile to
			var tilemap_pos = world_tilemap.world_to_map(world_pos)
			calculate_road_type(tilemap_pos)
			# Now check if we need to update any neighboring road tiles
			var neighbors = get_cell_neighbors(tilemap_pos)
			for i in neighbors:
				if i != null:
					calculate_road_type(i)

##
# Controls how roads are drawn depending on the neighbors around them.
func calculate_road_type(map_pos):
	var road_type = null
	var flip_x = false 
	var flip_y = false
	var crnt_point = tile_map_pos_to_astar_id(map_pos.x, map_pos.y)
	var neighbors = get_cell_neighbors(map_pos, true)
	var tot = 0

	# Checks to see which neighbors are present and outputs a number based on that  
	for i in range(len(neighbors)):
		if neighbors[i] != null:
			if astar_id_lookup[neighbors[i]][1] == "Road":
				tot += pow(2, i)
	tot = self.road_tile_truth_table[tot]  # Get a precalculated number that lets the 
	
	# Decyphers the bool output into it's tile_type
	var crnt_mask
	for i in range(2,len(self.road_tile_cypher)):
		crnt_mask = tot & int(pow(2, i))
		print(i," | ", pow(2, i),  " & ", tot, " = ", crnt_mask )
		if crnt_mask != 0:
			road_type = road_tile_cypher[i - 2]
			break
	
	# Decyhpher whether tile is flipped 
	if tot & 2 != 0:
		flip_x = true
	if tot & 1 != 0:
		flip_y = true 
	print(road_type)
	# Changes the tile and updates the lookup table
	if road_type != null:
		var new_tile = "Road_"+road_type+"_" # Set to the correct tile type
		new_tile += str(rnd.randi_range(1, self.road_variant_amts[road_type])) # And choose one of it's variations
		print(new_tile, ": ")
		new_tile = tile_id_name_lookup.find(new_tile)
		print(new_tile," | ", tile_id_name_lookup)
		world_tilemap.set_cell(map_pos.x, map_pos.y, new_tile, flip_x, flip_y)
		update_astar(map_pos.x, map_pos.y)

#
#### TEST FUNCTIONS

##
#used with map genertation stress testing
func _on_Timer_timeout():
	generated = false


