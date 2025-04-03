extends Node2D

@export var to_bags_button: Button
@export var to_weapons_button: Button
@onready var bag_layout: Node2D = $"../BagLayout"
@onready var weapons_layout: Node2D = $"../WeaponsLayout"
@onready var shoes_layout: Node2D = $"."

func _ready() -> void:
	to_bags_button.pressed.connect(_on_bags_button_pressed)
	to_weapons_button.pressed.connect(_on_weapons_button_pressed)
	
func _on_bags_button_pressed() -> void:
	shoes_layout.hide()
	bag_layout.show()

func _on_weapons_button_pressed() -> void:
	shoes_layout.hide()
	weapons_layout.show()
