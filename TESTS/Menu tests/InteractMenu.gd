extends PopupMenu

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var current_menu = 0

				 
export var menu_keys = ["Main", "Talk", "Trade", "Job", "Cancel"]
var menus_prompt_dict = "bees"# {menu_keys[0]: array(menu_keys[i] for i in range(1,5,1))}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("\nmenu map: ", #menu_map,
		  "\nmenu_keys:", menu_keys,
		  "\nmenu_prompt_dict:", menus_prompt_dict)


func make():
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
