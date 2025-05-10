extends Control

const ARACDE_MODE = "res://Arcade Mode/arcade_level.tscn"
const START_MENU = "res://Scenes/Menus/start_menu.tscn"
func _on_play_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(ARACDE_MODE))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(START_MENU)
