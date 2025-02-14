extends Node

@export var level: PackedScene

@onready var menu: Node = $"../Menu"
@onready var multiplayerGUI: Control = $"../Menu/Multiplayer"
@onready var players: Node2D = $"../Players"

var multiplayer_enabled: bool = false

func _process(_delta):
	pass

func start_game():
	# Add the level to the scene
	var level_instance = level.instantiate()
	get_tree().get_root().get_node("Main").hide()
	if multiplayer_enabled:
		get_tree().get_root().get_node("Main").remove_child(players)
		level_instance.get_node("Burglar").queue_free()
		level_instance.add_child(players, 2)
	get_tree().get_root().add_child(level_instance)


func become_host():
	print("Host selected!")
	multiplayerGUI.hide()
	MultiplayerManager.become_host()
	multiplayer_enabled = true
	
func join_host():
	print("Join host selected!")
	multiplayerGUI.hide()
	MultiplayerManager.join_host()
	multiplayer_enabled = true
