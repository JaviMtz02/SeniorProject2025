extends Control

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"
const JOIN_SCREEN = "res://Scenes/Menus/join_screen.tscn"
const START_MENU = "res://Scenes/Menus/start_menu.tscn"

func _on_singeplayer_pressed():
	get_tree().call_deferred(&"change_scene_to_packed", preload(LEVEL_SELECT))

func _on_multiplayer_pressed():
	get_tree().call_deferred(&"change_scene_to_packed", preload(JOIN_SCREEN))
	
func _on_back_pressed():
	get_tree().call_deferred(&"change_scene_to_packed", preload(START_MENU))
