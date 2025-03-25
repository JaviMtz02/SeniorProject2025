extends NodeState

@export var green_guard: CharacterBody2D
@export var detector: RayCast2D
@export var anim: AnimatedSprite2D
@export var throwable: PackedScene
@export var nav_agent: NavigationAgent2D

@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")
var attack_timer: Timer

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.4  # Duration of attack animation	
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_finished)
	add_child(attack_timer)

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	green_guard.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	green_guard.move_and_slide()

func  _on_next_transition() -> void:
	pass
	

func _on_enter() -> void:
	var direction_to_burglar = (burglar.global_position - green_guard.global_position).normalized()
	green_guard.velocity = Vector2.ZERO
	green_guard.move_and_slide()
	nav_agent.avoidance_enabled = false
	
	var attack_instance = throwable.instantiate()
	attack_timer.start()  # Start cooldown timer
	get_parent().add_child(attack_instance)
	attack_instance.global_position = green_guard.global_position
	attack_instance.direction = direction_to_burglar
	
func _on_exit() -> void:
	nav_agent.avoidance_enabled = true

func _on_attack_finished() -> void:
	transition.emit("Walk")
