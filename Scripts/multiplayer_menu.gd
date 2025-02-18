extends Control

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"

func read():
	if OS.has_feature("dedicated_server"):
		print("Calling host mode...")
		NetworkManager.host_game()

func host_game():
	print("Host game pressed")
	NetworkManager.host_game()
	
func join_game():
	print("Join game pressed")
	NetworkManager.join_game()
