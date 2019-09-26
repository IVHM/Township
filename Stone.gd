extends Area2D

export var type = "harvestable object"
export var subset = "stone"
var alive = true 
export var max_health = 50
var health = max_health
export var armor = 5

var crnt_anim_stage = 0
export var anim_stages = ["res://Assets/Nat_Materials/Stone/001/stone_breaking1.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking2.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking3.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking4.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking5.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking6.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking7.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking8.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking9.png",
						  "res://Assets/Nat_Materials/Stone/001/stone_breaking10.png"]


#export onready var anim_sprite = $Stone001
export onready var sprite = $Sprite 
export var max_inventory = {"stone": 400}
export var inventory = { "stone" : 400}
var total = null 


# Called when the node enters the scene tree for the first time.
func _ready():
	self.total = 0
	$Timer.start() # Usedfortesting
	for i in inventory.values():
		self.total += i
	sprite.set_texture(load(anim_stages[crnt_anim_stage]))




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func take_hit(dmg, body):
	if alive:
		
		dmg -= armor
		print(body, body.type) 
		if dmg > 0:
			health -= dmg
			
			var r = max_health / dmg
			var num_items =  max_inventory["stone"] / r
			
			self.inventory['stone'] -= num_items
			body.transfer({'bees' : num_items })

			print(health, "|", dmg, "|", r, "|", num_items, "|", inventory, "|", max_inventory) 
		else:
			print("Your tool is not strong enough")
		
		if health <= 0:
			alive = false
		
		check_anim_state()
	
func check_anim_state():
	var dif = max_health - health  # How much helath has been taken so far
	var hlth_per_frm = max_health / anim_stages.size()  # How many health lost = 1 frame
	var t_stage = floor(dif / hlth_per_frm) - 1 # How many frames shouls we have cycled through
	
	if t_stage != self.crnt_anim_stage:
		self.crnt_anim_stage = t_stage
		sprite.set_texture(load(anim_stages[self.crnt_anim_stage]))
	
	print("animation_check", t_stage , self.crnt_anim_stage)
	print(dif, hlth_per_frm)


func _on_Area2D_area_entered(body):
	pass

func _on_Timer_timeout():
	take_hit(6,self)
	$Timer.start()

func transfer(inventory_in):
	print("transfering", inventory_in)
	for i in inventory_in:
		if i in inventory.keys():
			inventory[i] += inventory_in[i]
		else:
			inventory[i] = inventory_in[i]