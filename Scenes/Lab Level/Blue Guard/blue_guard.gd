extends CharacterBody2D

@export var health: int = 10
var burglar: CharacterBody2D

func _ready() -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
