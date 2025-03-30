extends Node
class_name Walker

const DIRECTIONS : Array = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var position : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.RIGHT
var borders = Rect2()
var step_history : Array = []
var steps_since_turn : int = 0
var rooms : Array = []
var available_rooms = []

# Initialize levels borders and starting position
func _init(start_position, new_borders) -> void:
	assert(new_borders.has_point(start_position)) # Ensure start position is within defined borders
	position = start_position
	step_history.append(position)
	borders = new_borders

# Return list of vectors of the positions walked
func walk(steps) -> Array:
	place_room(position)
	
	for step in range(steps):
		if steps_since_turn >= 6: # Change walker direction after 6 steps
			change_direction()
		
		if valid_step(): # If the step is validated...
			step_history.append(position)
		else: # Otherwise...
			change_direction()
	available_rooms = rooms
	return step_history

# Determine in step is valid (within the defined borders)
func valid_step() -> bool:
	var target_position : Vector2 = position + direction
	
	if borders.has_point(target_position): # If target positon is within borders...
		steps_since_turn += 1
		position = target_position # Update current position of walker
		return true
	else: # Otherwise...
		return false

# Change direction of walker
func change_direction() -> void:
	place_room(position)
	
	var directions_copy : Array = DIRECTIONS.duplicate() # Create copy of DIRECTIONS
	steps_since_turn = 0
	
	directions_copy.erase(direction) # Remove current direction from copy
	directions_copy.shuffle() # Shuffle the list
	direction = directions_copy.pop_front() # Change direction to first item in copy and remove it
	
	while not borders.has_point(position + direction): # Pick different direction if not within borders
		direction = directions_copy.pop_front()

func create_room(position, size) -> Dictionary:
	return {position = position, size = size}

func place_room(position) -> void:
	var size = Vector2(randi() % 2 + 3, randi() % 2 + 3)
	var top_left = (position - size / 2).ceil()
	
	rooms.append(create_room(position, size))
	
	for y in size.y:
		for x in size.x:
			var new_step = top_left + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room() -> Dictionary:
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
			available_rooms.erase(room)
	return end_room
