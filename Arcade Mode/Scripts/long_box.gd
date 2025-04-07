extends StaticObject

func _init() -> void:
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Box/long_box1.png"), false)
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Box/long_box2.png"), false)
	add_variation(preload("res://Arcade Mode/Environment/Objects/Static/Box/long_box3.png"), false)

func _ready() -> void:
	super._ready()
