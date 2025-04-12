extends NodeState

@export var green_guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D

@onready var hurt_state_timer: Timer = Timer.new()
@export var hurt_state_time_interval: float = 2.0

var hurt_state_timeout: bool = false

func _ready() -> void:
	hurt_state_timer.wait_time = hurt_state_time_interval
	hurt_state_timer.timeout.connect(on_hurt_state_timeout)
	add_child(hurt_state_timer)
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	green_guard.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	green_guard.move_and_slide()

func  _on_next_transition() -> void:
	if hurt_state_timeout:
		transition.emit("Walk")

func _on_enter() -> void:
	$"../../SFX/Hurt".play()
	var direction = get_parent().last_direction
	green_guard.velocity = Vector2.ZERO
	green_guard.move_and_slide()
	nav_agent.avoidance_enabled = false
	hurt_state_timeout = false
	hurt_state_timer.start()
	
	if abs(direction.x) > abs(direction.y): # Horizontal movement
		if direction.x > 0:
			anim.flip_h = true
			anim.play("hurt_left_right")
		else:
			anim.flip_h = false
			anim.play("hurt_left_right")
	else: # Vertical Movement
		if direction.y > 0:
			anim.play("hurt_forward")
		else:
			anim.play("hurt_forward")
	
func _on_exit() -> void:
	hurt_state_timer.stop()
	nav_agent.avoidance_enabled = true
	
func on_hurt_state_timeout() -> void:
	hurt_state_timeout = true
