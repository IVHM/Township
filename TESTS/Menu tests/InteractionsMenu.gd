extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pop_container = $Container
signal choice_pressed 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


func _process(delta):
	pass

func _input(event):
	
	if event.is_action_pressed("ui_mouse_right"):
		print("mouse clicked")
		self.position = get_global_mouse_position()
		self.visible = true 

func _on_Trade_pressed():
	print("emitting signal choice_pressed")
	emit_signal("choice_pressed", "trade")