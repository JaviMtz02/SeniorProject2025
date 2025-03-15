extends NodeState

@export var dog: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var detector: RayCast2D
@export var nav_agent: NavigationAgent2D

@onready var hurt_state_timer: Timer = Timer.new() # creates a new instace of a timer
@export var hurt_state_time_interval: float = 1.0 

var hurt_state_timeout: bool = false

func _ready() -> void:
	hurt_state_timer.wait_time = hurt_state_time_interval
	hurt_state_timer.timeout.connect(on_hurt_state_timeout)
	add_child(hurt_state_timer) # since we made the Timer, we need to add that node as a child of our scene
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	dog.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	dog.move_and_slide()
	
func  _on_next_transition() -> void:
	if hurt_state_timeout:
		transition.emit("Idle")

func _on_enter() -> void:
	# Similarly to the bark, this stops all movement and plays the hurt animation
	anim_sprite.play("hurt")
	#play some hurt dog sound here
	dog.velocity = Vector2.ZERO # Sets dog velocity to zero
	dog.move_and_slide()
	nav_agent.target_position = dog.global_position
	nav_agent.avoidance_enabled = false
	hurt_state_timeout = false
	hurt_state_timer.start()
	
func _on_exit() -> void:
	anim_sprite.stop()
	hurt_state_timer.stop()
	nav_agent.avoidance_enabled = true

func on_hurt_state_timeout() -> void:
	hurt_state_timeout = true
	
