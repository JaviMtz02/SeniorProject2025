extends Control

var game_starting: bool = false
const START_MENU: String = "res://Scenes/Menus/start_menu.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if there is at least 1 player
	if PlayerManager.player_data.is_empty():
		PlayerManager.handle_join_input()
	else:
		start_game()

# Doing it this way so that if we wanted to add a transition or a sound to start up the game we can
func start_game():
	# Ensures that start_game() only gets called once
	if not game_starting:
		game_starting = true
		get_tree().call_deferred(&"change_scene_to_packed", preload(START_MENU))		
