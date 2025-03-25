extends CharacterBody2D

@export var health: int = 20

func _ready() -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
