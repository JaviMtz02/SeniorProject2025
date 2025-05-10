extends CharacterBody2D

@onready var anim_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO
var target_direction : Vector2 = Vector2.ZERO
var health = 100

@export var detection_radius = 125 # range of enemy sight
@export var minimum_distance = 12 # minimum distance to keep from player
@export var move_speed = 50
@export var circle_speed_multiplier = 1.3 # Speed boost when circling
@export var direction_change_speed = 2.0 # How quickly the enemy changes direction
@export var circle_direction_change_speed = 4.0 # Faster direction changes when circling
@export var random_movement_factor = 0.2 # How much randomness in movement

var player = null
var random_offset = Vector2.ZERO
var random_offset_timer = 0
var circling_mode = false
var circle_direction = 1 # 1 for clockwise, -1 for counter-clockwise
var last_circle_change_time = 0
var circle_change_cooldown = 1.0 # Minimum time between circle direction changes

var base_move_speed = 0  # Will store the original move_speed
var base_circle_speed_multiplier = 0  # Will store the original circle_speed_multiplier
var current_speed_factor = 1.0  # Multiplier for speed adjustments

var blend_value : float = 1.0

func _ready():
	player = get_tree().get_first_node_in_group("player") # identify player in scene
	# Initial random offset
	_update_random_offset()
	# Random circle direction
	circle_direction = 1 if randf() > 0.5 else -1
	
	# Store the base speeds
	base_move_speed = move_speed
	base_circle_speed_multiplier = circle_speed_multiplier
	
	# Add to enemy group for loot detection
	add_to_group("enemy")

func _physics_process(delta):
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		last_circle_change_time += delta
		
		# Update random movement direction occasionally
		random_offset_timer -= delta
		if random_offset_timer <= 0:
			_update_random_offset()
		
		if distance_to_player <= detection_radius: # if distance is less than sight radius
			# Calculate base direction toward player
			var to_player = global_position.direction_to(player.global_position)
			
			# Determine behavior based on distance
			if distance_to_player < minimum_distance:
				# Too close - circle around
				if not circling_mode:
					# Just entered circling mode - apply immediate direction change
					circling_mode = true
					
				# Create a perpendicular vector for circling
				var perpendicular = Vector2(-to_player.y, to_player.x) * circle_direction
				target_direction = perpendicular.normalized()
				
				# Add slight outward movement to maintain distance
				target_direction = (target_direction + to_player * -0.3).normalized()
				
				# Use faster direction change speed for circling
				direction = direction.lerp(target_direction, circle_direction_change_speed * delta)
				
				# Use faster speed when circling
				velocity = direction * (move_speed * circle_speed_multiplier)
			else:
				# Normal approach behavior with randomness
				circling_mode = false
				target_direction = to_player + random_offset * random_movement_factor
				target_direction = target_direction.normalized()
				
				# Standard direction change speed
				direction = direction.lerp(target_direction, direction_change_speed * delta)
				velocity = direction * move_speed
				
			# Set walking animation when moving
			is_walking(velocity.length() > 0.1)
			
			# Update blend_value based on direction
			if direction.x != 0:
				blend_value = direction.x
			# If you need vertical blend based on a top-down perspective, uncomment:
			# elif direction.y != 0:
			#     blend_value = direction.y
			
			# Update the animation blend position
			update_blend_position()
		else: # out of range of sight: stop enemy on the spot
			circling_mode = false
			# Gradually slow down when player is out of range
			velocity = velocity.lerp(Vector2.ZERO, 3 * delta)
			direction = direction.lerp(Vector2.ZERO, 3 * delta)
			
			# Set to idle when stopped
			is_walking(velocity.length() < 0.1)
			
			# Still update blend position
			update_blend_position()
		
		move_and_slide()

# Add a random offset to the movement direction
func _update_random_offset():
	random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	random_offset_timer = randf_range(0.5, 1.5) # Change direction every 0.5-1.5 seconds
	
	# Occasionally change circling direction, but not too frequently
	if randf() < 0.15 and last_circle_change_time > circle_change_cooldown:  
		circle_direction *= -1
		last_circle_change_time = 0

func take_damage(damage: int = 25) -> void:
	health -= damage
	if health <= 0:
		queue_free()

func update_blend_position() -> void:
	# Use the blend_value which is updated in _physics_process
	anim_tree["parameters/idle/blend_position"] = blend_value
	anim_tree["parameters/walk/blend_position"] = blend_value

func is_walking(value : bool) -> void:
	anim_tree["parameters/conditions/is_walking"] = value
	anim_tree["parameters/conditions/idle"] = not value
