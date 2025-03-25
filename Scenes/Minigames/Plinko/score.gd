extends Area2D

@export var score: int = 0 
signal add_points(score: Area2D)
@warning_ignore("unused_signal")

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	
func _on_body_entered(body: Node2D) -> void: 
	if body.is_in_group("blocks"):
		emit_signal("add_points", self)
