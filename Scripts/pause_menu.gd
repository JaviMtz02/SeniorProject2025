extends Control

@onready var exit_game = preload("res://Scenes/Menus/start_menu.tscn") as PackedScene
var exit_game_path := "res://Scenes/Menus/start_menu.tscn"

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func resume() -> void:
	$AnimationPlayer.play_backwards("blur")
	get_tree().paused = false

func pause() -> void:
	$AnimationPlayer.play("blur")
	get_tree().paused = true

func _on_back_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	'''
	get_tree().paused = false
	$AnimationPlayer.stop()  # Stop any current animations
	get_tree().change_scene_to_packed(exit_game)
	'''
	get_tree().paused = false
	$AnimationPlayer.stop()
	# Use change_scene_to_file instead
	get_tree().change_scene_to_file(exit_game_path)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		if get_tree().paused:
			resume()
		else:
			pause()
