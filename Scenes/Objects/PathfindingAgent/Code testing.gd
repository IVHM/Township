extends Node2D

export (NodePath) var Follower
export (NodePath) var StuckTimer

#### MOVEMENT BEHAVIOR VARIABLES
export var start_pos = Vector2(0,0)
var moving = false
var point_array # This holds the list of vectors that make up the curve
var crnt_point = 0 # The index of the point we are going from
var dest_point = 4 # the index of the next point in the curve

export (int) var speed 
var heading
var prev_pos 

#### Testing
export (NodePath) var test_map
export (NodePath) var PathViz 
export var testing = false
export var t_print = false
export (Vector2) var test_dest = Vector2(200,200)


# Called when the node enters the scene tree for the first time.
func _ready():
	Follower = get_node(Follower)
	Follower.set_position(start_pos)
	prev_pos = start_pos


	####TESTING####
	if testing:
		PathViz = get_node(PathViz)
		test_map = get_node(test_map)
		test_map.load_tile_ids()
		test_map.generate_blank_map()
		point_array = get_new_path(test_dest)
		
		PathViz.set_points(point_array)
		print(point_array, "follower:", Follower)
		heading = UTIL.calc_head(Follower.get_position(), point_array[dest_point])
		Follower.set_global_rotation(heading.angle())
		moving = true

func get_new_path(dest):
	if testing:
		return test_map.get_astar_path(Follower.get_position(), dest)
	#	EVENTS.emit_signal("path_requested", Follower.get_position(), dest, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		Follower.move_and_slide(heading * speed)
		# Check how far we are from our crnt vs next point along the path
		var dist_crnt = Follower.get_position().distance_to(point_array[crnt_point])
		var dist_next = Follower.get_position().distance_to(point_array[crnt_point+1])

		# If next grtr crnt, we increment the point counters, and adjust heading
		if dist_next < dist_crnt:
			crnt_point += 1
			if dest_point < len(point_array):
				dest_point += 1
			heading = UTIL.calc_head(Follower.get_position(), point_array[dest_point])
			Follower.set_global_rotation(heading.get_angle())

		if cnrt_point == len(point_array) - 1:
			moving = false

#func _on_StuckTimer_timeout():
#	pos_difference = 	
