extends Node

signal all_players_loaded
signal player_connected
signal player_disconnected
signal server_disconnected
signal connection_failed

# Default info
@export var DEFAULT_IP_ADDRESS: String = "127.0.0.1"
@export var PORT: int = 8080
@export var MAX_CLIENTS = 4

# Client info
@export var player_info: Dictionary = {"name": "Name"}
var players: Dictionary = {}
var players_loaded: int = 0

#### Boiler Plate Multiplayer Functions ####
func _ready() -> void:
	# Connect to the multiplayer signals
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func is_multiplayer():
	return multiplayer.multiplayer_peer != null

func is_host():
	return multiplayer.is_server()

## Evaluate true if connection has been made
func start_host():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Hosting")

	# Add the server peer to the players list
	var server_id = multiplayer.get_unique_id()
	players[server_id] = player_info
	player_connected.emit(server_id, player_info)

## Evaluate true if connection has been made
func start_client(address: String = ""):
	var peer = ENetMultiplayerPeer.new()
	if address.is_empty():
		address = DEFAULT_IP_ADDRESS
	peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = peer
	
func _stop_multiplayer() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()

func _on_player_connected(id: int) -> void:
	# Add the new client to the player list
	_register_player.rpc_id(id, player_info)
	print("Client connected: ", id)
	
@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id):
	if id <= 1:
		# If the player is the host, stop the server
		_stop_multiplayer()
		print("Server is gone")
		get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")
		return
	# Remove the player from the list
	players.erase(id)
	player_disconnected.emit(id)
	print("Player disconnected")

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	connection_failed.emit()
	print("Connection failed")

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	print("Server disconnected")

@rpc("any_peer", "reliable")
func leave_game():
	# Notify the server that this player is leaving
	var player_id = multiplayer.get_unique_id()
	if player_id <= 1:
		# If the player is the host, stop the server
		_stop_multiplayer()
		print("Server stopped")
		return
	else:
		# Notify the server that this player is leaving
		_stop_multiplayer()
		print("You have left the game")
	if multiplayer.is_server():
		players.erase(player_id)
		player_disconnected.emit(player_id)
		print("Player left: ", player_id)

#### Multiplayer Game Functions ####
@rpc("authority", "call_local", "reliable")
func load_game(game_scene_path: String):
	get_tree().change_scene_to_file(game_scene_path)

@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			all_players_loaded.emit()
			players_loaded = 0
