extends Area2D

# value dictactes how much money burglar will receive
@export var value: float = 4.0
# space required for the burglar to actually be able to steal it
@export var inventory_space_req: float = 2.0
@warning_ignore("unused_signal")

signal burglar_nearby(loot: Area2D)

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(area: Area2D) -> void: 
	print("ok")
	if area.is_in_group("loot_interaction"):
		print("Ahhhh")	
		emit_signal("burglar_nearby", self)
