extends CharacterBody2D

@export var health: int = 5

# Depending on the item the burglar is throwing, that is the amount that will be taken from the health
func take_damage(amount: int):
	health -= amount
