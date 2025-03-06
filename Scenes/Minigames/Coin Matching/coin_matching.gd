extends Node2D

@export var coin_pattern: PackedScene
@export var game_manager: Node2D
@export var attempts_label: Label

var patterns = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7]
var flipped_coins = []
var curr_matches: int = 0
var attempts: int = 8

signal game_won
signal game_lost

func _ready() -> void:
	patterns.shuffle()
	for i in range(patterns.size()):
		var coin = coin_pattern.instantiate()
		coin.set_pattern(patterns[i])
		coin.position = Vector2((i % 4) * 100, (i / 4) * 100)
		game_manager.add_coin(coin)
		add_child(coin)

func add_coin(coin):
	coin.coin_flipped.connect(check_match)

func check_match(coin):
	flipped_coins.append(coin)
	
	if flipped_coins.size() == 2:
		var coin1 = flipped_coins[0]
		var coin2 = flipped_coins[1]
		
		if coin1.card_pattern == coin2.card_pattern:
			curr_matches += 1
			if curr_matches == patterns.size() / 2:
				game_won.emit() # add something here!
			
		else:
			attempts -= 1
			await get_tree().create_timer(0.5).timeout
			coin1.reset()
			coin2.reset()
			if attempts == 0:
				game_lost.emit() # add something here for losing the game
			
		flipped_coins.clear()
	attempts_label.text = "Attempts\nLeft: " + str(attempts)
