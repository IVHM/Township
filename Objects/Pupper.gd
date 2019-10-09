extends Path2D

export (NodePath) var follower


# ANIMATION
export var current_state = 0  # 0 - idle 1 - walk
export var animation_tags = [""]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	follower = get_node(path_follower)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
