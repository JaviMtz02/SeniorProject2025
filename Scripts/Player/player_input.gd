class_name PlayerInput extends Node

var input_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("left", "right", "up", "down")
