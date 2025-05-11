extends Node

signal gun_ammo_change(ammo_capacity, max_ammo)
signal weapon_swap(new_gun_scene)
signal paused(is_paused)
signal dead()

# Any weapon can emit to this global signal
func emit_ammo_change(ammo_capacity, max_ammo):
	emit_signal("gun_ammo_change", ammo_capacity, max_ammo)

func emit_weapon_swap(new_gun_scene):
	emit_signal("weapon_swap", new_gun_scene)

func emit_paused(is_paused):
	emit_signal("paused", is_paused)

func emit_dead():
	emit_signal("dead")
