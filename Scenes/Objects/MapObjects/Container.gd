extends "res://Scenes/Objects/MapObjects/MapObject_template.gd"

export var inventory = {}
export var max_capacity = 10
export var crnt_capacity = 0



func _ready():
	print(position, "ready barrel" )
##
# Takes in a dictionary of items and their amounts, use negative amount to take items
func change_items_amt(items_in): 
	for i in items_in:
		if i in inventory.keys():
			inventory[i] += items_in[i]
			if inventory[i] <= 0:
				inventory.erase(i)
		else:
			inventory[i] = items_in[i]
			if inventory[i] <= 0:
				print("You tried to add a negative amount of stuff to an inventory")
				print("Check your code bub.")
				#print("asl"+true)

func get_inventory():
	return inventory