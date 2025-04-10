extends Node2D

@onready var loot: Node = $Loot
@onready var coins: Node = $Coins

var max_loot: int = 0
var total_value: int = 0
var loot_obtained = 0
var minigames_won = 0 # Used to add up the amount of minigames won

@export var level_time_seconds = 59
@export var level_time_minutes = 1
@export var level_name: String = "laboratory"

func _ready() -> void:
	# This gets the amount of scenens in the loot and coins node, this will be useful for 
	# the achievement system that I (Javi) want to incorporate
	max_loot = loot.get_children().size() + coins.get_children().size()

func get_level_data() -> Dictionary:
	return {
		"time_minutes" : level_time_minutes,
		"time_seconds" : level_time_seconds
	}
func deposit_loot(value: int, loot_amount: int) -> void:
	total_value += value
	loot_obtained += loot_amount
