extends Node2D

export (NodePath) var pop_up 
export (NodePath) var menu_label  # Text displayed above the choice_container
export (NodePath) var choice_container # contains all the buttons needed for the menu
export (PackedScene) var interaction_btn 

#var interaction_types = ["Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open"]



var crnt_object = null
var crnt_choices = []
var crnt_buttons = []

signal interaction_choice 


###TESTING VARS
export var testing = false
export var t_print = true
var first_run = true
export (int, FLAGS, "Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open") var testing_choices = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pop_up = get_node(pop_up)
	menu_label = get_node(menu_label)
	choice_container = get_node(choice_container)


	
	if testing:
		create_menu(testing_choices, self )
		print("created menu")
		pop_up.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
##	
# Creates a menu based on a bit flagged menu choice
func create_menu(pos, objects, cancel_button=false):
	UTIL.remove_all_children(choice_container)

	
	for obj in objects:
		var menu_bit_flag = GLOBALS.OBJECT_TYPES[obj.object_type]
		# Cycle through interaction type bit flags and bitwise & them 
		for crnt_type in GLOBALS.INTERACTION_TYPES.keys():
			if menu_bit_flag & GLOBALS.INTERACTION_TYPES[crnt_type] != 0:
				create_button(crnt_type, obj)
	
	if cancel_button:
		create_button("Cancel", null)

		

##
# Creates and adds a button of the specified type to the choice container
func create_button(type, object):
	crnt_buttons.append(interaction_btn.instance())
	choice_container.add_child(crnt_buttons[-1])    
	crnt_buttons[-1].initialize_button(type, object) 
	crnt_buttons[-1].generate()
	crnt_buttons[-1].connect("interaction_button_pressed", 
								self, "_on_choice_made")		


##
# Either sends out a signal to the main hub with the button choice or closes the menu.
func _on_choice_made(type):
	if type != "Cancel":
		emit_signal("interaction_choice", type)
		print(type, "button pressed")
	else:
		pop_up.hide()
		



