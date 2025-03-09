extends Control

signal click

@export var INDEX:int
@export var SPEED:float = 1.0

const BLANK = preload("res://Scenes/Minigames/memory_game/tmpTextures/blank.png")
const ACTIVE = preload("res://Scenes/Minigames/memory_game/tmpTextures/active.png")
@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func blink() -> void:
	texture_rect.texture = ACTIVE
	audio_stream_player.pitch_scale = 0.75 + 0.05 * INDEX
	audio_stream_player.play()
	await get_tree().create_timer(SPEED).timeout
	texture_rect.texture = BLANK

func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		click.emit(self)
