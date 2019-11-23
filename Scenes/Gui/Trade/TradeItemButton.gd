extends Button

var item_name = null
var id = null
var quantity = 0
export (NodePath) var quantity_label_path 
export (NodePath) var quantity_controls_path
export (NodePath) var slider

signal quantity_changed
onready var quantity_label 
onready var quantity_controls 
var icon_path = "res://Assets/Menu_icons/Items/"
var is_reset = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(self.quantity_label, self.quantity_label_path, '\n', self.quantity_controls, self.quantity_controls_path)

func initialize_references():
	print("ready was run")
	self.quantity_label = get_node(self.quantity_label_path)
	self.quantity_controls = get_node(self.quantity_controls_path)
	self.quantity_controls.set_visible(false)
	slider = get_node(slider)
	reset_button()	

##
# All buttons start in the "reset" state
func reset_button():
	self.item_name = "blank"
	load_icon()
	self.quantity_label.set_visible(false)
	self.set_flat(true) 
	self.set_disabled(true)
	self.is_reset = true


##
# The buttons are then intialized with their item information
func initialize_button(id_IN, item_name_IN, quantity_IN):
	initialize_references()
	self.id = id_IN
	self.item_name = item_name_IN
	self.quantity = quantity_IN
	print(self.quantity_label.get_text())
	load_icon()
	self.quantity_label.set_visible(true)
	self.set_flat(false)
	self.set_disabled(false)
	self.is_reset = false

	
##
# Here we load the specific icon for the item
func load_icon():
	var t_texture = self.icon_path + self.item_name + ".png"
	set_button_icon(load(t_texture))
	quantity_label.set_text(str(self.quantity))
	slider.set_max(self.quantity)
	slider.set_value(0)



func _on_TradeItemButton_pressed():
	quantity_controls.visible = true

func _on_ConfirmQuantity_pressed():
	print("confirm quantity pressed on", self.id, self.item_name)
	var quantity_change = slider.get_value()
	quantity_controls.visible = false
	if quantity_change > 0:
		self.quantity -= quantity_change
		self.load_icon()
		emit_signal("quantity_changed", self.id, self.item_name, quantity_change )
	