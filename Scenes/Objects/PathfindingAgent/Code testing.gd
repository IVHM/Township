extends Node2D

export (NodePath) var Follower
export (NodePath) var StuckTimer

#### MOVEMENT BEHAVIOR VARIABLES
export var start_pos = Vector2(16,16)
var moving = false
var point_array # This holds the list of vectors that make up the curve
var crnt_point = 0 # The index of the point we are going from
var dest_point = 4 # the index of the next point in the curve



#### Testing
export (NodePath) var test_map
export (NodePath) var PathViz 
export var testing = false
export var t_print = false
export (Vector2) var test_dest = Vector2(200,200)
var first_run = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Follower = get_node(Follower)
	Follower.set_position(start_pos)

	if t_print: print("intial load done")
	if testing:
		PathViz = get_node(PathViz)
		test_map = get_node(test_map)
		test_map.load_tile_ids()
		test_map.generate_blank_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	####TESTING####
	if testing:
		if first_run:
			Follower.create_path(test_map.get_astar_path(Follower.get_global_position(), test_dest))
			
			
			print( "follower:", Follower)

			first_run = false
#func _on_StuckTimer_timeout():
#	pos_difference = 	
