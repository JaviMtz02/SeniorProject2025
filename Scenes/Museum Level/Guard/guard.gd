extends CharacterBody2D

@export var surprised_texture: Sprite2D
@export var health: int = 15

var burglar: CharacterBody2D

func _ready() -> void:
	surprised_texture.hide()

func take_damage(amount: int) -> void:
	health -= amount
