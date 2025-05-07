extends Node

signal all_players_loaded
signal player_connected
signal player_disconnected
signal server_disconnected
signal connection_failed
signal start_spawning

# Default info
@export var DEFAULT_IP_ADDRESS: String = "127.0.0.1"
@export var DEFAULT_PORT: int = 8080
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

func get_local_ip() -> String:
	var addresses = IP.get_local_addresses()
	var gateway = IP.resolve_hostname("router") # Attempts to get the gateway
	
	for ip in addresses:
		if ip.begins_with("192.") or ip.begins_with("10.") or ip.begins_with("172."): # Private IP ranges
			if gateway == "" or ip.is_valid_ip_address():
				return ip
	return "Not Found"

func check_valid_ip(ip: String) -> bool:
	# Check if the IP address is valid
	if ip.is_valid_ip_address():
		return true
	else:
		print("Invalid IP address")
		return false

func is_multiplayer() -> bool:
	return multiplayer.multiplayer_peer != null and not multiplayer.multiplayer_peer is OfflineMultiplayerPeer

func is_host():
	return multiplayer.is_server()

func start_host(port: int = DEFAULT_PORT):
	# Close the current peer if it exists
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.close()

	# Create a new ENetMultiplayerPeer and start the server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Hosting")

	# Add the server peer to the players list
	var server_id = multiplayer.get_unique_id()
	players[server_id] = player_info
	player_connected.emit(server_id, player_info)

func start_client(address: String = DEFAULT_IP_ADDRESS, port: int = DEFAULT_PORT) -> bool:
	# Check if the address is empty
	if address == "":
		address = DEFAULT_IP_ADDRESS
	# Check if the IP address is valid
	if not check_valid_ip(address):
		print("Invalid IP address")
		return false
	# Close the current peer if it exists
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.close()

	# Create a new ENetMultiplayerPeer and connect to the server
	var peer = ENetMultiplayerPeer.new()
	if peer.create_client(address, port) == OK:
		multiplayer.multiplayer_peer = peer
		print(peer)
		return true
	else:
		print("Failed to start client")
		return false
	
func _stop_multiplayer() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
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
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	connection_failed.emit()
	print("Connection failed")

func _on_server_disconnected():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	server_disconnected.emit()
	print("Server disconnected")

# Anyone can call this and it is sent to all peers reliably
@rpc("any_peer", "reliable")
func leave_game():
	# Notify the server that this player is leaving
	var player_id = multiplayer.get_unique_id()
	if player_id <= 1:
		# If the player is the host, exit multiplayer mode
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
		if players_loaded == players.size() or not is_multiplayer():
			all_players_loaded.emit()
			permission_to_spawn()
			players_loaded = 0

@rpc("authority", "call_local", "reliable")
func permission_to_spawn():
	start_spawning.emit()

@rpc("any_peer", "call_local")
func request_remove_item(item_path: NodePath):
	if not is_multiplayer_authority():  # Ensure only the server processes this
		return
	var item = get_node_or_null(item_path)
	if item:
		remove_item_from_clients.rpc(item_path)

@rpc("authority", "call_local", "reliable")
func remove_item_from_clients(item_path: NodePath):
	var item = get_node_or_null(item_path)
	if item:
		item.queue_free()
