extends CharacterBody2D

var health = 100

func take_damage(damage: int = 25) -> void:
	health -= damage
	if health <= 0:
		queue_free()
