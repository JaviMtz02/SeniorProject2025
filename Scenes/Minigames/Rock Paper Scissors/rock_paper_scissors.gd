extends Node2D


@onready var options: Control = $Options
@export var player_games_won_label: Label
@export var ai_games_won_label: Label

var player_games_won: int = 0
var ai_games_won: int = 0

signal game_won
signal game_lost

func _ready() -> void:
	if options:
		options.player_won.connect(_on_player_wins)
		options.ai_won.connect(_on_ai_wins)
		options.tie_game.connect(_on_game_tied)
		
func _on_player_wins() -> void:
	player_games_won += 1
	player_games_won_label.text = "Games\nWon: " + str(player_games_won)
	check_game()
	
func _on_ai_wins() -> void:
	ai_games_won += 1
	ai_games_won_label.text = "Games\nWon: " + str(ai_games_won)
	check_game()
	
func _on_game_tied() -> void:
	check_game()
	
func check_game() -> void:
	if player_games_won == 5:
		game_won.emit()
		queue_free()
	elif ai_games_won == 5:
		game_lost.emit()
		queue_free()
		
		
