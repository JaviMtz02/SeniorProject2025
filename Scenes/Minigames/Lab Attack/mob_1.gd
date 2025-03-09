extends CharacterBody2D

var min_speed: float = 100
var max_speed: float = 150
var speed: float
@export var bullet: Node2D
@export var player: Node2D
@export var nav_agent: NavigationAgent2D

func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	if player:
		make_path()

func _process(_delta: float) -> void:
	if player:
		nav_agent.target_position = player.global_position
		
func _physics_process(_delta: float) -> void:
	var dir = (nav_agent.get_next_path_position() - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

func make_path() -> void:
	nav_agent.target_position = player.global_position
	

func _on_buttet_player_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("killzone"):
		queue_free()
		body.queue_free()
	elif body.is_in_group("blocks"):
		queue_free()
