extends TextureButton

# File reference variables
export (String, "Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open") var button_type = "Null"
export (String) var icon_folder_path = "res://Assets/Menu_icons/Interactions/" 
# Display nodes
export (NodePath) var btn_label
export (NodePath) var icon_highlight
export (NodePath) var icon

signal interaction_button_pressed

###TESTING VARS
export var testing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	btn_label = get_node(btn_label)
	icon = get_node(icon)
	icon_highlight= get_node(icon_highlight)

	if testing == true:
		generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

##
# Sets the button_type based on an inputed string derived from the global var interaction types
func set_button_type(button_type_in):
	var value_type = typeof(button_type_in)
	if value_type == TYPE_STRING:
		self.button_type = button_type_in
	else:
		print("please use an string to set interactive button type")
		print("These can be found in GLOBALS.gd")
##
# Creates the button with it's stored text and icon data
func generate():
	btn_label.set_text(button_type)
	icon.set_texture(load(icon_folder_path + button_type + ".png"))
	icon_highlight.set_texture(load(icon_folder_path + button_type + ".png"))


##
#
func _on_InteractionsButton_pressed():
	emit_signal("interaction_button_pressed", button_type)
	print("marco1?")

