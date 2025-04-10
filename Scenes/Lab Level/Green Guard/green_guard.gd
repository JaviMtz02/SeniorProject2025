extends CharacterBody2D

@export var health: int = 20
var burglar: CharacterBody2D

func _ready() -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
