extends Node2D

# Controls the size and layout of the two inventory gridcontainers
export var items_per_page = 12
export var total_pages = 3
var num_player_pages = 1
var num_townsfolk_pages = 1
var current_player_page = 0
var current_townsfolk_page = 0
var player_items = null  # A dictionary containing the name and quantity of items in the payers inventory
var player_buttons = [] # An array to hold the different item buttons
# The GridContainer that parents the buttons 
export (PackedScene) onready var player_inventory = $PlayerTrade/PlayerItems/PlayerInventory
export (PackedScene) onready var player_inventory_holding = $PlayerInventoryHolding

var townsfolk_items = null
var townsfolk_buttons = []
export (PackedScene) onready var   = $TownsfolkTrade/TownsfolkItems/TownsfolkInventory
export (PackedScene) onready var townsfolk_inventory_holding = $TownsfolkInventoryHolding
# Get the TradeItemButton Node
onready var item_button = load("res://TESTS/Menu tests/TradeItemButton.tscn")


func _ready():
	# Create the intial pages of buttons and pair the first page to displayed grid container
	for x in range(total_pages):
		player_buttons.append([])
		townsfolk_buttons.append([])
		for y in range(items_per_page):
			player_buttons[x].append(item_button.instance())
			townsfolk_buttons[x].append(item_button.instance())
			if x == 0:
				player_inventory.add_child(player_buttons[x][y])
				townsfolk_inventory.add_child(townsfolk_buttons[x][y])
			else:
				player_inventory_holding.add_child(player_buttons[x][y])
				townsfolk_inventory_holding.add_child(townsfolk_buttons[x][y])

	
	
##
# loads in a new
func load_items(player_items_IN, townsfolk_items_IN):
	self.player_items = player_items_IN
	self.townsfolk_items = townsfolk_items_IN
	create_buttons()


##
#
func create_buttons():
	var ix = Vector2(0,0)
	for i in self.player_items:

		print(ix.x, ix.y)		
		player_buttons[ix.x][ix.y].initialize_button(ix, i, self.player_items[i])
		ix.y += 1
		if ix.y == items_per_page:
			self.num_player_pages += 1
			ix.x += 1
			ix.y = 0
			
	print(self.num_player_pages)

	ix = Vector2(0,0)
	for i in self.townsfolk_items:
		townsfolk_buttons[ix.x][ix.y].initialize_button(len(player_buttons), i, self.townsfolk_items[i])
		ix.y += 1
		if ix.y == items_per_page:
			self.num_townsfolk_pages += 1
			ix.x += 1
			ix.y = 0


##
#
func _on_CancelTrade_pressed():
	self.visible = false
	clear_buttons()

func add_buttons():
	pass

##
#
func clear_buttons(player=true, townsfolk=true):
	if player:
		for i in range(self.num_player_pages):
			for btn in player_buttons[i]:
				btn.reset_button()

	if townsfolk:
		print(townsfolk_buttons)
		for i in range(self.num_townsfolk_pages):
			for btn in townsfolk_buttons[i]:
				btn.reset_button()


##
#
func switch_page(agent):

	if agent == "p":
		for btn in self.player_inventory.get_children():
			self.player_inventory.remove_child(btn)
			self.player_inventory_holding.add_child(btn)
		for btn in player_buttons[self.current_player_page]:
			self.player_inventory_holding.remove_child(btn)
			self.player_inventory.add_child(btn)
	
	if agent == 't':
		for btn in self.townsfolk_inventory.get_children():  # Remove old buttons
			self.townsfolk_inventory.remove_child(btn)
		for btn in townsfolk_buttons[self.current_townsfolk_page]:  # Add new buttons
			self.townsfolk_inventory.add_child(btn)




##
# Page Navigation menu buttons
func _on_PlayerTradePrevPage_pressed():
	var prev_page = self.current_player_page
	if self.num_player_pages > 1:
		if self.current_player_page == 0:
			self.current_player_page = self.num_player_pages
		else:
			self.current_player_page -= 1
		
		switch_page("p")


func _on_PlayerTradeNextPage_pressed():
	var prev_page = self.current_player_page
	if self.num_player_pages > 1:
		if self.current_player_page == (self.num_player_pages - 1):
			self.current_player_page = 0
		else:
			self.current_player_page += 1
		
		switch_page("p")


func _on_TownsfolkTradeNextPage_pressed():
	var prev_page = self.current_townsfolk_page
	if self.num_townsfolk_pages > 1:
		if self.current_townsfolk_page == (self.num_townsfolk_pages - 1):
			self.current_townsfolk_page = 0
		else:
			self.current_townsfolk_page += 1
		
		switch_page("p")


##
# 
func _on_TownsfolkTradePrevPage_pressed():
	var prev_page = self.current_townsfolk_page
	if self.num_townsfolk_pages > 1:
		if self.current_townsfolk_page == 0:
			self.current_townsfolk_page = self.num_townsfolk_pages
		else:
			self.current_townsfolk_page -= 1
		
		switch_page("p")

