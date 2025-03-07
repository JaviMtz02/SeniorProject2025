extends Node2D

@export var enemy_scene1: PackedScene
@export var enemy_scene2: PackedScene
@export var enemy_scene3: PackedScene
@export var player: Node2D
@export var spawn_area: Rect2

var min_spawn_time: float = 0.5
var max_spawn_time: float = 1.5

func _ready() -> void:
	spawn_enemy()
	
func spawn_enemy() -> void:
	var enemy1 = enemy_scene1.instantiate()
	var enemy2 = enemy_scene2.instantiate()
	var enemy3 = enemy_scene3.instantiate()
	enemy1.global_position = get_random_spawn_position()
	enemy2.global_position = get_random_spawn_position()
	enemy3.global_position = get_random_spawn_position()
	enemy2.player = player
	enemy1.player = player
	enemy3.player = player
	get_parent().call_deferred("add_child", enemy3)
	get_parent().call_deferred("add_child", enemy2)
	get_parent().call_deferred("add_child", enemy1)
	
	var next_spawn_time = randf_range(min_spawn_time, max_spawn_time)
	await get_tree().create_timer(next_spawn_time).timeout
	spawn_enemy()
	
func get_random_spawn_position() -> Vector2:
	var x = randf_range(spawn_area.position.x, spawn_area.end.x)
	var y = randf_range(spawn_area.position.y, spawn_area.end.y)
	return Vector2(x,y)
