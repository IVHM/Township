extends Node2D
export (PackedScene) var PathNode
export (PackedScene) var Townsfolk
export (PackedScene) var Intersection
var rnd = RandomNumberGenerator.new()
var path_list = []
var win_size = OS.window_size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var temp_path = PathNode.instance()
		var rx = rnd.randi_range(0,win_size.x)
		var ry = rnd.randi_range(0,win_size.y)
		temp_path.position = Vector2(rx,ry)
		path_list.append(temp_path)
		add_child(path_list[-1])
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
