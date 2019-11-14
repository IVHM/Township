

extends StaticBody2D

var cell_id = null
var cell_position = null
#var owner = null
var type = null



# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready main")


func set_cell_id(new_id):
	self.cell_id = new_id

func set_cell_pos(new_cell_pos):
	self.cell_pos = new_cell_pos
	
#func set_map_pos(new_pos):