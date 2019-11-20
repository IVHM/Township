extends TextureButton

# File reference variables
export (String, DIR) var icon_folder_path = "res://Assets/Menu_icons/Interactions/" 
# Display nodes
export (NodePath) var btn_label
export (NodePath) var icon_highlight
export (NodePath) var icon

var button_type  # The kind of interaction button it is
var owner_ref  # A link back to the instance of the object
var owner_name  # The name of the owner
var display_text 

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
func _process(delta):
	if self.pressed:
		emit_signal("interaction_button_pressed", button_type, owner_ref)
		print("marco1?")
##
# Sets the button_type based on an inputed string derived from the global var interaction types
func initialize_button(button_type_in, object):
	var value_type = typeof(button_type_in)
	if value_type == TYPE_STRING:
		self.button_type = button_type_in
		self.owner_name = object.object_name
		self.owner_ref = object
	else:
		print("please use an string to set interactive button type")
		print("These can be found in GLOBALS.gd")
##
# Creates the button with it's stored text and icon data
func generate():
	btn_label.set_text(button_type + "  (" + owner_name + ")")
	icon.set_texture(load(icon_folder_path + button_type + ".png"))
	icon_highlight.set_texture(load(icon_folder_path + button_type + ".png"))


