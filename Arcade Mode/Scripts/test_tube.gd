extends StaticObject

func _init() -> void:
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Test Tube/empty_testTube.png"), false)
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Test Tube/full_testTube.png"), true)
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Test Tube/human_testTube.png"), true)

func _ready() -> void:
	super._ready()
