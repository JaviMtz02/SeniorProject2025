extends Node
# Game Manager stores game states and variables that are good to share across the whole application
# We are trying to practice encapsulation

var game_active: bool = false
var current_money_accrued: int = 0
var total_money: int = 0

func is_game_active() -> bool:
	return game_active
	
func set_game_active(status: bool) -> void:
	game_active = status
	if status == false:
		end_current_game()

func end_current_game() -> void:
	total_money += current_money_accrued
	current_money_accrued = 0
	
func get_current_money_accrued() -> int:
	return current_money_accrued	

func add_money(money: int) -> void:
	current_money_accrued += money
