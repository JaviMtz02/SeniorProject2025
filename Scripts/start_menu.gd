class_name StartMenu
extends Control

const PLAY_MENU = "res://Scenes/Menus/play_menu.tscn"
const SHOP = "res://Scenes/Shop/shop.tscn"
const ARCADE_MENU = "res://Arcade Mode/UI/arcade_menu.tscn"

func _on_play_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(PLAY_MENU))

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_shop_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(SHOP))

func _on_arcade_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(ARCADE_MENU))
