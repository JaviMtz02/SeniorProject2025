extends NodeState

@export var guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D
# export var bark_sound: AudioStreamPlayer2D (for future uses)


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_enter() -> void:
	guard.velocity = Vector2.ZERO 
	guard.move_and_slide()
	# play some dying sound here
	nav_agent.avoidance_enabled = false
	anim.play("dead")
	await anim.animation_finished
	guard.queue_free()
	queue_free()


func _on_physics_process(_delta: float) -> void:
	guard.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	guard.move_and_slide()
	
func _on_exit() -> void:
	pass

func _on_next_transition() -> void:
	pass
