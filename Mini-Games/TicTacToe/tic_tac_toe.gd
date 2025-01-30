# Tic Tac Toe Game
# Expected Usage:
	# Copy the scene to main scene
	# Run the scene
	# Record outcome of the game
	# Punish player for losing or reward player for winning
	# Remove the scene from the main scene

extends Node2D

var board = [0, 1, 2,
			 3, 4, 5,
			 6, 7, 8] # Just to show indicies
var current_player = ""
var is_game_active = true

func update_label(text):
	$Label.text = text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board = [-1, -1, -1, 
			 -1, -1, -1, 
			 -1, -1, -1]
	current_player = "X" if randi() % 2 == 0 else "O"
	update_label(current_player + "'s turn")
	
func _on_texture_button_button_press(button_index: int):
	if is_game_active:
		if board[button_index] == -1:
			if current_player == "X":
				board[button_index] = 0
				$GridContainer.get_child(button_index).set_texture_normal(load("res://Mini-Games/TicTacToe/tmpTextures/x.png"))
			else:
				board[button_index] = 1
				$GridContainer.get_child(button_index).set_texture_normal(load("res://Mini-Games/TicTacToe/tmpTextures/o.png"))
			if check_winner():
				update_label(current_player + " wins!")
				is_game_active = false
			elif check_draw():
				update_label("It's a draw!")
				is_game_active = false
			else:
				current_player = "X" if current_player == "O" else "O"
				update_label(current_player + "'s turn")

func check_winner():
	var winning_combinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
	for combination in winning_combinations:
		if board[combination[0]] == -1 or board[combination[1]] == -1 or board[combination[2]] == -1:
			continue
		if int(board[combination[0]]) == int(board[combination[1]]) and int(board[combination[1]]) == int(board[combination[2]]):
			return true
	return false

func check_draw():
	for cell in board:
		if cell == -1:
			return false
	return true
