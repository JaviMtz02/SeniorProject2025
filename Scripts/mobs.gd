extends Node

@export var spawn_location: Marker2D
@export var mob_spawn_node: Node2D
const DOG = preload("res://Scenes/House Level/characters/Dog/dog.tscn")
@onready var _mob_spawner: MultiplayerSpawner = $MobSpawner

func _ready() -> void:
	if mob_spawn_node:
		_mob_spawner.spawn_path = mob_spawn_node.get_path()
	if is_multiplayer_authority():
		_create_mob()

func _create_mob():
	var mob_to_spawn = DOG.instantiate()
	mob_to_spawn.position = spawn_location.position
	
	mob_spawn_node.add_child(mob_to_spawn, true)
