extends Control

const GAME_SCENE = "res://Scenes/game.tscn"

func read():
	if OS.has_feature("dedicated_server"):
		print("Calling host mode...")
		NetworkManager.host_game()
		get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))

func host_game():
	print("Host game pressed")
	NetworkManager.host_game()
	get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))
	
func join_game():
	print("Join game pressed")
	NetworkManager.join_game()
	get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))
