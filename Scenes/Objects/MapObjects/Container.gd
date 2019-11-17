extends "res://Objects/MapObjects/MapObject_template.gd"

export var inventory = {}
export var max_capacity = 10
export var crnt_capacity = 0

func _ready():
	print(position, "ready barrel" )

func add_item(): 
	pass