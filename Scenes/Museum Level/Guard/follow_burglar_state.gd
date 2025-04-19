extends NodeState

@export var guard: CharacterBody2D
@export var detector: RayCast2D
@export var nav_agent: NavigationAgent2D
@export var anim: AnimatedSprite2D
@export var speed: float = 50
@export var sound: AudioStreamPlayer2D
@export var surprised_texture: Sprite2D
@export var burglar_detection: Area2D
@export var vision_cone: Polygon2D
@export var throwable: PackedScene
@onready var raycast_container: Node2D

@onready var looking_timer: Timer = $"../../LookingTimer"

var attack_timer: Timer
var target_pos: Vector2
var is_following: bool = true
var lost_burglar_time: float = 0.0
const MAX_LOST_TIME: float = 1.0

const NUM_RAYS = 10
const RAY_SPREAD = PI / 4
const RAY_LENGTH = 75

func _ready() -> void:
	create_vision_rays()
	burglar_detection.area_entered.connect(_on_area_entered)
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	if guard.burglar:
		follow_burglar()

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	surprised_texture.show()
	sound.play()
	detector.enabled = true
	looking_timer.start()
	if detector.is_colliding():
		var collider = detector.get_collider()
		if collider.is_in_group("Burglar"):
			throw_item()
	
func _on_exit() -> void:
	#guard.burglar = null # Resets to empty for multiplayer purposes :D
	surprised_texture.hide()
	
func follow_burglar() -> void:
	target_pos = guard.burglar.global_position
	nav_agent.target_position = target_pos
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - guard.global_position).normalized()
	var velocity = direction * speed
	update_animation(direction)
	update_vision_rays(direction)
	update_detector(direction)
	nav_agent.velocity = velocity
	guard.velocity = velocity
	guard.move_and_slide()
	
func update_detector(direction: Vector2) -> void:
	if direction.length() == 0:
		return
	direction = direction.normalized()
	detector.target_position = direction * 75
	
func update_animation(direction: Vector2) -> void:
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
	
func _on_area_entered(_area: Area2D) -> void:
	transition.emit("Idle")

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

func _on_looking_timer_timeout() -> void:
	transition.emit("Walk")

func throw_item() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.4  # Duration of attack animation	
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_finished)
	add_child(attack_timer)
	
	var direction_to_burglar = (guard.burglar.global_position - guard.global_position).normalized()
	var attack_instance = throwable.instantiate()
	attack_timer.start()  # Start cooldown timer
	get_parent().add_child(attack_instance)
	attack_instance.global_position = guard.global_position
	attack_instance.direction = direction_to_burglar
	
func _on_attack_finished() -> void:
	pass
