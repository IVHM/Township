extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Texture) var transparent_texture
export (Texture) var solid_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(body):
	if body.type == 'player':
		print('player entered')
		self.set_texture(self.transparent_texture)

func _on_Area2D_area_exited(body):
	if body.type == 'player':
		self.set_texture(self.solid_texture)