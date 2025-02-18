extends Node

@export var _player_spawn_point: Node2D

var _multiplayer_scene = preload("res://Scenes/Player/player.tscn")

func _ready() -> void:
	if NetworkManager.is_hosting_game:
		multiplayer.peer_connected.connect(_client_connected)
		multiplayer.peer_disconnected.connect(_client_disconnected)
		if not OS.has_feature("dedicated_server"):
			_add_player_to_game(1)
	
	NetworkManager.hide_loading()

func _add_player_to_game(network_id: int):
	print("Adding player to game: %s" % network_id)
	# Spawn player in game
	var player_to_add = _multiplayer_scene.instantiate()
	player_to_add.name =  str(network_id)
	_ready_player(player_to_add)
	
func _remove_player_from_game(network_id: int):
	print("Removing player to game: %s" % network_id)
	# Remove player
	
func _ready_player(player: Player):
	player.position = Vector2(randi_range(0, 100),randi_range(0, 100))

func _client_connected(network_id: int):
	print("Client connected: %s" % network_id)
	_add_player_to_game(network_id)
	
func _client_disconnected(network_id: int):
	print("Client disconnected: %s" % network_id)
	_remove_player_from_game(network_id)
