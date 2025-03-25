extends NodeState

@export var guard: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var detector: RayCast2D


func _ready() -> void:
	for door in get_tree().get_nodes_in_group("doors"):
		door.minigame_won.connect(_on_minigame_won)
		door.minigame_lost.connect(_on_minigame_lost)
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	guard.velocity = Vector2.ZERO
	nav_agent.velocity = Vector2.ZERO
	guard.move_and_slide()

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	guard.velocity = Vector2.ZERO
	guard.move_and_slide()
	nav_agent.avoidance_enabled = false
	
func _on_exit() -> void:
	nav_agent.avoidance_enabled = true

func _on_minigame_won() -> void:
	transition.emit("Idle")

func _on_minigame_lost() -> void:
	transition.emit("Idle")
