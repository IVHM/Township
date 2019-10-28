extends Path2D

export var type = "player"

# MOVEMENT VARIABLES
var moving = true
export var speed = 40
onready var facing_direction = $PlayerFollower/AnimatedSprite/FacingNode
export var rotation_speed = .9
var turning_angle = null
onready var follower = $PlayerFollower


#ANIMATION VARIABLES
var crnt_state = 0
onready var sprite = $PlayerFollower/AnimatedSprite
export var anim = ["Idle", "Walking","Talking","Waving"]
export var repeat_chance = .6
export var personal_name = "Choose-name"
export var health = 100
export var inventory = {'gold': 100, 'wood': 100, 'stone': 50}

# INTERACTION VARIABLES
signal player_path_request
onready var interaction_timer = $InteractionTimer 
var near_resource = false
var resource = null
onready var mining_timer = $MiningTimer
export var mining_timer_len = .8
var transition = false

# RANDOM
var rnd = RandomNumberGenerator.new()


# FOLLOWER VARIABLES
onready var stay_perimeter = $PlayerFollower/StayPerimeter
onready var near_perimeter = $PlayerFollower/NearPerimeter


#
# Called when the node enters the scene tree for the first time.
func _ready():
		sprite.set_animation("Idle")
		sprite.play()
		crnt_state = 0



##
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	if crnt_state == 1:  # Walking
		if follower.unit_offset > .99:
			crnt_state = 0
			sprite.set_animation(anim[crnt_state])
		else:
			follower.set_offset( follower.get_offset() + (speed*delta))

	
	if Input.is_action_pressed("ui_mouse_left"):
		var mouse_pos = get_global_mouse_position()
		get_new_player_path(mouse_pos)
	
##
# function to change animation state 
func change_state(state):
	if crnt_state != state:
		crnt_state = state
		sprite.set_animation(anim[crnt_state])	


##
# Returns PathFollower position to the begining of the 2DPath
func reset_pos():
	self.follower.unit_offset = 0


##
# Handles interactions with other 2DAreas
func _on_PlayerArea2D_area_entered(body):
	print("Area2D collision detected ")
	if !transition:
		if body.type == "harvestable object":
			if body.alive:
				print("near stone", body)
				self.near_resource = true
				self.transition = true
				self.change_state(0)
				resource = body
				follower.look_at(body.position)
				mine(body)
	
	var a = false # Functionality currently disabled
				  # needs to be converted once
	if a:
		print("collision detected (area)")
	
		if body.type == "Interaction":
			crnt_state = rnd.randi_range(2,3)
			sprite.set_animation(anim[crnt_state])
			$InteractionTimer.start()
		
		if body.type == "Intersection":
			print("Intersection entered")
			var overlaping_areas = body.get_overlapping_areas()
			print("area overlapped array", overlaping_areas) 
			for i in overlaping_areas:
				print(i, i.type, i.position)


func _on_PlayerArea2D_area_exited(body):
	if !transition:
		if body.type == "harvestable object":
			print("left stone", body)
			self.near_resource = false
			self.resource = null

		
##
# Activates the transition gate and interaction timer	
func start_transition():
	transition = true
	interaction_timer.start()

	
##
# Buffer for collision detection and animation selection so collision don't double bounce
func _on_InteractionTimer_timeout():
	transition = false


##
# Controls player interaction with "minable" objects
func mine(body):
	print("swinging pickaxe at ", body.type, body.alive)
	body.take_hit(10, self)
	print(body.alive)
	if body.alive:
		mining_timer.start(mining_timer_len)
		#mining_timer.start()
		print("started mining timer")
	else:
		near_resource = false

##
# Timer for continuous mining, controls swings per second
func _on_MiningTimer_timeout():
	print("MiningTimer Done\n")
	if near_resource:
		mine(resource)


##
# Adds items to the player's inventory
func transfer(inventory_in):
	print("transfering", inventory_in)
	for i in inventory_in:
		if i in inventory.keys():
			inventory[i] += inventory_in[i]
		else:
			inventory[i] = inventory_in[i]


##
# Handles when the player clicks to move to a new tile, getting a nav path from its parent
func get_new_player_path(mouse_pos):
		var new_end_point = mouse_pos
		var new_start_point = follower.position
		print("new_end_point", new_end_point, " : new_start_point", new_start_point)
		

		if near_resource: # This stops the area2d from reacting 
			start_transition()
			self.near_resource = false

	
		emit_signal("player_path_request", new_start_point, new_end_point, self)


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
# Returns the sprite's position for more acurate measurements
func get_sprite_position():
	return self.sprite.get_global_position()