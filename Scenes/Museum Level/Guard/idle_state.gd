extends NodeState

@export var guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var idle_state_timer: Timer = Timer.new()
@export var idle_state_time_interval: float = 2.0

var idle_state_timeout: bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func  _on_next_transition() -> void:
	if idle_state_timeout:
		transition.emit("Walk")

func _on_enter() -> void:
	idle_state_timeout = false
	idle_state_timer.start()
	
func _on_exit() -> void:
	anim.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	idle_state_timeout = true
