extends Node2D

onready var nav_tiles = $TileNavigation
onready var cur_path = $MousePath
onready var pc = $MousePath/Player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_player_clicked(start, end, player):
	print("\n\n----\n--\n--\nCreating path")
	var new_path = nav_tiles.get_simple_path(start,end)
	var new_curve = Curve2D.new()

	var pos = pc.position
	new_curve.add_point(pc.position)

	for i in new_path:
		new_curve.add_point(i)
	
	cur_path.set_curve(new_curve)
	pc.reset_pos()
	pc.change_state(1)
	
#	cur_path.set_curve(new_curve)
#	pc.reset_pos()
#	pc.change_state(1)
