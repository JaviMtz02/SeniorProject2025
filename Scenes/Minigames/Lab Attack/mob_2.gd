extends CharacterBody2D


@export var player: Node2D
@export var nav_agent: NavigationAgent2D

var min_speed: float = 50
var max_speed: float = 75
var speed: float
var change_time: float = 0.5
var time_elapsed: float = 0.0
var random_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	if player:
		make_path()

func _process(_delta: float) -> void:
	if player:
		time_elapsed += _delta
		if time_elapsed > change_time:
			random_offset = Vector2(randf_range(-30,30), randf_range(-30,30))
			change_time = randf_range(0.5, 2.0)
			time_elapsed = 0.0
		nav_agent.target_position = player.global_position
		
func _physics_process(_delta: float) -> void:
	var dir = (nav_agent.get_next_path_position() - global_position + random_offset).normalized()
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
