extends Node
class_name ObjectPlacer

enum ObjectType {
	ENEMY,
	DECORATION
}

var obj_defs = {
	ObjectType.ENEMY: {
		"scenes": [
			"res://Arcade Mode/Enemy/enemy.tscn",
		],
		"room_prob": 0.7,  # Probability of an object appearing in a room
		"min_distance": 3, # Minimum distance between objects of same type
		"density": 0.1     # Maximum percentage of room tiles that can have objects
	},
	ObjectType.DECORATION: {
		"scenes": [
			"res://Arcade Mode/Environment/Objects/Static/Test Tube/test_tube.tscn",
			"res://Arcade Mode/Environment/Objects/Static/Box/long_box.tscn",
			"res://Arcade Mode/Environment/Objects/Static/Barrel/hazard_barrel.tscn"
		],
		"room_prob": 0.9,
		"min_distance": 2,
		"density": 0.2
	}
}

var rng = RandomNumberGenerator.new()
var placed_objects = []
var occupied_positions = [] # Track all occupied positions regardless of type

func _init():
	rng.randomize()

# Place objects throughout available rooms
# Returns array of instances that were placed (caller is responsible for adding to scene)
func place_objects(rooms: Array, walkable_cells: Array, player_pos: Vector2) -> Array:
	placed_objects = []
	occupied_positions = []
	var instances = []
	
	# don't place objects too close to player spawn
	var player_cell = (player_pos / 32).floor()
	var buffer_zone = []
	for x in range(-2, 3):
		for y in range(-2, 3):
			buffer_zone.append(player_cell + Vector2(x, y))
	
	# Identify passage tiles (corridor entrances/exits)
	var passage_tiles = identify_passages(walkable_cells)
	
	# Process each room
	for room in rooms:
		# Calculate room boundaries
		var top_left = (room.position - room.size / 2).ceil()
		var available_positions = []
		
		# Get all valid positions in room
		for y in room.size.y:
			for x in room.size.x:
				var pos = top_left + Vector2(x, y)
				if walkable_cells.has(pos) and not buffer_zone.has(pos) and not occupied_positions.has(pos):
					available_positions.append(pos)
		
		# Process object types in order of priority
		var object_types = obj_defs.keys()
		object_types.sort() # Sort to ensure consistent ordering
		
		# Place each type of object
		for obj_type in object_types:
			if rng.randf() > obj_defs[obj_type].room_prob:
				continue  # Skip this object type for this room
				
			# Calculate how many objects we can place based on density
			var max_count = ceil(available_positions.size() * obj_defs[obj_type].density)
			var placed_count = 0
			var attempts = 0

			var type_available_positions = available_positions.duplicate()
			
			# For decorations, remove passage tiles from available positions
			if obj_type == ObjectType.DECORATION:
				for i in range(type_available_positions.size() - 1, -1, -1):
					if passage_tiles.has(type_available_positions[i]):
						type_available_positions.remove_at(i)
			
			while placed_count < max_count and attempts < max_count * 3 and type_available_positions.size() > 0:
				attempts += 1
				
				# Pick a random position
				var index = rng.randi() % type_available_positions.size()
				var pos = type_available_positions[index]
				
				# Check if too close to another object of same type
				var too_close = false
				for placed in placed_objects:
					if placed.type == obj_type and pos.distance_to(placed.pos) < obj_defs[obj_type].min_distance:
						too_close = true
						break
				
				if too_close:
					# Remove this position and try again
					type_available_positions.remove_at(index)
					continue
				
				# Place the object
				var scene_path = obj_defs[obj_type].scenes[rng.randi() % obj_defs[obj_type].scenes.size()]
				var instance = load(scene_path).instantiate()
				instance.position = pos * 32 + Vector2(16, 16)  # Center in tile
				instances.append(instance)
				
				# Record placement
				placed_objects.append({
					"type": obj_type,
					"pos": pos
				})
				
				# Mark this position as occupied
				occupied_positions.append(pos)
				
				# Remove this position from the main available positions list
				var pos_idx = available_positions.find(pos)
				if pos_idx >= 0:
					available_positions.remove_at(pos_idx)
				
				# Remove nearby positions from available list for this type to prevent overcrowding
				var min_dist = obj_defs[obj_type].min_distance
				for i in range(type_available_positions.size() - 1, -1, -1):
					if type_available_positions[i].distance_to(pos) < min_dist:
						type_available_positions.remove_at(i)
				
				placed_count += 1
	
	return instances

# Identify passage tiles (corridor entrances/exits) that should be kept clear
func identify_passages(walkable_cells: Array) -> Array:
	var passages = []
	var directions = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
	
	for cell in walkable_cells:
		# Count walkable neighbors
		var walkable_neighbors = 0
		for dir in directions:
			if walkable_cells.has(cell + dir):
				walkable_neighbors += 1
		
		# If the cell has 1-2 walkable neighbors, it might be a passage
		if walkable_neighbors <= 2:
			# Check if it connects two areas
			var is_passage = false
			
			# For each pair of opposite directions
			for i in range(2):  # 0: right/left, 1: up/down
				var has_path1 = walkable_cells.has(cell + directions[i])
				var has_path2 = walkable_cells.has(cell + directions[i+2])
				
				if has_path1 and has_path2:
					is_passage = true
					break
			
			if is_passage:
				passages.append(cell)
				
				# Also mark neighboring cells in the passage direction
				for dir in directions:
					if walkable_cells.has(cell + dir):
						passages.append(cell + dir)
	
	return passages

# Helper method to clear placed objects (useful when regenerating level)
func clear_placed_objects() -> void:
	placed_objects = []
	occupied_positions = []
	
# Utility function to check if a position can fit an object
# Useful for objects that take up more than one tile
func can_place_at(pos: Vector2, size: Vector2, walkable_cells: Array) -> bool:
	for y in size.y:
		for x in size.x:
			var check_pos = pos + Vector2(x, y)
			if not walkable_cells.has(check_pos) or occupied_positions.has(check_pos):
				return false
	return true
