extends NodeState

@export var guard: CharacterBody2D
@export var detector: RayCast2D
@export var nav_agent: NavigationAgent2D
@export var anim: AnimatedSprite2D
@export var speed: float = 20
@export var sound: AudioStreamPlayer2D
@export var surprised_texture: Sprite2D
@export var burglar_detection: Area2D
@export var vision_cone: Polygon2D
@onready var raycast_container: Node2D

@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")

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
	if detector.is_colliding() and detector.get_collider() == burglar:
		is_following = true
		lost_burglar_time = 0
	else:
		lost_burglar_time += _delta
		if lost_burglar_time > MAX_LOST_TIME:
			is_following = false
			transition.emit("Walk")

func _on_physics_process(_delta: float) -> void:
	if is_following and burglar:
		follow_burglar()

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	surprised_texture.show()
	sound.play()
	detector.enabled = true
	nav_agent.target_position = burglar.global_position
	if !is_following:
		transition.emit("Walk")
	
func _on_exit() -> void:
	surprised_texture.hide()
	
func follow_burglar() -> void:
	target_pos = burglar.global_position
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
