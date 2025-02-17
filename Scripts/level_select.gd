extends Control

@onready var house_level = preload("res://Scenes/House Level/house.tscn") as PackedScene
@onready var museum_level = preload("res://Scenes/Museum Level/museum.tscn") as PackedScene
var main_menu := "res://Scenes/Menus/start_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_house_pressed() -> void:
	get_tree().change_scene_to_packed(house_level)

func _on_museum_pressed() -> void:
	get_tree().change_scene_to_packed(museum_level)

func _on_lab_pressed() -> void:
	pass # Replace with function body.

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)
