extends Node2D


@export var level_node: Node2D

@onready var grid: Control = $GridContainer
@onready var label: Label = $Label

var entered_number: String = ""
var random_number: int

signal game_won
signal game_lost

func _ready() -> void:
	if level_node == null:
		level_node = get_tree().current_scene
		random_number = level_node.door_code
		
	for button in grid.get_children():
		if button is TextureButton:
			button.pressed.connect(func(): _on_button_pressed(button.name))

func _on_button_pressed(button_name: String) -> void:
	match button_name:
		"ButtonClear":
			clear_number()
		"ButtonEnter":
			process_entered_number()
		_:
			append_digit(button_name)
	
func clear_number() -> void:
	entered_number = ""
	update_display()

func process_entered_number() -> void:
	if int(entered_number) == random_number:
		game_won.emit()
		queue_free()
	else:
		game_lost.emit()
		queue_free()

func append_digit(button_name: String) -> void:
	var digit = button_name.replace("TextureButton", "")
	if entered_number.length() < 6:
		entered_number += digit
		update_display()

func update_display() -> void:
	label.text = entered_number
