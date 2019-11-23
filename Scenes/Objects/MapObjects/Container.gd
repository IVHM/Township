extends "res://Scenes/Objects/MapObjects/MapObject_template.gd"

export var inventory = {}
export var max_capacity = 10
export var crnt_capacity = 0



func _ready():
	print(position, "ready barrel" )
##
# Takes in a dictionary of items and their amounts, use negative amount to take items
func update_inventory(inventory_in, adding=true):
	print("transfering", inventory_in)
	for i in inventory_in:
		if i in inventory.keys():
			if adding:
				inventory[i] += inventory_in[i]
			else:
				inventory[i] -= inventory_in[i]
			# Check if we gave away all of the item	
			if inventory[i] == 0:
				inventory.erase(i)
			if inventory[i] < 0:
				print("\n****\nERROR\n****")
				print("player inventory was just updated with a negative number")
				print("check your code bud")
		else:
			inventory[i] = inventory_in[i]
			if inventory[i] <= 0:
				print("\n****\nERROR\n****")
				print("player inventory was just updated with a negative number")
				print("check your code bud")

				

##
# Returns current containers inventyory
func get_inventory():
	return inventory