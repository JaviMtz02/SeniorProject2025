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
	$"../../SFX/Dead".play
	var direction = get_parent().last_direction
	guard.velocity = Vector2.ZERO 
	guard.move_and_slide()
	# play some dying sound here
	nav_agent.avoidance_enabled = false
	if abs(direction.x) > abs(direction.y): # Horizontal movement
		if direction.x > 0:
			anim.flip_h = true
			anim.play("dead_left_right")
		else:
			anim.flip_h = false
			anim.play("dead_left_right")
	else: # Vertical Movement
		if direction.y > 0:
			anim.play("dead_forward")
		else:
			anim.play("dead_back")
			
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
