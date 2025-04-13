extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
var SPEED : int = 100

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()
