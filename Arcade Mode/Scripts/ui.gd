extends Control

signal health_change(health)
signal ammo_change(ammo_capacity)

func _on_player_health_change(health: Variant) -> void:
	emit_signal("health_change", health)

func _on_projectile_weapon_ammo_change(ammo_capacity: Variant) -> void:
	emit_signal("ammo_change", ammo_capacity)
