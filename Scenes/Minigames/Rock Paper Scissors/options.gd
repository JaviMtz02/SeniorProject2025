extends Control

enum Choice { ROCK, PAPER, SCISSORS }

@export var ai_choice_texture: Sprite2D
@export var player_choice_texture: Sprite2D
@export var textures: Array[Texture2D] = []
@export var rock_button: TextureButton
@export var paper_button: TextureButton
@export var scissors_button: TextureButton

var player_choice: Choice
var ai_choice: Choice
var choices = [Choice.ROCK, Choice.PAPER, Choice.SCISSORS]

signal player_won
signal ai_won
signal tie_game

func _ready() -> void:
	rock_button.pressed.connect(_on_rock_button_pressed)
	paper_button.pressed.connect(_on_paper_button_pressed)
	scissors_button.pressed.connect(_on_scissors_button_pressed)

func _on_player_choice(choice: Choice) -> void:
	player_choice = choice
	ai_choice = choices[randi() % choices.size()]
	
	update_sprites()
	determine_winner()

func update_sprites() -> void:
	match player_choice:
		Choice.ROCK:
			player_choice_texture.texture = textures[0]
		Choice.PAPER:
			player_choice_texture.texture = textures[1]
		Choice.SCISSORS:
			player_choice_texture.texture = textures[2]
			
	match ai_choice:
		Choice.ROCK:
			ai_choice_texture.texture = textures[0]
		Choice.PAPER:
			ai_choice_texture.texture = textures[1]
		Choice.SCISSORS:
			ai_choice_texture.texture = textures[2]
			
			

func determine_winner() -> void:
	if player_choice == ai_choice:
		print("Tie Game")
		tie_game.emit()
	elif (player_choice == Choice.ROCK and ai_choice == Choice.SCISSORS) or (player_choice == Choice.PAPER and ai_choice == Choice.ROCK) or (player_choice == Choice.SCISSORS and ai_choice == Choice.PAPER):
		print("Player won!")
		player_won.emit()
	else:
		print("AI WON")
		ai_won.emit()

func _on_rock_button_pressed() -> void:
	_on_player_choice(Choice.ROCK)

func _on_paper_button_pressed() -> void:
	_on_player_choice(Choice.PAPER)

func _on_scissors_button_pressed() -> void:
	_on_player_choice(Choice.SCISSORS)
