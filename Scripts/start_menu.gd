class_name StartMenu
extends Control

const OPTIONS_MENU = "res://Scenes/Menus/options_menu.tscn"
const PLAY_MENU = "res://Scenes/Menus/play_menu.tscn"
const SHOP = "res://Scenes/Shop/shop.tscn"
const ARACDE_MODE = "res://Arcade Mode/arcade_level.tscn"

func _on_play_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(PLAY_MENU))
	
func _on_options_pressed():
	get_tree().call_deferred(&"change_scene_to_packed", preload(OPTIONS_MENU))

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_shop_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(SHOP))

func _on_arcade_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(ARACDE_MODE))
