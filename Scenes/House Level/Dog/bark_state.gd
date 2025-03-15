extends NodeState

@export var dog: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var bark_duration: float = 2
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D
# export var bark_sound: AudioStreamPlayer2D (for future uses)

@onready var bark_timer: Timer = Timer.new()

var burglar

func _ready() -> void:
	bark_timer.wait_time = bark_duration
	burglar = get_tree().get_first_node_in_group("Burglar")
	# Once the burglar no longer is colliding with the Ray Cast, the timer will finish executing and then 
	# go to the idle state
	bark_timer.timeout.connect(on_bark_finished)
	
	add_child(bark_timer)

func _process(delta: float) -> void:
	pass

func _on_enter() -> void:
	dog.velocity = Vector2.ZERO # Sets dog velocity to zero
	dog.move_and_slide()
	anim_sprite.play("attack")
	# play some barking sound here
	nav_agent.target_position = dog.global_position
	var collider = detector.get_collider()
	# As long as the dog is looking at the burglar, the burglar will get time deducted off the clock
	if collider and collider.name == "Burglar":
			deduct_burglar_time()
	# IMPORTANT: avoidance must be disabled otherwise dog will continue to glide
	nav_agent.avoidance_enabled = false
	# add some logic for sound
	bark_timer.start()

func _on_physics_process(_delta: float) -> void:
	dog.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	dog.move_and_slide()
	
func _on_exit() -> void:
	anim_sprite.stop()
	bark_timer.stop()
	nav_agent.avoidance_enabled = true

func _on_next_transition() -> void:
	pass

func on_bark_finished() -> void:
	transition.emit("Idle") # After dog finishes barking, it just returns to normal

func deduct_burglar_time() -> void:
	burglar.time_seconds -= 10
