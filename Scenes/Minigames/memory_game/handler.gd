extends Node2D




## Best to stick to squares
@export var num_buttons: int = 9
## Number of squares that have to be selected
@export var sequence_length: int = 6
## In seconds
@export var speed: float = 1.0

const BUTTON = preload("res://Scenes/Minigames/memory_game/button.tscn")
@onready var grid_container: GridContainer = $GridContainer

var game_over: bool = false
var _game_won: bool = false
var player_turn: bool = false
var playing_sequence: bool = false
var stopping_process: bool = false
var sequence: Array = []
var sub_sequence_length: int = 1
var sub_sequence_selected: Array = []

signal game_won
signal game_lost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var target_size = 16 * sqrt(num_buttons)
	grid_container.size = Vector2(target_size, target_size)
	for i in range(num_buttons):
		var button = BUTTON.instantiate()
		button.INDEX = i
		button.SPEED = speed * 0.75
		button.click.connect(_on_Button_click)
		grid_container.add_child(button)
	for i in range(sequence_length):
		sequence.append(randi() % num_buttons)
		print(sequence[i])

func stop_process() -> void:
	await get_tree().create_timer(3).timeout
	set_process_mode(4)

func _process(_delta: float) -> void:
	if game_over && not stopping_process:
		if game_won:
			game_won.emit()
			queue_free()
		else:
			game_lost.emit()
			queue_free()
		stopping_process = true
		stop_process()
	if player_turn == false and playing_sequence == false and not game_over:
		playing_sequence = true
		play_sequence()
		sub_sequence_selected.clear()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func play_sequence() -> void:
	for i in range(sub_sequence_length):
		var button = grid_container.get_child(sequence[i])
		button.blink()
		await get_tree().create_timer(speed).timeout
	player_turn = true
	playing_sequence = false
		
func _on_Button_click(button) -> void:
	if player_turn:
		button.blink()
		sub_sequence_selected.append(button.INDEX)
		# Check if the player is correct
		for i in range(sub_sequence_selected.size()):
			if sub_sequence_selected[i] != sequence[i]:
				player_turn = false
				game_over = true
				return
		if sub_sequence_selected.size() == sub_sequence_length:
			if sub_sequence_length == sequence_length:
				player_turn = false
				_game_won = true
				game_over = true
			else:
				sub_sequence_length += 1
				await get_tree().create_timer(speed*2).timeout
				player_turn = false
