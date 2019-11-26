extends Node

#### GENERAL PURPOSE SCRIPTS

##
# Says it on the tin
func remove_all_children(node):
	if len(node.get_children()) > 0:
		for n in node.get_children():
			node.remove_child(n)
			n.queue_free()





#### MAP SCRIPTS

##
# Calculates the normal directional unit vector from crnt to trgt
func calc_head(crnt, trgt):
	return crnt.direction_to(trgt)
##
# Translates the map tile's pos to it's correspoding astar point's id take sin a vector2 or two numbers
func map_pos_to_id(i,j=null):
	if j == null:
		j = i.y
		i = i.x
	return int((i * GLOBALS.MAP_SIZE.y) + j) 

func world_pos_to_id(i,j=null):
	if j == null:
		j = i.y
		i = i.x
	return map_pos_to_id(world_pos_to_map(i,j))

func world_pos_to_map(i,j=null):
	if j == null:
		j = i.y
		i = i.x
	return Vector2(floor(i / GLOBALS.TILE_SIZE.x),
				   floor(j / GLOBALS.TILE_SIZE.y))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
