extends Camera2D

export (NodePath) var target
var target_offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target)
	target_offset = self.get_camera_position() - self.get_camera_screen_center()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = target.position + self.target_offset