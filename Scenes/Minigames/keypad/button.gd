extends Control

signal click

@export var INDEX:int
@export var SPEED:float = 0.25

@onready var texture_rect: TextureRect = $TextureRect

var default_text_color
@export var correct_text_color: Color = Color(0.2, 1, 0.2)
@export var incorrect_text_color: Color = Color(1, 0.2, 0.2)

var active_blinks: int = 0

func _ready():
	$Label.text = str(INDEX)
	default_text_color = $Label.get_theme_color("font_color")
	
func blink(correct:bool = false):
	active_blinks += 1
	$Label.add_theme_color_override("font_color", correct_text_color if correct else incorrect_text_color)
	await get_tree().create_timer(SPEED).timeout
	active_blinks -= 1
	if active_blinks == 0:
		$Label.add_theme_color_override("font_color", default_text_color)
	
func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		click.emit(self)
		$AudioStreamPlayer.play()
