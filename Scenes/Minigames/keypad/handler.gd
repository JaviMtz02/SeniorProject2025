extends Node2D


@export var CODE_LENGTH:int = 4

const BUTTON = preload("res://Scenes/Minigames/keypad/button.tscn")
@onready var grid_container: GridContainer = $keypad
@onready var code_label: Label = $sticky_note/code
@onready var tries_label: Label = $TriesLabel


var code:Array
var disabled_code_num_index:int
var button_array:Array = []
var tries: int = 3
var game_over: bool = false
var player_current_guess: Array = []

signal game_won
signal game_lost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_container.size = Vector2(32*3, 32*4)
	# Buttons 1-9
	for i in range(1, 10):
		var button = BUTTON.instantiate()
		button.INDEX = i
		button.click.connect(_on_Button_click)
		button_array.append(button)
		grid_container.add_child(button)
	# Filler non-interactable rect
	var rect = ColorRect.new()
	rect.color = Color(1, 1, 1, 0)  # Transparent color
	rect.size = Vector2(16, 16)
	grid_container.add_child(rect)
	# Button 0
	var button = BUTTON.instantiate()
	button.INDEX = 0
	button.click.connect(_on_Button_click)
	button_array.append(button)
	grid_container.add_child(button)
	# Generate code
	for i in range(CODE_LENGTH):
		code.append(randi() % 10)
	disabled_code_num_index = randi() % CODE_LENGTH
	var text = ""
	for i in range(CODE_LENGTH):
		if i == disabled_code_num_index:
			text += "x"
		else:
			text += str(code[i])
	code_label.text = text

func _on_Button_click(button):
	if game_over:
		return
	if button.INDEX == code[player_current_guess.size()]:
		player_current_guess.append(button.INDEX)
		button.blink(true)
		if player_current_guess.size() == CODE_LENGTH:
			if player_current_guess == code:
				game_won.emit()
				queue_free()
				print("You win")
				game_over = true
	else:
		if tries > 0:
			player_current_guess.clear()
			tries -= 1
			for item in button_array:
				item.blink(false)
			update_tries()
		else:
			game_lost.emit()
			queue_free()
			print("you lost!")

func update_tries() -> void:
	tries_label.text = "Tries: " + str(tries)
