extends Node2D

@onready var buttons: Control = $Buttons
@onready var code_label: Label = $CodeLabel
@onready var label: Label = $Label
@onready var code_bg: Sprite2D = $CodeBG
@onready var grid_container: GridContainer = $Buttons/GridContainer
@onready var code_display: Label = $CodeDisplay

var code: int
var entered_number: String = ""

signal game_won
signal game_lost

func _ready() -> void:
	for button in grid_container.get_children():
		if button is TextureButton:
			button.pressed.connect(func(): _on_button_pressed(button.name))
			
	code = randi_range(1000, 9999)
	code_label.text = str(code)
	show_code()
	
func show_code() -> void:
	for n in 3:
		code_bg.show()
		label.show()
		code_label.show()
		await get_tree().create_timer(0.15).timeout
		code_bg.hide()
		label.hide()
		code_label.hide()
		await get_tree().create_timer(0.15).timeout


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
	if int(entered_number) == code:
		game_won.emit()
		queue_free()
	else:
		game_lost.emit()
		queue_free()

func append_digit(button_name: String) -> void:
	var digit = button_name.replace("TextureButton", "")
	if entered_number.length() < 4:
		entered_number += digit
		update_display()

func update_display() -> void:
	code_display.text = entered_number
