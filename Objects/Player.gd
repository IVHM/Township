extends KinematicBody2D


# MOVEMENT VARIABLES
var moving = true
export var speed = 10
export var rotation_speed = .8
export var rotation_drag_margin = Vector2(-0.1, 0.1)




#ANIMATION VARIABLES
var state = 0
export (NodePath) var sprite  # Your base animatd sprite node 
export (NodePath) var rotation_control # Controls how fast the player character rotates to follow the mouse
export var anim = ["Idle", "Walking","Talking","Waving"]
export var repeat_chance = .6
export var personal_name = "Choose-name"
export var health = 100
export var inventory = {'gold': 100, 'wood': 100, 'stone': 50}

# INTERACTION VARIABLES
signal player_path_request
export (NodePath) var interaction_timer 
var near_resource = false
var resource = null
export (NodePath) var mining_timer 
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
	interaction_timer = get_node(interaction_timer)
	mining_timer = get_node(mining_timer)
	rotation_control = get_node(rotation_control)
	sprite = get_node(sprite)
	sprite.set_animation(anim[self.state])
	sprite.play()
	self.state = 0



##
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	### INPUT HUB ###
	var movement_vector = Vector2(0,0)
	if !transition or !near_resource:
		if Input.is_action_pressed("ui_key_w"):	movement_vector.y += -1
		if Input.is_action_pressed("ui_key_a"): movement_vector.x += -1
		if Input.is_action_pressed("ui_key_s"):	movement_vector.y += 1	 
		if Input.is_action_pressed("ui_key_d"):	movement_vector.x += 1
	
	# Handles all behaviors that happen while moving
	if movement_vector.x != 0 || movement_vector.y != 0:
		if near_resource:
			near_resource = false
			start_transition()
		sprite.set_animation("Walking")
	#handles all beahavior while player is stopped
	else:
		sprite.set_animation("Idle")

	if !near_resource:
		### MOUSE FOLLOW BEHAVIOUR ###
		var mouse_pos = get_global_mouse_position()
		var angle_to_mouse = self.get_angle_to(mouse_pos)
		
		if angle_to_mouse < self.rotation_drag_margin.x || angle_to_mouse > rotation_drag_margin.y:
			var target_angle = self.get_rotation() + angle_to_mouse
			rotation_control.interpolate_property(self, "rotation", self.get_rotation(),
												target_angle, abs(angle_to_mouse)/PI * self.rotation_speed,
												Tween.TRANS_QUART, Tween.EASE_OUT) 
		
			rotation_control.start()


	move_player(movement_vector, delta)
	
#	print("movement_vector",movement_vector, "current position", kinematic_body.position)
	move_player(movement_vector, delta)
	
##
# function to change animation state 
func change_state(state):
	if self.state != state:
		self.state = state
		sprite.set_animation(anim[self.state])	


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
				start_transition()
				self.change_state(0)
				resource = body
				self.look_at(body.global_position)
				mine(body)
	



	var a = false # Functionality currently disabled
				  # needs to be converted once
	if a:
		print("collision detected (area)")
	
		if body.type == "Interaction":
			self.state = rnd.randi_range(2,3)
			sprite.set_animation(anim[self.state])
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
# Controls how we move the player character 
func move_player(movement_vector, delta):
	movement_vector = movement_vector.normalized() 
	movement_vector *= (self.speed * delta)
	self.move_and_collide(movement_vector)


##
# Returns the sprite's position for more acurate measurements
func get_sprite_position():
	return self.get_global_position()