extends Control

const LEVEL_SELECT: String = "res://Scenes/Menus/level_select.tscn"
const MULTIPLAYER_MENU: String = "res://Scenes/Menus/multiplayer_menu.tscn"
const START_MENU: String = "res://Scenes/Menus/start_menu.tscn"

func singleplayer_select():
	get_tree().change_scene_to_file(LEVEL_SELECT)
	
func multiplayer_select():
	get_tree().change_scene_to_file(MULTIPLAYER_MENU)
	
func back_select():
	get_tree().change_scene_to_file(START_MENU)
