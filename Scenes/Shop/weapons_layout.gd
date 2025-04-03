extends Node2D

@export var to_bags_button: Button
@export var to_shoes_button: Button
@onready var bag_layout: Node2D = $"../BagLayout"
@onready var shoes_layout: Node2D = $"../ShoesLayout"
@onready var weapons_layout: Node2D = $"."


func _ready() -> void:
	to_bags_button.pressed.connect(_on_bags_button_pressed)
	to_shoes_button.pressed.connect(_on_shoes_button_pressed)


func _on_bags_button_pressed() -> void:
	weapons_layout.hide()
	bag_layout.show()
	
func _on_shoes_button_pressed() -> void:
	weapons_layout.hide()
	shoes_layout.show()
