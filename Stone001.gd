extends Sprite

export var type = "interactable object"
var alive = true setget get_alive
export var health = 10
export var armor = 5
export var inventory = { "stone" : 15}
var total = null 




# Called when the node enters the scene tree for the first time.
func _ready():
	self.total = 0
	for i in inventory.values()
		self.total += i



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.alive && self.transition:


func take_hit(dmg):
	dmg -= armor 
	if dmg > 0:
		health -= dmg 
	else:
		print("Your tool is not strong enough")
	
	if health <= 0:
		alive = false

getset 