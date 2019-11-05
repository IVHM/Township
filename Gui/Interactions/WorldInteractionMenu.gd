extends Node2D

export (NodePath) var pop_up 
export (NodePath) var menu_label  # Text displayed above the choice_container
export (NodePath) var choice_container # contains all the buttons needed for the menu
export (NodePath) var interaction_btn 

#var interaction_types = ["Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open"]
export (int, FLAGS, "Null","Talk", "Trade","Job","Cancel","Mine","Chop","Open") var interaction_choices = 0


var crnt_object = null
var crnt_choices = []
var crnt_buttons = []

export var testing = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pop_up = get_node(pop_up)
	menu_label = get_node(menu_label)
	choice_container = get_node(choice_container)
	interaction_btn = get_node(interaction_btn)

	
	if testing:
		pop_up.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_menu(menu_bit_flag, cancel_button=false):
	
	for crnt_type in GLOBALS.INTERACTION_TYPES.keys():
		if menu_bit_flag & GLOBALS.INTERACTION_TYPES[crnt_type] != 0:
			self.crnt_choices.append(crnt_type)

	if len(crnt_choices) > 0:
		for i in range(len(crnt_choices)):
			crnt_buttons.append(interaction_btn.instance())
			
			








