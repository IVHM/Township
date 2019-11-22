extends Node2D

# Nodes handling the different systems in the game
export (NodePath) var world_map
export (NodePath) var object_handler
export (NodePath) var menu_handler
export (NodePath) var player


var menu_open = false


#### TESTING VARIABLES
export (bool) var testing = false
export (bool) var t_print = false


# Called when the node enters the scene tree for the first time.
func _ready():
	world_map = get_node(world_map)
	object_handler = get_node(object_handler)
	menu_handler = get_node(menu_handler)
	player = get_node(player)
	
	#### SIGNAL CONNECTIONS
	#player.connect("player_map_call", self, "_on_player_map_call")
	menu_handler.connect("menu_choice_made", self, "_on_menu_choice_made")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	########
	#### PLAYER INPUT CONTROLS
	var mouse_pos = get_global_mouse_position()

	### INTERACTION CONTROLS
	if Input.is_action_just_pressed("ui_mouse_left"):
		if menu_open:
			if t_print: print("menu on click")
			var menu_area = menu_handler.get_current_menu_area()
			if t_print: print("menu_area: ", menu_area, "Mouse pos: ", mouse_pos)
			if mouse_pos.x >= menu_area[0].x &&  mouse_pos.x <= menu_area[1].x:
				if mouse_pos.y >= menu_area[0].y && mouse_pos.y <= menu_area[1].y:
					pass
				else:
					menu_handler.close_current_menu()
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
	
	player.move_player(movement_vector, delta)



####HANDLES ALL SIGNALS FROM DIFFERENT OBJECTS

##
# Called when the player makes a choice in their menu
func _on_menu_choice_made(player_action, object):
	if t_print: print("Main_hub recived choice: ", player_action, object)
	menu_handler.close_current_menu()
	menu_open = false
	
	if player_action == "Open":
		print("opening container")
		menu_handler.load_inventory_trade_menu(player, object)

##
# Called whenever a player requests interaction information about a certain cell
func player_map_interaction(pos):
	if t_print: print("player_map_call")
	if pos.x > 0 && pos.y > 0: 
		var cell_type = world_map.get_cell_info(pos)
		var cell_objects = object_handler.check_cell(pos, null, true)
		if t_print: print(cell_objects)
		if cell_objects != null:
			menu_handler.load_interaction_menu(pos, cell_objects)
			menu_open = true


