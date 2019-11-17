

extends StaticBody2D

export var object_name = "null" # The specific name of this object
export (String, "Agent", "Stone", "Container", "Pupper", "Tree", "Soil", "Furniture", "Grass") var object_type # What class of object is this
var cell_id = null  # What cell the object is located in 
var cell_pos = null  # Where in the cell is 




# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready main")


func set_cell_id(new_id):
	self.cell_id = new_id

func set_cell_pos(new_cell_pos):
	self.cell_pos = new_cell_pos
	
#func set_map_pos(new_pos): asdasd
