extends NodeState

@export var dog: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var bark_duration: float = 2
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D
# export var bark_sound: AudioStreamPlayer2D (for future uses)


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_enter() -> void:
	dog.velocity = Vector2.ZERO # Sets dog velocity to zero
	dog.move_and_slide()
	# play some dying sound here
	nav_agent.target_position = dog.global_position
	nav_agent.avoidance_enabled = false
	$"../../SFX/Dead".play()
	anim_sprite.play("dead")
	await anim_sprite.animation_finished
	
	# anything dog related stops as the dog loses all health
	dog.queue_free()
	queue_free()


func _on_physics_process(_delta: float) -> void:
	dog.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	dog.move_and_slide()
	
func _on_exit() -> void:
	pass

func _on_next_transition() -> void:
	pass
