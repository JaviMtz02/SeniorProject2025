extends CharacterBody2D

@export var health: int = 30
@export var emote: Sprite2D
var burglar: CharacterBody2D

func _ready() -> void:
	emote.hide()

func take_damage(amount: int) -> void:
	health -= amount
