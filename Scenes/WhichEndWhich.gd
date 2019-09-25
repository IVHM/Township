extends Path2D

# Declare member variables here. Examples:
# var a = 2
var offset_pos = 0
onready var character = $TownsfolkContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	character.set_unit_offset(offset_pos)
	print("at position: ", offset_pos)
	$WhichEndTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_WhichEndTimer_timeout():
	if offset_pos == 0:
		offset_pos = .99
	else:
		offset_pos = 0
	
	character.set_unit_offset(offset_pos)
	print("at position: ", offset_pos)
	$WhichEndTimer.start()