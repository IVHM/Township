extends Node2D

onready var nav_tiles = $TileNavigation
onready var pc = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	pc.connect("player_clicked", self, "_on_player_clicked")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_player_clicked(start, end, player):
	print("\n\n----\n--\n--\nCreating path")
	var new_path = nav_tiles.get_simple_path(start,end)
	player.update_path(new_path)


