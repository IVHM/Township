extends Node

var current_menu = null
var menu_database = {}  # Dictionary of loaded template menu scenes ie.{"PlayerMenu": (Node) Player_menu} 
export var menu_filepath = ""  # What folder to load the menu scenes from					

#### MENU PACKEDSCENES
export (PackedScene) var interaction_menu 

##### TESTING VARIABLE
export var testing = false
export var t_print = true


func _ready():
	for i in GLOBALS.MENU_TYPES:
		menu_database[i] = load(str(menu_filepath + i + ".tscn"))		
##
# Takes in a world coord and an array of objects to generate an instancce of 
func load_interaction_menu(pos, objects):
	if t_print: print("load interaction menu called", objects)
	if current_menu == null:
		current_menu = interaction_menu.instance()
		self.add_child(current_menu)
		print(objects, "menu_handler")
		current_menu.create_menu(pos, objects)
		
	
	