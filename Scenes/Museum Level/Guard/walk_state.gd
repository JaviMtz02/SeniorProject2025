extends NodeState

@export var guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D
@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")
@export var min_speed: float = 20
@export var max_speed: float = 35
@export var vision_cone: Polygon2D
@onready var raycast_container: Node2D
@export var detection_radius: Area2D
@onready var looking_timer: Timer = $"../../LookingTimer"


var speed: float

const NUM_RAYS = 10
const RAY_SPREAD = PI / 4
const RAY_LENGTH = 75

func _ready() -> void:
	for door in get_tree().get_nodes_in_group("doors"):
		door.freeze.connect(_on_freeze_emitted)
	
	create_vision_rays()
	call_deferred("character_setup")
	nav_agent.velocity_computed.connect(on_safe_velocity_computed)
	
func character_setup() -> void:
	await get_tree().physics_frame
	call_deferred("set_moving_target")

func set_moving_target() -> void:
	randomize()
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
	if target_direction != Vector2.ZERO:
		get_parent().last_direction = target_direction
		
	var velocity: Vector2 = target_direction * speed
	update_animation(target_direction)
	update_vision_rays(target_direction)
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
		if collider.is_in_group("Burglar"):
			guard.burglar = collider
			transition.emit("FollowBurglar")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		var damage_source = area.get_parent()
		var damage_val = damage_source.damage
		guard.take_damage(damage_val)
		transition.emit("Hurt")

func _on_freeze_emitted() -> void:
	transition.emit("Frozen")

func create_vision_rays() -> void:
	raycast_container = Node2D.new()
	guard.add_child.call_deferred(raycast_container)
	
	for i in range(NUM_RAYS):
		var ray = RayCast2D.new()
		ray.enabled = true
		ray.target_position = Vector2(RAY_LENGTH, 0)
		raycast_container.add_child(ray)

func update_vision_rays(direction: Vector2) -> void:
	var start_angle = direction.angle() - RAY_SPREAD / 2
	var points = [Vector2.ZERO]
	for i in range(NUM_RAYS):
		var angle = start_angle + (i / float(NUM_RAYS - 1)) * RAY_SPREAD
		var ray = raycast_container.get_child(i)
		var dir = Vector2.RIGHT.rotated(angle) * RAY_LENGTH
		
		ray.target_position = dir
		ray.force_raycast_update()
		
		var end_point = ray.get_collision_point() if ray.is_colliding() else guard.global_position + dir
		points.append(end_point - guard.global_position)
	vision_cone.polygon = points


func _on_detection_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Burglar"):
		nav_agent.target_position = body.global_position
		looking_timer.start()

func _on_looking_timer_timeout() -> void:
	set_moving_target()
