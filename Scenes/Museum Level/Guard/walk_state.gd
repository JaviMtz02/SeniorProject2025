extends NodeState

@export var guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D
@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")

@export var min_speed: float = 20
@export var max_speed: float = 30
var speed: float


func _ready() -> void:
	call_deferred("character_setup")
	nav_agent.velocity_computed.connect(on_safe_velocity_computed)
	
func character_setup() -> void:
	await get_tree().physics_frame
	set_moving_target()

func set_moving_target() -> void:
	var target_pos: Vector2 = NavigationServer2D.map_get_random_point(nav_agent.get_navigation_map(), nav_agent.navigation_layers, false)
	nav_agent.target_position = target_pos
	speed = randf_range(min_speed, max_speed)
	
func _on_process(_delta: float) -> void:
	if detector.is_colliding():
		var collider = detector.get_collider()
		if collider == burglar:
			transition.emit("FollowBurglar")

func _on_physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		set_moving_target()
		return
		
	var target_position: Vector2 = nav_agent.get_next_path_position()
	var target_direction: Vector2 = guard.global_position.direction_to(target_position) 
	var velocity: Vector2 = target_direction * speed
	update_animation(target_direction)
	update_detector(target_direction)
	
	
	if nav_agent.avoidance_enabled:
		nav_agent.velocity = velocity
	else:
		guard.velocity = velocity
		guard.move_and_slide()
		
func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	guard.velocity = safe_velocity
	guard.move_and_slide()
	
func  _on_next_transition() -> void:
	if nav_agent.is_navigation_finished():
		guard.velocity = Vector2.ZERO
		transition.emit("Idle")

func _on_enter() -> void:
	detector.enabled = true
	
func _on_exit() -> void:
	nav_agent.target_position = guard.global_position
	guard.velocity = Vector2.ZERO
	
func update_animation(direction: Vector2):
	if direction.length() == 0:
		anim.frame = 0
		anim.stop()
		
	var abs_x = abs(direction.x)
	var abs_y = abs(direction.y)
	
	if abs_x > abs_y:
		if direction.x > 0:
			anim.flip_h = true
			anim.play("left_right")
		else:
			anim.flip_h = false
			anim.play("left_right")
	else:
		if direction.y > 0:
			anim.play("forward")
		else:
			anim.play("back")

func update_detector(direction: Vector2) -> void:
	if direction.length() == 0:
		return
	direction = direction.normalized()
	detector.target_position = direction * 75
	if detector.is_colliding():
		var collider = detector.get_collider()
		if collider == burglar:
			transition.emit("FollowBurglar")
