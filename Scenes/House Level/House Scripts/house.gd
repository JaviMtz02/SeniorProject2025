extends Node2D

@onready var loot: Node = $Loot
@onready var coins: Node = $Coins
# All players are kept here
@onready var players: Node2D = $Players

var max_loot: int = 0
var total_value: int = 0
var loot_obtained = 0
var minigames_won = 0 # Used to add up the amount of minigames won

@export var level_time_seconds = 59
@export var level_time_minutes = 4
@export var level_name: String = "house"
func _ready() -> void:
	GameManager.set_game_active(true)
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
	# print("total value so far: " + str(total_value) + " Loot obtained: " + str(loot_obtained))

# Additional functions down here for achievement scene

# For the minigames_won var, I'm thinking the variable needs to be at exactly the amount of minigames in each level
# When you lose a game the variable should be -= 1 and when you win it should be += 1, so to have the perfect run, you have to 
# get the max number which isn't obtainable unless you don't lose a minigame
