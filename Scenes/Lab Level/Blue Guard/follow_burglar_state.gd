extends NodeState

@export var guard: CharacterBody2D
@export var detector: RayCast2D
@export var nav_agent: NavigationAgent2D
@export var anim: AnimatedSprite2D
@export var speed: float = 60
@export var burglar_detection: Area2D
@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")

var target_pos: Vector2
var is_following: bool = true
var lost_burglar_time: float = 0.0
const MAX_LOST_TIME: float = 0.5


func _ready() -> void:
	burglar_detection.area_entered.connect(_on_area_entered)
	
func _on_process(_delta: float) -> void:
	if detector.is_colliding() and detector.get_collider() == guard.burglar:
		is_following = true
		lost_burglar_time = 0
	else:
		lost_burglar_time += _delta
		if lost_burglar_time > MAX_LOST_TIME:
			is_following = false
			transition.emit("Walk")

func _on_physics_process(_delta: float) -> void:
	if is_following and guard.burglar:
		follow_burglar()
	else:
		stop_guard()

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	detector.enabled = true
	nav_agent.target_position = guard.burglar.global_position
	if !is_following:
		transition.emit("Walk")
	
func _on_exit() -> void:
	guard.burglar = null
	
func follow_burglar() -> void:
	if not is_following:
		stop_guard()
		return
	target_pos = guard.burglar.global_position
	nav_agent.target_position = target_pos
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - guard.global_position).normalized()
	var velocity = direction * speed
	update_animation(direction)
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

func stop_guard() -> void:
	guard.velocity = Vector2.ZERO
	guard.move_and_slide()
	anim.stop()
