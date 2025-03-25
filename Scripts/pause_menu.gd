extends Control

@export var pausable_scene: Node2D
@onready var exit_game = preload("res://Scenes/Menus/start_menu.tscn") as PackedScene
@onready var back: Button = $PanelContainer/MarginContainer/VBoxContainer/back
@onready var button_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
const exit_game_path: String = "res://Scenes/Menus/start_menu.tscn"
const level_select: String = "res://Scenes/Menus/level_select.tscn"
var paused = false

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta: float):
	if someone_wants_to_pause():
		if paused:
			resume()
		else:
			pause()
			# Allow controller input to select first button
			back.grab_focus()

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

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_level_select_pressed() -> void:
	if paused:
		get_tree().change_scene_to_file(level_select)

func _on_exit_pressed() -> void:
	'''
	get_tree().paused = false
	$AnimationPlayer.stop()  # Stop any current animations
	get_tree().change_scene_to_packed(exit_game)
	'''
	if paused:
		$AnimationPlayer.stop()
		GameManager.set_game_active(false)
		# Use change_scene_to_file instead
		get_tree().change_scene_to_file(exit_game_path)

func _on_quit_pressed() -> void:
	if paused:
		GameManager.set_game_active(false)
		get_tree().quit()

func someone_wants_to_pause() -> bool:
	for player in PlayerManager.player_data:
		var device = PlayerManager.get_player_device(player)
		if MultiplayerInput.is_action_just_pressed(device, "pause"):
			return true
	return false

# Makes it so that buttons aren't selectable when not pasued
func reset_focus():
	button_container.hide()
	button_container.show()
