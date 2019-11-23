extends KinematicBody2D

# AGENT VARIABLES
export var type = "player"

# MOVEMENT VARIABLES
var moving = true
export var speed = 10
export var rotation_speed = .8
export var rotation_drag_margin = Vector2(-0.1, 0.1)




#ANIMATION VARIABLES
var state = 0
export (NodePath) var Sprite  # Your base animatd sprite node 
export (NodePath) var RotationControl # Controls how fast the player character rotates to follow the mouse
export var anim = ["Idle", "Walking","Talking","Waving"]
export var repeat_chance = .6
export var personal_name = "Choose-name"
export var health = 100
export var inventory = {'nickel': 100, 'wood': 100, 'stone': 50}

# INTERACTION VARIABLES
export (NodePath) var InteractionTimer 
var near_resource = false
var resource = null
export (NodePath) var MiningTimer 
export var MiningTimer_len = .8
var transition = false

# RANDOM
var rnd = RandomNumberGenerator.new()


# FOLLOWER VARIABLES
onready var StayPerimeter = $PlayerFollower/StayPerimeter
onready var NearPerimeter = $PlayerFollower/NearPerimeter



#### TESTING VARIABLES
export var testing = false
export var t_print = true

#
# Called when the node enters the scene tree for the first time.
func _ready():
	InteractionTimer = get_node(InteractionTimer)
	MiningTimer = get_node(MiningTimer)
	RotationControl = get_node(RotationControl)
	Sprite = get_node(Sprite)
	Sprite.set_animation(anim[self.state])
	Sprite.play()
	self.state = 0



##
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	### MOUSE FOLLOW BEHAVIOUR ###
	var mouse_pos = get_global_mouse_position()
	if !near_resource:
		var angle_to_mouse = self.get_angle_to(mouse_pos)
		
		if angle_to_mouse < self.rotation_drag_margin.x || angle_to_mouse > rotation_drag_margin.y:
			var target_angle = self.get_rotation() + angle_to_mouse
			RotationControl.interpolate_property(self, "rotation", self.get_rotation(),
												target_angle, abs(angle_to_mouse)/PI * self.rotation_speed,
												Tween.TRANS_QUART, Tween.EASE_OUT) 
		
			RotationControl.start()

		
##
# function to change animation state 
func change_state(state):
	if self.state != state:
		self.state = state
		Sprite.set_animation(anim[self.state])	


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
			Sprite.set_animation(anim[self.state])
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
	InteractionTimer.start()

	
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
		MiningTimer.start(MiningTimer_len)
		#MiningTimer.start()
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
# updates quantities and items in the player's inventory, either adds or subtracts
func update_inventory(inventory_in, adding=true):
	if t_print and adding:print("transfering", inventory_in)
	elif t_print: print("removing", inventory_in)
	for i in inventory_in:
		if i in inventory.keys():
			if adding:
				inventory[i] += inventory_in[i]
			else:
				inventory[i] -= inventory_in[i]
			# Check if we gave away all of the item	
			if inventory[i] == 0:
				inventory.erase(i)
			elif inventory[i] < 0:
				print("\n****\nERROR\n****")
				print("player inventory was just updated with a negative number")
				print("check your code bud")
		else:
			inventory[i] = inventory_in[i]
			if inventory[i] <= 0:
				print("\n****\nERROR\n****")
				print("player inventory was just updated with a negative number")
				print("check your code bud")
	if t_print: print("player inventory:", self.inventory)



##
# Controls how we move the player character 
func move_player(movement_vector, delta):
	if transition:
		movement_vector = Vector2(0,0)

	# Handles all behaviors that happen while moving
	if movement_vector.x != 0 || movement_vector.y != 0:
		if near_resource:
			near_resource = false
			start_transition()
		Sprite.set_animation("Walking")
	# Handles all beahavior while player is stopped
	else:
		Sprite.set_animation("Idle")

	movement_vector = movement_vector.normalized() 
	movement_vector *= (self.speed * delta)
	self.move_and_collide(movement_vector)


##
# Returns the sprite's position for more acurate measurements
func get_sprite_position():
	return self.get_global_position()



##
# returns a copy of the contents of the players inventory
func get_inventory():
	return self.inventory.duplicate()