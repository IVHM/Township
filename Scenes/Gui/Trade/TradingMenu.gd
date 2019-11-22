extends Node2D

# Controls the size and layout of the two inventory GridContainers
enum MenuModes {TOWNSFOLK, INVENTORY} # The different modes the trade menu works on
export (MenuModes) var trade_mode 
export var items_per_page = 12
export var total_pages = 1
var num_player_pages = 1
var num_trader_pages = 1
var current_player_page = 0
var current_trader_page = 0

signal trade_completed


####INVENTORY VARIABLES####
# PLAYER
var player_ref = null  # A reference back to the player object
var player_items = null  # A dictionary containing the name and quantity of items in the payers inventory
var player_buttons = [[]]  # An array to hold the different item buttons
# The GridContainer that parents the buttons 
export (NodePath) var player_inventory  # All the items being displayed on current page
export (NodePath) var player_inventory_holding  # Used to hold the items that aren't being displayed
var player_inventory_change = {}  # Dictionary to be sent back to payer for update

# TRADER
var trader_ref = null
var trader_items = null
var trader_buttons = [[]]
export (NodePath) var  trader_inventory
export (NodePath) var trader_inventory_holding 
var trader_inventory_change = {}


# Get the TradeItemButton Node
export (String, FILE) var item_button

signal trade_completed

func _ready():
	print("is this loading?")
	

func intializes_references():
	item_button = load(item_button)
	print("item_button: ", item_button)
	player_inventory = get_node(player_inventory)
	player_inventory_holding = get_node(player_inventory_holding)
	trader_inventory = get_node(trader_inventory)
	player_inventory_holding = get_node(trader_inventory_holding)
##
# Loads in inventories in the form of {"Item_name": item_amt,...}
# and creates new buttons for each item in the inventory
func load_items(player_items_IN, player_ref, trader_items_IN, trader_ref):
	intializes_references()
	var tot = 0 # used to see if we've gone over the main page limit
	# load in the necessary inventory data
	self.player_items = player_items_IN
	self.player_ref = player_ref
	
	for item in player_items.keys():
		# Check if we've reached the page limit
		if tot > self.items_per_page:
			num_player_pages += 1  # Increases the number of pages
			player_buttons.append([]) # And adds a new column for the page
			tot = 0
		
		# Add a new button to the current column and initialize it
		player_buttons[-1].append(item_button.instance())
		
		# We're on the first page of buttons parent them to the display,
		# else add them to the holding pen
		if num_player_pages == 1:
			player_inventory.add_child(player_buttons[-1][-1])
		else:
			player_inventory_holding.add_child(player_buttons[-1][-1])

		player_buttons[-1][-1].initialize_button("p", item, player_items[item])
		player_buttons[-1][-1].connect("quantity_changed", self, "_on_quantity_changed")			
		
		tot += 1 # Increment the item counter

	tot = 0
	self.trader_items = trader_items_IN
	self.trader_ref = trader_ref
	for item in trader_items.keys():
		# Check if we've reached the page limit
		if tot > self.items_per_page:
			num_trader_pages += 1
			trader_buttons.append([])

		trader_buttons[-1].append(item_button.instance())
		if num_trader_pages == 1:
			trader_inventory.add_child(trader_buttons[-1][-1])
		else:
			trader_inventory_holding.add_child(trader_buttons[-1][-1])
		trader_buttons[-1][-1].initialize_button("t", item, trader_items[item])
		trader_buttons[-1][-1].connect("quantity_changed", self, "_on_quantity_changed")
		tot += 1



##
# Updates changes to inventory
func _on_quantity_changed(id, item, quantity):
	if id == "p":
		if item in player_inventory_change.keys():
			player_inventory_change[item] += quantity
		else:
			player_inventory_change[item] = quantity
	
	if id == "t":
		if item in player_inventory_change.keys():
			player_inventory_change[item] += quantity
		else:
			player_inventory_change[item] = quantity
##
#
func _on_CancelTrade_pressed():
	self.visible = false
	clear_buttons()

func add_buttons():
	pass

##
#
func clear_buttons(player=true, trader=true):
	if player:
		for i in range(self.num_player_pages):
			for btn in player_buttons[i]:
				btn.reset_button()

	if trader:
		print(trader_buttons)
		for i in range(self.num_trader_pages):
			for btn in trader_buttons[i]:
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
		for btn in self.trader_inventory.get_children():  # Remove old buttons
			self.trader_inventory.remove_child(btn)
		for btn in trader_buttons[self.current_trader_page]:  # Add new buttons
			self.trader_inventory.add_child(btn)


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

func _on_traderTradeNextPage_pressed():
	var prev_page = self.current_trader_page
	if self.num_trader_pages > 1:
		if self.current_trader_page == (self.num_trader_pages - 1):
			self.current_trader_page = 0
		else:
			self.current_trader_page += 1
		
		switch_page("p")

func _on_traderTradePrevPage_pressed():
	var prev_page = self.current_trader_page
	if self.num_trader_pages > 1:
		if self.current_trader_page == 0:
			self.current_trader_page = self.num_trader_pages
		else:
			self.current_trader_page -= 1
		
		switch_page("p")

