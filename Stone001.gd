extends Sprite

export var type = "interactable object"
export var health = 10
export var armor = 5
export var inventory = { "stone" : 15}
var total = null 




# Called when the node enters the scene tree for the first time.
func _ready():
	total = 0
	for i in inventory.values()
		total += i



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func take_hit(dmg):
	dmg -= armor 
	if dmg > 0:
		