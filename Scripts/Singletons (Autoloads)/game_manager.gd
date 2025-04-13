extends Node

# Global player variables it needs for the levels
var cash: int = 0
var equipped_weapon
var equipped_shoes
var equipped_bag

# Level variables
# These variables are passed to the win screen
var curr_level_cash: int = 0
var curr_level_loot_collected: int = 0
var collected_all_loot: bool = false
var completed_minigames: bool = false


# For the win screen, this function gets the information from the level at the end, to use in the win screen
func get_level_data(level_cash: int, level_loot: int, did_collect_all_loot: bool, did_complete_minigames: bool) -> void:
	curr_level_cash = level_cash
	curr_level_loot_collected = level_loot
	collected_all_loot = did_collect_all_loot
	completed_minigames = did_complete_minigames
	accumulate_cash(curr_level_cash)

# When level ends, cash that was successfully deposited at door will be added to the total cash amount
func accumulate_cash(level_cash: int) -> void: 
	cash += level_cash

# Once the win/lose screen uses the level data for its features, it will reset the values for future levels each time
func reset_level_data() -> void: 
	curr_level_cash = 0
	curr_level_loot_collected = 0
	collected_all_loot = false
	completed_minigames = false
