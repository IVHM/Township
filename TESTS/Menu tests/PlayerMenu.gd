extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var interaction_menu = $Camera2D/InteractionsMenu
onready var trading_menu = $Camera2D/TradingMenu



##################
##TEST VARIABLES##
var tmp_player_inventory = {"stone": 30, "wood": 20, "coal": 10,
							"hammer": 5, "axe": 5, "saw": 12,
							"nickel": 10, "iron": 13, "wheat": 30,
							"cabbage": 15, "carrot": 40, "potatoes": 30,
							"pickaxe": 3
						   }
var tmp_townsfolk_inventory = {"stone": 30, "wood": 20, "hammer": 5}

##################

# Called when the node enters the scene tree for the first time.
func _ready():
	trading_menu.set_visible(false)
	interaction_menu.set_visible(false)


func _on_InteractionsMenu_choice_pressed(choice):
	print("recieved signal choice_pressed", choice)
	if choice == "trade":
		trading_menu.load_items(tmp_player_inventory, tmp_townsfolk_inventory)
		interaction_menu.set_visible(false)
		trading_menu.set_visible(true)
		