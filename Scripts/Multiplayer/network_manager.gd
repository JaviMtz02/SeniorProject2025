extends Node

var _loading_screen = preload("res://Scenes/Menus/loading.tscn")
var _active_loading_scene

var _enet_network = preload("res://Scenes/Network/enet_network.tscn")

var is_hosting_game = false

func host_game():
	print("Host game")
	show_loading()
	is_hosting_game = true
	var active_network = _enet_network.instantiate()
	add_child(active_network)
	active_network.create_server_peer()
	
func join_game():
	print("Join game")
	show_loading()
	
	var active_network = _enet_network.instantiate()
	add_child(active_network)
	active_network.create_client_peer()

func show_loading():
	print("Show loading")
	_active_loading_scene = _loading_screen.instantiate()
	add_child(_active_loading_scene)
	
func hide_loading():
	print("Hide loading")
	if _active_loading_scene != null:
		remove_child(_active_loading_scene)
		_active_loading_scene.queue_free()
