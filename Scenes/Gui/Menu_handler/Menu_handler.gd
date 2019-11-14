extends Node

var current_menu = null
var menu_database = {}  # Dictionary of loaded template menu scenes ie.{"PlayerMenu": (Node) Player_menu} 
export var menu_filepath = ""  # What folder to load the menu scenes from					

##### TESTING VARIABLE
export var testing = false
export var t_print = false 


func _ready():
	for i in GLOBAL.MENU_TYPES:
		

