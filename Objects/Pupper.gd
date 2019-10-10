extends Path2D

export (NodePath) var follower
export (NodePath) var leader
export (NodePath) var sprite


# MOVEMENT VARIABLES
export var speed = 39

# ANIMATION VARIABLES
export var crnt_state = 0  # | 0         |   1   |   2             |
export (Array) var animation_tags = ["stand_idle", "walk", "stand_idle_wag"]
var crnt_path

# SIGNALS
signal path_request

# TEST VARIABLES
export var test_path_get = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.follower = get_node(self.follower)
	self.leader = get_node(self.leader)
	emit_signal("path_request", self.position, leader.get_sprite_position(), self)
	self.crnt_state = 1

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#######TEST OUTPUT###############
	if true:
		print("\n\n#####PUPPER STATS#####")
		print("\npupper offset : ", follower.unit_offset)
		print("crnt_state : ", self.crnt_state)a
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
		emit_signal("path_request", sprite.position, leader.get_sprite_position())
		self.test_path_get = false

##
# Takes in a new poolVector2 from the nav_mesh and sets as new Path2D curve
func update_path(new_path):
	print(follower.position)
	var new_curve = Curve2D.new()
	var pos = follower.position
	new_curve.add_point(pos)

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


##
# function to change animation state 
func change_state(state):
	if crnt_state != state:
		crnt_state = state
		sprite.set_animation(self.animation_tags[crnt_state])	

