extends NodeState

@export var guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var idle_state_timer: Timer = Timer.new()
@export var idle_state_time_interval: float = 1.5

var idle_state_timeout: bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)
	
func _on_process(_delta: float) -> void:
	if guard.health <= 0:
		transition.emit("Dead")

func _on_physics_process(_delta: float) -> void:
	pass

func  _on_next_transition() -> void:
	if idle_state_timeout:
		transition.emit("Walk")

func _on_enter() -> void:
	var direction = get_parent().last_direction
	
	if abs(direction.x) > abs(direction.y): # Horizontal movement
		if direction.x > 0:
			anim.flip_h = true
			anim.play("left_right")
		else:
			anim.flip_h = false
			anim.play("left_right")
	else: # Vertical Movement
		if direction.y > 0:
			anim.play("forward")
		else:
			anim.play("back")
			
	idle_state_timeout = false
	idle_state_timer.start()
	
func _on_exit() -> void:
	anim.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	idle_state_timeout = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		var damage_source = area.get_parent()
		var damage_val = damage_source.damage
		guard.take_damage(damage_val)
		transition.emit("Hurt")
