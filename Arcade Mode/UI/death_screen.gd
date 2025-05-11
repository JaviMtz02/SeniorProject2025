extends Control

# Reference to UI elements
@onready var background = $ColorRect
@onready var death_text = $Label
var scene_to_load = "res://Arcade Mode/UI/arcade_menu.tscn"

# Animation variables
var fade_duration = 2.0
var initial_wait = 0.5

func _ready():
	# Start with everything invisible
	background.modulate.a = 0
	death_text.modulate.a = 0
	
	# Start the death sequence
	show_death_screen()

func show_death_screen():
	# Wait a moment before starting animation
	await get_tree().create_timer(initial_wait).timeout
	$SFX.play()
	
	# Fade in the dark background
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 0.7, fade_duration / 2.0)
	await tween.finished
	
	# Fade in the text
	tween = create_tween()
	tween.tween_property(death_text, "modulate:a", 1.0, fade_duration)
	
	await get_tree().create_timer(6.0).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file(scene_to_load)
