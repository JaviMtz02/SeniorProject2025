extends Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("idle_left")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
