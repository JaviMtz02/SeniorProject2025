extends Area2D

@warning_ignore("unused_signal")
signal deposit
signal off_deposit

func _on_area_entered(_area: Area2D) -> void:
	var player_id = _area.get_parent().player
	emit_signal("deposit", player_id) # emits signal that allows burglar to deposit

func _on_area_exited(_area: Area2D) -> void:
	var player_id = _area.get_parent().player
	emit_signal("off_deposit", player_id) # emits signal that removes ability to deposit
