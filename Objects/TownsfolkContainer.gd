extends PathFollow2D

export var type = "townsfolk"
var moving = true
export var speed = 40
export var speed_variation = 5  # Max (+/-) Amount the speed can vary
export var anim = ["Idle", "Walking","Talking","Waving"]
export var repeat_chance = .6
var crnt_state = 0


var transition = false
var showing = true  # Are we displaying this peasent yet?
var rnd = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
		$AnimatedSprite.set_animation("Idle")
		$AnimatedSprite.play()
		crnt_state = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if crnt_state == 1:  # Walking
		if self.unit_offset >= .99:
			crnt_state = 0
			unit_offset = .99
			$AnimatedSprite.set_animation(anim[crnt_state])
			
		else:
			self.set_offset( self.get_offset() + (speed*delta))
		

# function to change animation state externally
func change_state(state):
	if crnt_state != state:
		crnt_state = state
		$AnimatedSprite.set_animation(anim[crnt_state])	
	
# Returns PathFollower posito the begining of the 2DPath
func reset_pos():
	self.unit_offset = 0


# Handles interactions with other 2DAreas
func _on_Area2D_area_entered(body):
	print("collision detected (area)")
	if !transition  and body.type == OK:
		if body.type == "Interaction":
			crnt_state = rnd.randi_range(2,3)
			$AnimatedSprite.set_animation(anim[crnt_state])
			$InteractionTimer.start()
		
		if body.type == "Intersection":
			print("Intersection entered")
			var overlaping_areas = body.get_overlapping_areas()
			print("area overlapped array", overlaping_areas) 
			for i in overlaping_areas:
				print(i, i.type, i.position)


func _on_Area2D_area_exited(body):
	transition = false

# Buffer for collision detection and animation selection
func _on_InteractionTimer_timeout():
	transition = true
	var repeats = randi()
	
	crnt_state = 1
	$AnimatedSprite.set_animation(anim[crnt_state])
	
