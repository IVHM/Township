extends Node2D


export (NodePath) var world_map
export (NodePath) var player
export (NodePath) var g_UI 

# Called when the node enters the scene tree for the first time.
func _ready():
	world_map = get_node(world_map)
	player = get_node(player)
	g_UI = get_nod(g_UI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# astar_call_request(i,j)

# player_call_request()

# 


####HANDLES ALL SIGNALS FROM DIFFERENT OBJECTS

func _on_Player_map_call(pos):
	var cell_type = world_map.get_cell_info(pos)
	var cell_objects = 