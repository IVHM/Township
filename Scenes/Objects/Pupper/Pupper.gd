extends Path2D

export (NodePath) var follower
export (NodePath) var leader
export (NodePath) var sprite
export (NodePath) var leader_search_timer
export (NodePath) var boredom_timer


# MOVEMENT VARIABLES
export var base_speed = 39
export (int) var speed = base_speed 
# ANIMATION VARIABLES
export var crnt_state = 0  # | 0         |   1   |   2             |
export (Array) var animation_tags = ["stand_idle", "walk", "stand_idle_wag"]
var crnt_path

# SIGNALS
signal pupper_path_request

# TEST VARIABLES
export var test_process = false
export var test_path_get = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Initializing Pupper")
	follower = get_node(self.follower)
	leader = get_node(self.leader)
	sprite = get_node(self.sprite)
	leader_search_timer = get_node(self.leader_search_timer)
	leader_search_timer.start()
	boredom_timer = get_node(boredom_timer)

	self.change_state(1)


#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#######TEST OUTPUT###############
	if test_process:
		print("\n\n#####PUPPER STATS#####")
		print("\npupper offset : ", follower.unit_offset)
		print("crnt_state : ", self.crnt_state)
		print("\n--nav_mesh_path_curve_point_dump--")
		print(self.get_curve().get_baked_points())
		var cnt = 0
		for i in self.get_curve().get_baked_points():
			print(cnt, ":", i)
			cnt += 1
	#########################################

	if self.crnt_state == 1:  # Walking
		if follower.unit_offset > .99:
			self.crnt_state = 0
			sprite.set_animation(self.animation_tags[self.crnt_state])
		else:
			follower.set_offset( follower.get_offset() + (self.speed * delta))

	if test_path_get:
		print("test path get got got")
		request_new_path()
		self.test_path_get = false

##
# Takes in a new poolVector2 from the nav_mesh and sets as new Path2D curve
func update_path(new_path):
	print("\nPupper: update path")
	print(follower.position)
	print(new_path)
	var new_curve = Curve2D.new()
	var pos = follower.position
	new_curve.add_point(pos, pos+Vector2(1,1))

	for i in new_path:
		new_curve.add_point(i)
	
	self.set_curve(new_curve)
	print("set curve")
	reset_pos()
	print("reset position")
	change_state(1)
	print(follower.position)

##
# Returns PathFollower position to the begining of the 2DPath
func reset_pos():
	self.follower.unit_offset = 0	

func stop_moving():
	self.crnt_state = 0
	sprite.set_animation("stand_idle")

##
# function to change animation state 
func change_state(state):
	if crnt_state != state:
		crnt_state = state
		sprite.set_animation(self.animation_tags[self.crnt_state])	


func _on_Area2D_area_entered(area):
	print("######################")
	print("pupper entered area: ", area.type)
	if area.type == "near perimeter":
		leader_search_timer.stop()
		#boredom_timer.start()
		stop_moving()

func _on_Area2D_area_exited(area):
	print("######################")
	print("pupper exited area: ", area.type)
	if area.type == "stay perimeter":
		request_new_path()
		leader_search_timer.start()

func _on_LeaderSearchTimer_timeout():
	request_new_path()


func request_new_path():
	emit_signal("pupper_path_request", sprite.get_global_position(), leader.get_sprite_position(), self)

func _on_AnimatedSprite_animation_finished():
	pass
