extends CharacterBody2D

const speed = 190
@export var player: Node2D
@export var nav_agent: NavigationAgent2D

func _ready() -> void:
	$Chasing.play()
	make_path()
	
func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func make_path() -> void:
	nav_agent.target_position = player.global_position
	
func _on_timer_timeout() -> void:
	make_path()
