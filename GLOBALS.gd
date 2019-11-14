extends Node

# Used to determine the bit flags of an interaction menu
# All corresponding png resources must be named exactly the same
export var INTERACTION_TYPES = {
			"Null"   : 1,
			"Talk"   : 2,
			"Trade"  : 4,
			"Job"    : 8,
			"Cancel" : 16,
			"Mine"   : 32,
			"Chop"   : 64,
			"Open"   : 128,
			"Place"  : 356
						   }

export var MENU_TYPES = ["Interactions"]
# Used to generate all the different objects on the game map						   
export var OBJECT_TYPES = ["Barrel"]

#### MAP VARIABLES

export var MAP_SIZE = Vector2(30,30)
export var TILE_SIZE = Vector2(16,16)