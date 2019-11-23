

extends StaticBody2D

export var object_name = "null" # The specific name of this object
export (String, "Agent", "Stone", "Container", "Pupper", "Tree", "Soil", "Furniture", "Grass") var object_type # What class of object is this
var cell_id = null  # What cell the object is located in 
var cell_pos = null  # Where in the cell is 
var owner_ref = null #what agent owns this object

## WORLD PROPERTIES 
export (float) var value # How worth while the object is, objects that take more time and or labor to make are worth more 
export (float) var weight 
export (Array, String) var ingredients 
var wear = 1  # how used or worn down the item is, affects the usability and worth of the object  



# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready main")



####GETTERS & SETTERS#######
func get_cell_id():
	return self.cell_id
func set_cell_id(new_id):
	self.cell_id = new_id
func get_cell_pos():
	return self.cell_pos
func set_cell_pos(new_cell_pos):
	self.cell_pos = new_cell_pos
func get_cell_location():
	return [self.cell_id, self.cell_pos]
func get_object_name():
	return self.object_name
