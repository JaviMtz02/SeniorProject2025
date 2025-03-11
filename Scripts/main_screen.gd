extends Node2D


@export var start_game: Button
@export var minigame_scene: PackedScene
func _ready() -> void:
	start_game.pressed.connect(_on_start_game_button_pressed)


func _on_start_game_button_pressed() -> void:
	var minigame_instance = minigame_scene.instantiate()
	get_tree().current_scene.add_child(minigame_instance)
	queue_free()
