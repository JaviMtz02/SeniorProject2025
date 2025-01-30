extends TextureButton
signal button_press

@export var button_index = 0

func _ready() -> void:
	print(button_index)

func _pressed() -> void:
	button_press.emit(button_index)
