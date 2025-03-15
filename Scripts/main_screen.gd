extends Node2D


@export var start_game: Button
@export var minigame_scene: PackedScene
func _ready() -> void:
	#immediately when the scene comes out disable movement
	var burglar = get_tree().get_first_node_in_group("Burglar")
	if burglar:
		burglar.input_enabled = false
	start_game.pressed.connect(_on_start_game_button_pressed)


func _on_start_game_button_pressed() -> void:
	# minigame door scene takes care of loading the minigame
	queue_free()
