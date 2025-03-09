extends Node2D

signal game_results(winner: int) # -1 is lose, 0 is draw, 1 is win

## AI will choose to not make the optimal move (ex. 1/5 times)
@export var ai_accuracy: float = 0.8

const BUTTON = preload("res://Scenes/Minigames/tic_tac_toe/button.tscn")
@onready var cells: GridContainer = $Cells
@onready var icon: Control = $Label/icon

var board = [0,0,0,0,0,0,0,0,0] # 0 is empty, 1 is player, 2 is CPU
var game_over = false
var winner = -1
var player_turn = true if (randi() % 2 == 0) else false
var x_or_o = randi() % 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(9):
		var button = BUTTON.instantiate()
		button.index = i
		button.click.connect(_on_Button_pressed)
		cells.add_child(button)
	
	if x_or_o == 0:
		icon.draw_x()
	else:
		icon.draw_o()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player_turn and $ai_wait.is_stopped():
		$ai_wait.start()
	if game_over:
		print("Game Over")
		if winner == 1:
			print("Player wins!")
			game_results.emit(1)
		elif winner == 2:
			print("CPU wins!")
			game_results.emit(-1)
		else:
			print("Draw!")
			game_results.emit(0)
		
		set_process(false)

func draw_button(button):
	if player_turn:
		if x_or_o == 0:
			button.draw_x()
		else:
			button.draw_o()
	else:
		if x_or_o == 0:
			button.draw_o()
		else:
			button.draw_x()

func _on_Button_pressed(object) -> void:
	if board[object.index] != 0 or game_over or not player_turn:
		return
	board[object.index] = 1
	draw_button(object)
	if check_winner(board) or check_draw():
		game_over = true
		return
	player_turn = false

func ai_move():
	if game_over or player_turn:
		return	
	var empty_cells = []
	for i in range(9):
		if board[i] == 0:
			empty_cells.append(i)
	if len(empty_cells) == 0:
		return
	# Chance to mess up
	if randf() < ai_accuracy:
		# Check if CPU can win
		for cell in empty_cells:
			var alt_board = board.duplicate()
			alt_board[cell] = 2
			if check_winner(alt_board):
				board[cell] = 2
				var button = cells.get_child(cell)
				draw_button(button)
				if check_winner(board) or check_draw():
					game_over = true
					return
				player_turn = true
				return
		# Check if player can win
		for cell in empty_cells:
			var alt_board = board.duplicate()
			alt_board[cell] = 1
			if check_winner(alt_board, false):
				board[cell] = 2
				var button = cells.get_child(cell)
				draw_button(button)
				if check_winner(board) or check_draw():
					game_over = true
					return
				player_turn = true
				return
	# Random move
	var random_index = empty_cells[randi() % len(empty_cells)]
	board[random_index] = 2
	var button = cells.get_child(random_index)
	draw_button(button)
	if check_winner(board) or check_draw():
		game_over = true
		return
	player_turn = true
	
func check_winner(board, real=true):
	var winning_combinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
	for combination in winning_combinations:
		if board[combination[0]] == 0 or board[combination[1]] == 0 or board[combination[2]] == 0:
			continue
		if int(board[combination[0]]) == int(board[combination[1]]) and int(board[combination[1]]) == int(board[combination[2]]):
			if real:
				winner = board[combination[0]]
			return true
	return false

func check_draw():
	for cell in board:
		if cell == 0:
			return false
	return true


func _on_ai_wait_timeout() -> void:
	ai_move()
