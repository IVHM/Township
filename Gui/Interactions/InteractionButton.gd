extends TextureButton

export var interaction_types = ["Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open"]
export (int, "Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open") var button_type = 0
export (String) var icon_folder_path = "res://Assets/Menu_icons/Interactions/" 

export (NodePath) var btn_label
export (NodePath) var icon_highlight
#export (Texture) var icon_highlight_texture
export (NodePath) var icon
#export (Texture) var icon_texture

signal interaction_button_pressed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	btn_label = get_node(btn_label)
	icon = get_node(icon)
	icon_highlight= get_node(icon_highlight)

	btn_label.set_text(interaction_types[button_type])
	icon.set_texture(load(icon_folder_path + interaction_types[button_type] + ".png"))
	icon_highlight.set_texture(load(icon_folder_path + interaction_types[button_type] + ".png"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

##
# Sets the button_type based on an inputed int
func set_button_type(button_type_in):
	var value_type = typeof(button_type_in)
	if value_type == TYPE_INT || value_type == TYPE_REAL:
		self.button_type = int(button_type_in)
	else:
		print("please use an int or float  to set interactive button type")


func _on_InteractionsButton_pressed():
	emit_signal("interaction_button_pressed", button_type)
	print("marco1?")

