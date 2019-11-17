extends Node2D

# Nodes handling the different systems in the game
export (NodePath) var world_map
export (NodePath) var object_handler
export (NodePath) var menu_handler
export (NodePath) var player


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
	player.connect("player_map_call", self, "_on_player_map_call")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



####HANDLES ALL SIGNALS FROM DIFFERENT OBJECTS

##
# Called whenever a player requests interaction information about a certain cell
func _on_player_map_call(pos):
	if t_print: print("player_map_call")
	var cell_type = world_map.get_cell_info(pos)
	var cell_objects = object_handler.check_cell(pos, null, true)
	if t_print: print(cell_objects)
	if cell_objects != null:
		menu_handler.load_interaction_menu(pos, cell_objects)
