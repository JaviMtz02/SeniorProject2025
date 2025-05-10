extends HBoxContainer

func _on_ui_ammo_change(ammo_capacity, max_ammo) -> void:
	$AmmoProgress.value = ammo_capacity
	$AmmoProgress.max_value = max_ammo
