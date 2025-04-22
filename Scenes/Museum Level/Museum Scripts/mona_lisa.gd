extends Area2D

# value dictactes how much money burglar will receive, each loot has its own specified value in the inspector tab
@export var value: float = 4.0
# space required for the burglar to actually be able to steal it
@export var inventory_space_req: float = 2.0
@warning_ignore("unused_signal")
@warning_ignore("unused_signal")

var first_time: bool = true
signal burglar_nearby(loot: Area2D)
signal burglar_away(loot: Area2D)

func _ready() -> void:
	# Since this loot script is being reused for a bunch of scenes, we couldn't directly connect from the 
	# Signals tab, this way, you can attach the signals without explicitly stating its for that specific scene
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	
# area parameter is an Area2D that is a child of the one who is interacting
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot_interaction") and int(area.get_parent().name) == multiplayer.get_unique_id() and first_time:
		emit_signal("burglar_nearby", self)
		area.get_parent().poi_nearby(self)
		first_time = false
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("loot_interaction") and int(area.get_parent().name) == multiplayer.get_unique_id():
		emit_signal("burglar_away", self)
		area.get_parent().poi_leave(self)
