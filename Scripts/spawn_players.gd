extends Node2D

signal players_are_spawned

@export var door: Area2D

# map from player integer to the player node
var player_nodes = {}

func _ready():
	for player in PlayerManager.player_data:
		spawn_player(player)
	players_are_spawned.emit()

func spawn_player(player: int):
	# create the player node
	var player_scene = load("res://Scenes/Burglar/burglar.tscn")
	var player_node = player_scene.instantiate()
	player_nodes[player] = player_node
	
	# let the player know which device controls it
	var device = PlayerManager.get_player_device(player)
	player_node.init(player)
	player_node.door = door
	player_node.level_node = get_parent()

	# add the player to the tree
	add_child(player_node)
