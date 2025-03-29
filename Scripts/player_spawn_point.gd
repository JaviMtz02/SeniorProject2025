extends Node2D

const BURGLAR = preload("res://Scenes/Burglar/burglar.tscn")

@export var minigame_door: Node

func _ready():
	if MultiplayerManager.is_multiplayer():
		for id in MultiplayerManager.players.keys():
			var player_to_add = BURGLAR.instantiate()
			player_to_add.name = str(id)
			player_to_add.set_multiplayer_authority(id)
			add_child(player_to_add)
	else:
		var player_to_add = BURGLAR.instantiate()
		add_child(player_to_add)
		is_multiplayer_authority()
