extends Node

#### TYPE CLASSIFICATION VARIABELS

# Used to determine the bit flags of an interaction menu
# All corresponding png resources must be named exactly the same
# THESE NUMBERS COME FROM THE SPREEDSHEET object_bitflags_for_interaction_menu
export var INTERACTION_TYPES = {
			"Talk"  : 1, 
			"Trade" : 2, 
			"Job"   : 4, 
			"Cancel": 8, 
			"Mine"  : 16,
			"Chop"  : 32, 
			"Pickup": 64, 
			"Open"  : 128, 
			"Plant" : 256, 
			"Craft" : 512, 
			"Break" : 1024, 
			"Haul"  : 2048, 
			"Move"  : 4096, 
			"Give"  : 8192} 

# All the different menu types the menu handler can generate
export var MENU_TYPES = ["Interactions"]

# All the different objects classes that can be generated on the game map
# Along with the bitflags for their interaction menu buttons						   
export var OBJECT_TYPES= {
			"Agent"    : 10247,
			"Stone"    : 1040,
			"Container": 4288,
			"Pupper"   : 10245,
			"Tree"     : 1200,
			"Soil"     : 336,
			"Furniture": 5184,
			"Grass"    : 1280}

export var OBJECTS_DATABASE = [
			"Barrel"
]
#### MAP VARIABLES

export var MAP_SIZE = Vector2(30,30)
export var TILE_SIZE = Vector2(16,16)