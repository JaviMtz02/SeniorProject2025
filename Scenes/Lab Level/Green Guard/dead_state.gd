extends NodeState

@export var green_guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	green_guard.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	green_guard.move_and_slide()

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	green_guard.velocity = Vector2.ZERO 
	green_guard.move_and_slide()
	# play some dying sound here
	nav_agent.avoidance_enabled = false
	anim.play("dead")
	await anim.animation_finished
	green_guard.queue_free()
	queue_free()
	
func _on_exit() -> void:
	pass
