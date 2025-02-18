extends Control

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"
const MULTIPLAYER_MENU = "res://Scenes/Menus/multiplayer_menu.tscn"

func on_singplayer_press():
	get_tree().call_deferred(&"change_scene_to_packed", preload(LEVEL_SELECT))
	
func on_multiplayer_press():
	get_tree().call_deferred(&"change_scene_to_packed", preload(MULTIPLAYER_MENU))
	
