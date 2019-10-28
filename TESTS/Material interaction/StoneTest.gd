extends Node2D

export (NodePath) var nav_tiles
export (NodePath) var pc
export (NodePath) var companion  


# Called when the node enters the scene tree for the first time.
func _ready():
	# Load in nodepaths
	self.pc = get_node(self.pc)
	self.companion = get_node(self.companion)
	self.nav_tiles = get_node(self.nav_tiles)
	
	# Subscribe to signal broadcasts
	pc.connect("player_path_request", self, "_on_player_path_request")
	#companion.connect("pupper_path_request", self, "_on_pupper_path_request")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Agent path requesting
func _on_player_path_request(start, end, player):
	print("\n\n----\n--\n--\nCreating path for PLAYER")
	path_request_handler(start, end, player)
	


func _on_Pupper_pupper_path_request(start,end,pupper):
	print("\n\n----\n--\n--\nCreating path for PUPPER")
	path_request_handler(start, end, pupper)


func path_request_handler(start, end, agent):
	var new_path = nav_tiles.get_astar_path(start,end)
	agent.update_path(new_path)