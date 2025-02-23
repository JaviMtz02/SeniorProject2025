class_name StartMenu
extends Control

const OPTIONS_MENU = "res://Scenes/Menus/options_menu.tscn"
const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"

func _on_play_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(LEVEL_SELECT))
	
func _on_options_pressed():
	get_tree().call_deferred(&"change_scene_to_packed", preload(OPTIONS_MENU))

func _on_quit_pressed() -> void:
	get_tree().quit()
