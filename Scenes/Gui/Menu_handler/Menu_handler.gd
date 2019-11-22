extends Node

var current_menu = null
var menu_database = {}  # Dictionary of loaded template menu scenes ie.{"PlayerMenu": (Node) Player_menu} 
export var menu_filepath = ""  # What folder to load the menu scenes from					

#### MENU PACKEDSCENES
#export (PackedScene) var interaction_menu
#export (PackedScene) var trading_menu 
export (String, FILE) var interaction_menu
export (String, FILE) var trading_menu
signal menu_choice_made

##### TESTING VARIABLE
export var testing = false
export var t_print = true


func _ready():
	if t_print:
		print("Menu_handler loaded")
		print("interaction_menu: ", interaction_menu)
		print("trading_menu: ", trading_menu)

	interaction_menu = load(interaction_menu)
	trading_menu = load(trading_menu)

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
		current_menu.connect("interaction_choice", self, "_on_interaction_choice")
	
##
# Triggered when the player makes an interaction choice		
func _on_interaction_choice(type, object):
	if t_print: print("##button press signal received by menuhandler"); print(current_menu)
	emit_signal("menu_choice_made", type, object)


##
# Loads and creates an inventory trading menu
func load_inventory_trade_menu(player, trader):
	if current_menu == null:
		current_menu = trading_menu.instance()
		self.add_child(current_menu)
		current_menu.load_items(player.get_inventory(), player,
								trader.get_inventory(), trader)
		current_menu.connect("trade_completed", self, "_on_trade_completed")

##
# 
func _on_trade_completed():
	if t_print: print("menu_handler received trade completed signal")

##
# Used to create the click masking area 
func get_current_menu_area():
	return current_menu.get_area()

func close_current_menu():
	UTIL.remove_all_children(self)
	current_menu = null