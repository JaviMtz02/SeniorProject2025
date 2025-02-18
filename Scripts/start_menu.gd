class_name StartMenu
extends Control

@onready var quit: Button = $MarginContainer/HBoxContainer/VBoxContainer/quit
const play_menu := "res://Scenes/Menus/play_menu.tscn"

func _ready() -> void:
	quit.button_down.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(play_menu))

func _on_quit_pressed() -> void:
	get_tree().quit()
