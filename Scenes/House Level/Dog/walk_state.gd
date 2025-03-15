extends NodeState

@export var dog: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var detector: RayCast2D
@export var nav_agent: NavigationAgent2D


@export var min_speed: float = 15.0
@export var max_speed: float = 30.0
var speed: float

func _ready() -> void:
	call_deferred("character_setup") # call other functions after current frame has finsihed processing
	nav_agent.velocity_computed.connect(on_safe_velocity_computed)

func character_setup() -> void:
	await get_tree().physics_frame
	set_movement_target()

func set_movement_target() -> void:
	var target_pos: Vector2 = NavigationServer2D.map_get_random_point(nav_agent.get_navigation_map(), nav_agent.navigation_layers, false)
	nav_agent.target_position = target_pos
	speed = randf_range(min_speed, max_speed) # chooses a speed based off of the min and max, for different speeds
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		set_movement_target()
		return
	
		
	var target_position: Vector2 = nav_agent.get_next_path_position()
	var target_direction: Vector2 = dog.global_position.direction_to(target_position) # gets facing direction of character
	anim_sprite.flip_h = target_direction.x < 0 # easier way of saying if our character is pointing left, then flip the sprite as its default is looking right
	var velocity: Vector2 = target_direction * speed
	
	update_detector(target_direction)
	
	if detector.is_colliding():
		var target = detector.get_collider()
		if target and target.name == "Burglar": # Need to add burglar name
			transition.emit("Bark")
			
	if nav_agent.avoidance_enabled:
		nav_agent.velocity = velocity
	else:
		dog.velocity = velocity
		dog.move_and_slide()

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	dog.velocity = safe_velocity
	dog.move_and_slide()
	
func  _on_next_transition() -> void:
	if nav_agent.is_navigation_finished():
		dog.velocity = Vector2.ZERO
		transition.emit("Idle")

func _on_enter() -> void:
	anim_sprite.play("walk")
	
func _on_exit() -> void:
	nav_agent.target_position = dog.global_position
	dog.velocity = Vector2.ZERO
	anim_sprite.stop()
	
func update_detector(direction: Vector2):
	if direction.length() == 0:
		return
	
	direction = direction.normalized()
	detector.target_position = direction * 100 # long raycast because dog should have a good amount of vision
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		var damage_source = area.get_parent()
		var damage_val = damage_source.damage
		dog.take_damage(damage_val)
		transition.emit("Hurt")
