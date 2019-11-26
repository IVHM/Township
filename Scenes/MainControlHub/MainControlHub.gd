extends Node2D

# Nodes handling the different systems in the game
export (NodePath) var WorldMap_handler
export (NodePath) var Object_handler
export (NodePath) var Menu_handler
export (NodePath) var Player

# Menu state variables
var menu_open = false
var menu_type = null


#### TESTING VARIABLES
export (bool) var testing = false
export (bool) var t_print = false

##
# Called when the node enters the scene tree for the first time.
func _ready():
	WorldMap_handler = get_node(WorldMap_handler)
	Object_handler = get_node(Object_handler)
	Menu_handler = get_node(Menu_handler)
	Player = get_node(Player)
	
	#### SIGNAL CONNECTIONS
	#Player.connect("Player_map_call", self, "_on_Player_map_call")
	EVENTS.connect("menu_choice_made", self, "_on_menu_choice_made")
	EVENTS.connect("menu_closed", self, "_on_menu_closed")
	EVENTS.connect("trade_completed", self, "_on_trade_completed")
	EVENTS.connect("path_request", self, "_on_path_request")

##
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	########
	#### PLAYER INPUT CONTROLS
	var mouse_pos = get_global_mouse_position()

	### INTERACTION CONTROLS
	if Input.is_action_just_pressed("ui_mouse_left"):
		if menu_open:
			if t_print: print("menu on click")
			if menu_type != "Trade":
				var menu_area = Menu_handler.get_current_menu_area()
				if t_print: print("menu_area: ", menu_area, "Mouse pos: ", mouse_pos)
				if mouse_pos.x >= menu_area[0].x &&  mouse_pos.x <= menu_area[1].x:
					if mouse_pos.y >= menu_area[0].y && mouse_pos.y <= menu_area[1].y:
						pass
					else:
						Menu_handler.close_current_menu()
						menu_open = false
						player_map_interaction(mouse_pos)
		else:
			if t_print: print("no menu on click")
			player_map_interaction(mouse_pos)
		

			## MENU CONTROLS 
	if Input.is_action_just_pressed("ui_open_player_inventory"):
		print("player open inventory")

	## MOVEMENT CONTROLS
	var movement_vector = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):	movement_vector.y += -1
	if Input.is_action_pressed("ui_left"): movement_vector.x += -1
	if Input.is_action_pressed("ui_down"):	movement_vector.y += 1	 
	if Input.is_action_pressed("ui_right"):	movement_vector.x += 1
	
	Player.move_player(movement_vector, delta)






##
# Called whenever a player requests interaction information about a certain cell
func player_map_interaction(pos):
	if t_print: print("player_map_call")
	if pos.x > 0 && pos.y > 0: 
		var cell_type = WorldMap_handler.get_cell_info(pos)
		var cell_objects = Object_handler.check_cell(pos, null, true)
		if t_print: print(cell_objects)
		if cell_objects != null:
			Menu_handler.load_interaction_menu(pos, cell_objects)
			menu_open = true
			menu_type = "Interaction"


#### SIGNALS FROM DIFFERENT OBJECTS
func _on_path_request(start, end, object):
	var new_path = WorldMap_handler.get_astar_path(start, end)
	object.update_path(new_path)


##
# Called when the player makes a choice in their menu
func _on_menu_choice_made(player_action, object):
	if t_print: print("Main_hub received choice: ", player_action, object)
	Menu_handler.close_current_menu()
	menu_open = false
	
	if player_action == "Open":
		if t_print: print("opening container")
		menu_open = true
		menu_type = "Trade"
		Menu_handler.load_inventory_trade_menu(Player, object)

##
# Called when the player confirms a trade
func _on_trade_completed():
	if t_print: print("Trade complete signal received by main hub")
	self.menu_open = false
	self.menu_type = null


##
# Called when a player decides to close a menu
func _on_menu_closed():
	if t_print: print("Menu closed signal received by main hub")
	self.menu_open = false
	self.menu_type = null