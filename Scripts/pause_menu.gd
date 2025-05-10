extends Control

@export var pausable_scene: Node2D
@onready var exit_game = preload("res://Scenes/Menus/start_menu.tscn") as PackedScene
@onready var back: Button = $PanelContainer/MarginContainer/VBoxContainer/back
@onready var button_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
var exit_game_path := "res://Scenes/Menus/start_menu.tscn"
var level_select := "res://Scenes/Menus/level_select.tscn"
var paused = false
var root

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	process_mode = Node.PROCESS_MODE_ALWAYS
	var canvasLayer = get_parent()
	root = canvasLayer.get_parent()

func resume() -> void:
	if paused:
		reset_focus()
		$AnimationPlayer.play_backwards("blur")
		paused = false

func pause() -> void:
	$AnimationPlayer.play("blur")
	paused = true

func _on_back_pressed() -> void:
	if paused:
		resume()

func _on_restart_pressed() -> void:
	if paused:
		resume()
		get_tree().reload_current_scene()

func _on_level_select_pressed() -> void:
	if paused:
		if root.level_name == "arcade_level":
			get_tree().change_scene_to_file("res://Arcade Mode/UI/arcade_menu.tscn")
		else:
			get_tree().change_scene_to_file(level_select)

func _on_exit_pressed() -> void:
	if paused:
		'''
		get_tree().paused = false
		$AnimationPlayer.stop()  # Stop any current animations
		get_tree().change_scene_to_packed(exit_game)
		'''
		$AnimationPlayer.stop()
		MultiplayerManager.load_game(exit_game_path)
		MultiplayerManager.leave_game()

func _on_quit_pressed() -> void:
	if paused:
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
