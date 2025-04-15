extends Control

signal health_change(health)
signal ammo_change(ammo_capacity, max_ammo)

func _ready() -> void:
	SignalBus.gun_ammo_change.connect(_on_gun_ammo_change)

func _on_player_health_change(health: Variant) -> void:
	emit_signal("health_change", health)

func _on_gun_ammo_change(ammo_capacity, max_ammo) -> void:
	emit_signal("ammo_change", ammo_capacity, max_ammo)
