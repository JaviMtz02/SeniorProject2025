extends Node

signal gun_ammo_change(ammo_capacity, max_ammo)

# Any weapon can emit to this global signal
func emit_ammo_change(ammo_capacity, max_ammo):
	emit_signal("gun_ammo_change", ammo_capacity, max_ammo)
