extends StaticObject

func _init() -> void:
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Barrel/barrel1.png"), false)
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Barrel/barrel2.png"), false)

func _ready() -> void:
	super._ready()
