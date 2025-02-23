extends Control

@export var pausable_scene: Node2D
@onready var exit_game = preload("res://Scenes/Menus/start_menu.tscn") as PackedScene
@onready var back: Button = $PanelContainer/MarginContainer/VBoxContainer/back
@onready var button_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
var exit_game_path := "res://Scenes/Menus/start_menu.tscn"
var level_select := "res://Scenes/Menus/level_select.tscn"
var paused = false

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	process_mode = Node.PROCESS_MODE_ALWAYS

func resume() -> void:
	reset_focus()
	$AnimationPlayer.play_backwards("blur")
	paused = false

func pause() -> void:
	$AnimationPlayer.play("blur")
	paused = true

func _on_back_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file(level_select)

func _on_exit_pressed() -> void:
	'''
	get_tree().paused = false
	$AnimationPlayer.stop()  # Stop any current animations
	get_tree().change_scene_to_packed(exit_game)
	'''
	$AnimationPlayer.stop()
	# Use change_scene_to_file instead
	get_tree().change_scene_to_file(exit_game_path)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		if paused:
			resume()
		else:
			pause()
			# Allow controller input to select first button
			back.grab_focus()

# Makes it so that buttons aren't selectable when not pasued
func reset_focus():
	button_container.hide()
	button_container.show()
