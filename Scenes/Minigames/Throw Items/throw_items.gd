extends Node2D


@onready var thrower: Node2D = $Thrower
@onready var bag: CharacterBody2D = $Bag

var tries_left: int = 3
var items: int = 5

signal game_won
signal game_lost


func _ready() -> void:
	thrower.hit.connect(_on_hit)
	thrower.no_hit.connect(_on_no_hit)
	await get_tree().create_timer(0.5).timeout
	bag.pick_new_pos()


func _on_hit() -> void:
	pass

func _on_no_hit() -> void:
	pass
