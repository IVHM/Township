extends KinematicBody2D

#export (NodePath) var Sprite


var moving = false
export (int) var speed = 40

# PATH VARIABLES
var current_path     # PoolVector2Array of point that correspond to the points on an astar path
var calculated_path = PoolVector2Array() # Path used while testing if the path is clear
var requested_path   # Used to hold requested paths before processing
var path_clear = false
var crnt_point = 0
var next_point = 1
var heading


#### TESTING
export var testing = false
export var t_print = false 
signal path_completed




func _ready():
	pass

func _process(delta):
		
	if moving:
		if next_point == len(current_path):  # Check if we've reached the end of the path
			moving = false
		else:
			var heading = current_path[crnt_point] - current_path[next_point]
			var dist_to_next = heading.length() 
			var movement_vec = heading.normalized() * speed
			if movement_vec.length() > dist_to_next:
				movement_vec = heading 
				crnt_point += 1
				next_point += 1
			
			self.set_global_rotation(heading.angle())
			self.move_and_slide(movement_vec)

##
# Emits a signal requesting a path update from the control hub
func path_request(start, end):
	EVENTS.emit_signal("path_request", start, end, self)


func create_path(new_path):
	update_path(new_path)
	check_path(new_path[0], new_path[-1])
	print("while ran for a while", calculated_path)
##
# takes in the requested path and stores it 
func update_path(new_path):
	requested_path = new_path
	#if t_print: print("Requested path updated: \n", requested_path)
##
# Goes through the path and makes sure there are no collisions a 
func check_path(start, end):
	var safe_point = start  # Sets the begining of the path
	
	### CODE TO MAKE SURE INITIAL LOCATION IS COLLISION FREE GOES HERE ###
	print(" path checking started")
	var while_cnt = 0
	# Run through the path until we've reached the last point in the path
	while !path_clear:
		path_request(safe_point, end)  # Request a new path from the last safe point 
		
		for i in range(len(requested_path)-1):  # Runs through each point in requested_path 

			if len(requested_path) == 1:
				calculated_path.append(requested_path[0])
				current_path = calculated_path   # Set the current path
				calculated_path = PoolVector2Array() # reset 
				moving = true
				path_clear = true
				print("legal path created")
				emit_signal("path_completed", current_path)
				break

			elif collision_detect(requested_path[i], requested_path[i+1]): # And checks to see if collision occurs between it and the next in libe
				print("path collision detected")
				safe_point = requested_path[i]                           # If so it sets a new safe point
				for j in range(i):                                     # And adds all the already checked points to the calculated_path
					calculated_path.append(requested_path[j])

				var rel_vec = requested_path[i+1] - requested_path[i]    # Now we try to calculate a new collision free path
				var left = safe_point + rel_vec.rotated(-PI/8)
				var right = safe_point + rel_vec.rotated(PI/8)
				var left_clear = collision_detect(safe_point, left)
				var right_clear = collision_detect(safe_point, right)
				
				if left_clear and right_clear:   # Checks to see if any of the new paths are free
					var dist_left = left.distance_to(end)
					var dist_right = right.distance_to(end)
					if dist_left < dist_right:   # If both are choose the one closest to end point
						safe_point = left
					else:
						safe_point = right
				elif left_clear:
					safe_point = left
				elif right_clear:
					safe_point = right
				else:
					print("Sorry don't knopw what to do when both new paths collide")
					print("I haven't writen code for this bit yet, forgive me")
				
				# Once we've created a new safe_point we break out of the loop and start again from new safe_point
				break

			# If there were no collisions detected and the next point is the end
		if path_clear:
			break	
		while_cnt += 1
		if while_cnt>200:
			print("while ran for a while", calculated_path, current_path)
			break
					
##
# Moves a virtual body between the teo given vectors and returns true if a 
func collision_detect(start, end):
	var rel_vec = end - start
	return self.test_move(self.get_transform(), rel_vec)


##

