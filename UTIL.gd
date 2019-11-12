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
# Translates the map tile's pos to it's correspoding astar point's id take sin a vector2 or two numbers
func map_pos_to_id(i,j=null):
	if j == null:
		return int((i.x * size.y) + i.y)
	else:
		return int((i * self.size.y) + j) 
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
