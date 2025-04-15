extends HBoxContainer

func _on_ui_ammo_change(ammo_capacity: Variant) -> void:
	$AmmoProgress.value = ammo_capacity
