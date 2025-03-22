extends Area2D

@export var value: float = 4.0
@export var inventory_space_req: float = 2.0

@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")

@warning_ignore("unused_signal")
@warning_ignore("unused_signal")

signal burglar_nearby(loot: Area2D)
signal burglar_away(loot: Area2D)
signal open_portal

func _ready() -> void:
	# Since this loot script is being reused for a bunch of scenes, we couldn't directly connect from the 
	# Signals tab, this way, you can attach the signals without explicitly stating its for that specific scene
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	
func _on_area_entered(area: Area2D) -> void: 
	if area.is_in_group("loot_interaction"):
		open_portal.emit()
		emit_signal("burglar_nearby", self)
		
func _on_area_exited(_area: Area2D) -> void:
	emit_signal("burglar_away", self)
		
