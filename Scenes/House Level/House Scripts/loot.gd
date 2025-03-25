extends Area2D

# value dictactes how much money burglar will receive, each loot has its own specified value in the inspector tab
@export var value: float = 4.0
# space required for the burglar to actually be able to steal it
@export var inventory_space_req: float = 2.0
@warning_ignore("unused_signal")
@warning_ignore("unused_signal")

signal burglar_nearby(loot: Area2D)
signal burglar_away(loot: Area2D)

func _ready() -> void:
	# Since this loot script is being reused for a bunch of scenes, we couldn't directly connect from the 
	# Signals tab, this way, you can attach the signals without explicitly stating its for that specific scene
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	
func _on_area_entered(area: Area2D) -> void: 
	if area.is_in_group("loot_interaction"):
		var player_id = area.get_parent().player
		emit_signal("burglar_nearby", self, player_id)
		
func _on_area_exited(_area: Area2D) -> void:
	var player_id = _area.get_parent().player
	emit_signal("burglar_away", self, player_id)
		
