extends Sprite2D

@export var button: Button
@export var item: Sprite2D

signal node_name(name: String)

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	

func _on_button_pressed() -> void:
	node_name.emit(item.name)
