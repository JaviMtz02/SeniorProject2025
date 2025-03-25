extends Control

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"

func _process(delta: float) -> void:
	PlayerManager.handle_join_input()
	# Check for "start" in global inptus
	if PlayerManager.someone_wants_to_start():
		get_tree().call_deferred(&"change_scene_to_packed", preload(LEVEL_SELECT))
	
