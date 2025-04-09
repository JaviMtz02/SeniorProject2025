extends Node2D


var pattern = []
var player_input = []
var sequence_index = 0
var is_player_turn: bool = false
var button_map: Dictionary = {}
var button_sound_map: Dictionary = {}
var rounds: int = 0

signal game_won
signal game_lost

func _ready() -> void:
	button_map = {
	0: $Buttons/ButtonA/Button1,
	1: $Buttons/ButtonB/Button2,
	2: $Buttons/ButtonC/Button3,
	3: $Buttons/ButtonD/Button4,
	}
	
	button_sound_map = {
		0: $Buttons/ButtonA/SoundA,
		1: $Buttons/ButtonB/SoundB,
		2: $Buttons/ButtonC/SoundC,
		3: $Buttons/ButtonD/SoundD,
	}
	
	for i in button_map.keys():
		var button = button_map[i]
		button.pressed.connect(_on_button_pressed.bind(i))
		button.set_deferred("focus_mode", Button.FOCUS_NONE)
	
	rounds += 1
	await get_tree().create_timer(2).timeout
	add_to_pattern()
	
func add_to_pattern() -> void:
	var new_step = randi() % 4
	pattern.append(new_step)
	play_sequence()
	
func play_sequence() -> void:
	#print(pattern)
	is_player_turn = false
	var hightlight_delay: float = 0.8
	for i in range(pattern.size()):
		highlight_button(pattern[i])
		await get_tree().create_timer(hightlight_delay).timeout
	is_player_turn = true

func highlight_button(index: int) -> void:
	if index in button_map:
		button_sound_map[index].play()
		var button = button_map[index]
		button.modulate = Color(1.9, 1.9, 0)
		await get_tree().create_timer(0.5).timeout
		button.modulate = Color(1, 1, 1)
	
func _on_button_pressed(button_index) -> void:
	button_sound_map[button_index].play()
	if is_player_turn:
		player_input.append(button_index)
		if player_input[player_input.size() - 1] != pattern[player_input.size() - 1]:
			game_lost.emit()
			queue_free()
		if player_input.size() == pattern.size():
			await get_tree().create_timer(1.0).timeout
			start_next_round()
			
func start_next_round() -> void:
	if rounds < 6:
		player_input.clear()
		add_to_pattern()
		rounds += 1
	else:
		game_won.emit()
		queue_free()
