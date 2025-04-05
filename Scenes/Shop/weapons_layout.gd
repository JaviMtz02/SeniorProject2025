extends Node2D

@export var to_bags_button: Button
@export var to_shoes_button: Button
@onready var bag_layout: Node2D = $"../BagLayout"
@onready var shoes_layout: Node2D = $"../ShoesLayout"
@onready var weapons_layout: Node2D = $"."

var item_map: Dictionary = {}

func _ready() -> void:
	to_bags_button.pressed.connect(_on_bags_button_pressed)
	to_shoes_button.pressed.connect(_on_shoes_button_pressed)
	set_up_items()
	set_up_buttons()
	display_button()

func _on_bags_button_pressed() -> void:
	weapons_layout.hide()
	bag_layout.show()
	
func _on_shoes_button_pressed() -> void:
	weapons_layout.hide()
	shoes_layout.show()

func set_up_items() -> void:
	for item in ShopManager.weapon_set:
		item_map[item.name] = item
		
func set_up_buttons() -> void:
	# This needs to connect each button with its respective signal in some efficient manner
	for item in $Items.get_children():
		for button in item.get_children():
			if button is TextureButton:
				button.pressed.connect(_on_button_pressed.bind(item, button.name))
	
func display_button() -> void:
	for item in $Items.get_children():
		var curr_item = item_map[item.name]
		if curr_item.bought == false:
			for button in item.get_children():
				if button.is_in_group("interactables"):
					if button.name == "BuyButton":
						button.show()
					else:
						button.hide()
		if curr_item.bought == true && curr_item.equipped == false:
			for button in item.get_children():
				if button.is_in_group("interactables"):
					if button.name == "EquipButton":
						button.show()
					else:
						button.hide()		
		if curr_item.bought == true && curr_item.equipped == true:
			for button in item.get_children():
				if button.is_in_group("interactables"):
					if button.name == "UnequipButton":
						button.show()
					else:
						button.hide()

func _on_button_pressed(item, button_name) -> void:
	var desired_item
	for object in ShopManager.weapon_set:
		if item.name == object.name:
			desired_item = object
	match button_name:
		"BuyButton":
			if desired_item.bought == true:
				pass
			elif desired_item.bought == false && GameManager.cash >= desired_item.price:
				desired_item.buy()
				GameManager.cash -= desired_item.price
				$"../..".available_cash.text = str(GameManager.cash)
				display_button()
		"EquipButton":
			if desired_item.bought == true and GameManager.equipped_weapon == null:
				GameManager.equipped_weapon = desired_item
				desired_item.equip()
				display_button()
		"UnequipButton":
			if desired_item.bought == true and desired_item.equipped == true and GameManager.equipped_weapon != null:
				GameManager.equipped_weapon = null
				desired_item.unequip()
				display_button()
		_:
			pass # If it's not a button with those specific names it'll just ignore them
