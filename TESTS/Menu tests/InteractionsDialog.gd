extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pop_container = $Container
onready var pop_up = $InteractMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pop_container.visible = false
	#print("\n\nPopContainer",pop_container.position)

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_mouse_right"):
		self.position = get_global_mouse_position()
		pop_container.visible = true 



func _on_Trade_pressed():
	pass # Replace with function body.
