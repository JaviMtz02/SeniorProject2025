extends Control

signal paused(is_paused)

@export var pausable_scene: Node2D
@onready var exit_game = preload("res://Scenes/Menus/start_menu.tscn") as PackedScene
@onready var back: Button = $PanelContainer/MarginContainer/VBoxContainer/back
@onready var button_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
var exit_game_path := "res://Scenes/Menus/start_menu.tscn"
var level_select := "res://Arcade Mode/UI/arcade_menu.tscn"
const CURSOR = preload("res://Arcade Mode/UI/basic_crosshair.png")
var PAUSE = false

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume() -> void:
	if PAUSE:
		reset_focus()
		$AnimationPlayer.play_backwards("blur")
		PAUSE = false
		SignalBus.emit_paused(false)

func pause() -> void:
	$AnimationPlayer.play("blur")
	PAUSE = true
	SignalBus.emit_paused(true)

func _on_back_pressed() -> void:
	if PAUSE:
		handle_cursor(false)
		resume()

func _on_restart_pressed() -> void:
	if PAUSE:
		resume()
		get_tree().reload_current_scene()

func _on_level_select_pressed() -> void:
	if PAUSE:
		handle_cursor(true)
		get_tree().change_scene_to_file(level_select)

func _on_exit_pressed() -> void:
	if PAUSE:
		$AnimationPlayer.stop()
		handle_cursor(true)
		get_tree().change_scene_to_file(exit_game_path)

func _on_quit_pressed() -> void:
	if PAUSE:
		get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		if PAUSE:
			handle_cursor(false)
			resume()
		else:
			handle_cursor(true)
			pause()
			# Allow controller input to select first button
			back.grab_focus()

# Makes it so that buttons aren't selectable when not pasued
func reset_focus():
	button_container.hide()
	button_container.show()

func handle_cursor(value: bool) -> void:
	if value:
		Input.set_custom_mouse_cursor(null)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_custom_mouse_cursor(CURSOR, Input.CURSOR_ARROW, Vector2(24, 24))
