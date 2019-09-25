extends Node2D

export var def_start = Vector2(0,0)
export var def_end = Vector2(70,50)
onready var cur_path = $MousePath
onready var pc = $MousePath/Player


# Called when the node enters the scene tree for the first time.
func _ready():
	def_start = pc.position 
	create_path(def_start, def_end)
	pc.change_state(1)
	
func _process(delta):
	pass

func create_path(start,end):
	print("\n\n----\n--\n--\nCreating path")
	var new_path = $TileNavigation.get_simple_path(start,end)
#	var last_curve = cur_path.get_curve()
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

func _input(event):
	if event is InputEventMouseButton:
		#pc.change_state(0)
		var new_end_point = get_global_mouse_position() 
		var new_start_point = pc.position
		print("new_end_point", new_end_point, " : new_start_point", new_start_point)
		create_path(new_start_point, new_end_point)
		
