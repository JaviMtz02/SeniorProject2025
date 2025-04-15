extends Node2D

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2(0.6, 0.6), 0.5)
	tween.tween_property(self, "scale", Vector2(0.3, 0.3), 0.5)
