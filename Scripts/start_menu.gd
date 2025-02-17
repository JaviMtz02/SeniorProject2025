class_name StartMenu
extends Control

@onready var play: Button = $MarginContainer/HBoxContainer/VBoxContainer/play
@onready var arcade: Button = $MarginContainer/HBoxContainer/VBoxContainer/arcade
@onready var options: Button = $MarginContainer/HBoxContainer/VBoxContainer/options
@onready var quit: Button = $MarginContainer/HBoxContainer/VBoxContainer/quit
var level_select := "res://Scenes/Menus/level_select.tscn"

func _ready() -> void:
	quit.button_down.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(level_select)

func _on_quit_pressed() -> void:
	get_tree().quit()
