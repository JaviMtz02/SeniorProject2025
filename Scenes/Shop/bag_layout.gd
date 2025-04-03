extends Node2D

@export var to_weapons_button: Button
@export var to_shoes_button: Button
@onready var bag_layout: Node2D = $"."
@onready var weapons_layout: Node2D = $"../WeaponsLayout"
@onready var shoes_layout: Node2D = $"../ShoesLayout"


func _ready() -> void:
	to_weapons_button.pressed.connect(_on_weapons_button_pressed)
	to_shoes_button.pressed.connect(_on_shoes_button_pressed)
	set_up_buttons()
	display_button()
	

func _on_weapons_button_pressed() -> void:
	bag_layout.hide()
	weapons_layout.show()

func _on_shoes_button_pressed() -> void:
	bag_layout.hide()
	shoes_layout.show()

func set_up_buttons() -> void:
	# This needs to connect each button with its respective signal in some efficient manner
	pass
	
func display_button() -> void:
	# this needs to iterate over each item, to check the status of each object, if an object is equipped,
	# the unequip button should show, if a button is unequipped and bought then the button should show equip,
	# and if the item hasn't been bought yet, it should show buy
	pass
