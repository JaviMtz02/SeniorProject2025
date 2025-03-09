extends CharacterBody2D


@export var player: Node2D
@export var nav_agent: NavigationAgent2D

var min_speed: float = 50
var max_speed: float = 75
var speed: float
var zig_zag_timer: float = 0.5
var zig_zag_direction: float = 1.0


func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	if player:
		make_path()

func _process(_delta: float) -> void:
	if player:
		zig_zag_timer -= _delta
		if zig_zag_timer <= 0:
			zig_zag_direction *= -1
			zig_zag_timer = randf_range(0.3, 0.8)
		nav_agent.target_position = player.global_position
		
func _physics_process(_delta: float) -> void:
	var dir = (nav_agent.get_next_path_position() - global_position).normalized()
	dir += Vector2(zig_zag_direction * 0.5, 0).normalized()
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
