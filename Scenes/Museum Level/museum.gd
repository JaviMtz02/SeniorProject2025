extends Node2D

const WIN_SCREEN: String = "res://Scenes/Menus/EndScreen.tscn"
const LOSE_SCREEN: String = "res://Scenes/Menus/lose_screen.tscn"

@onready var loot: Node = $Loot
@onready var coins: Node = $Coins

var max_loot: int = 0
var total_value: int = 0
var loot_obtained = 0
var minigames_won = 0 # Used to add up the amount of minigames won
var collected_all_loot: bool = false
var won_all_minigames: bool = false

@export var level_time_seconds = 59
@export var level_time_minutes = 9
@export var door_code: int
@export var level_name: String = "museum"

func _ready() -> void:
	# This gets the amount of scenens in the loot and coins node, this will be useful for 
	# the achievement system that I (Javi) want to incorporate
	$Sounds/LevelMusic.play()
	print(door_code)
	max_loot = loot.get_children().size() + coins.get_children().size()

func get_level_data() -> Dictionary:
	return {
		"time_minutes" : level_time_minutes,
		"time_seconds" : level_time_seconds
	}
	
func deposit_loot(value: int, loot_amount: int) -> void:
	total_value += value
	loot_obtained += loot_amount

func connect_signals(player) -> void:
	player.time_warning.connect(on_time_warning)
	player.out_of_time.connect(on_out_of_time)

func on_time_warning() -> void:
	$Sounds/TimeWarning.play()
	$Sounds/LevelMusic.pitch_scale = 1.5

func on_out_of_time() -> void:
	GameManager.get_level_data(total_value, loot_obtained, false, false)
	$Sounds/LevelMusic.stop()
	$Sounds/LevelFailed.play()
	await $Sounds/LevelFailed.finished
	get_tree().change_scene_to_file(LOSE_SCREEN)

func on_level_complete() -> void:
	if minigames_won == 13:
		won_all_minigames = true
	if loot_obtained == max_loot:
		collected_all_loot = true
	GameManager.get_level_data(total_value, loot_obtained, collected_all_loot, won_all_minigames)
	get_tree().change_scene_to_file(WIN_SCREEN)
