extends Node2D


export var size = Vector2(16,16)
export (NodePath) var world_tilemap 
var tile_ids

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

var astar = AStar.new()
var map_array = []


# Random numbers
var rnd = RandomNumberGenerator.new()


#TESTING GENERATION VARIABLES
var generated = false
onready var testing_timer = $Timer


#
# Called when the node enters the scene tree for the first time.
func _ready():
	self.world_tilemap = get_node(world_tilemap)
	print(self.size)
	


func load_tile_ids():
	self.tile_ids = self.world_tilemap.get_tileset().get_tiles_ids()
	print("###################")
	print("###TILE IDS####")
	print(self.tile_ids)
	print("###################")

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_run:
		load_tile_ids()
		first_run = false

	if !generated:
		generate_random_map()
		testing_timer.start()
		generated = true
		

func _on_Timer_timeout():
	generated = false

func generate_random_map():
	for i in range(size.x):
		for j in range(size.y):
			world_tilemap.set_cell(i, j, tile_ids[rnd.randi_range(0, len(tile_ids) - 1)])
