extends Node2D

@export var to_weapons_button: Button
@export var to_shoes_button: Button
@export var cash_label: Label
@onready var bag_layout: Node2D = $"."
@onready var weapons_layout: Node2D = $"../WeaponsLayout"
@onready var shoes_layout: Node2D = $"../ShoesLayout"

var item_map: Dictionary = {} # maps the names of the items to their respective objects

func _ready() -> void:
	to_weapons_button.pressed.connect(_on_weapons_button_pressed)
	to_shoes_button.pressed.connect(_on_shoes_button_pressed)
	set_up_items()
	set_up_buttons()
	display_button()
	

func _on_weapons_button_pressed() -> void:
	$"../../../Sounds_SFX/SwitchTab".play()
	bag_layout.hide()
	weapons_layout.show()

func _on_shoes_button_pressed() -> void:
	$"../../../Sounds_SFX/SwitchTab".play()
	bag_layout.hide()
	shoes_layout.show()

func set_up_buttons() -> void:
	# This needs to connect each button with its respective signal in some efficient manner
	for item in $Items.get_children():
		for button in item.get_children():
			if button is TextureButton:
				button.pressed.connect(_on_button_pressed.bind(item, button.name))

func set_up_items() -> void:
	for item in ShopManager.bag_set:
		item_map[item.name] = item

func display_button() -> void:
	# this needs to iterate over each item, to check the status of each object, if an object is equipped,
	# the unequip button should show, if a button is unequipped and bought then the button should show equip,
	# and if the item hasn't been bought yet, it should show buy
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
	for object in ShopManager.bag_set:
		if item.name == object.name:
			desired_item = object
	match button_name:
		"BuyButton":
			if desired_item.bought == true:
				pass
			elif desired_item.bought == false && GameManager.cash >= desired_item.price:
				desired_item.buy()
				GameManager.cash -= desired_item.price
				cash_label.text = str(GameManager.cash)
				$"../../../Sounds_SFX/Buy".play()
				display_button()
		"EquipButton":
			if desired_item.bought == true and GameManager.equipped_bag == null:
				GameManager.equipped_bag = desired_item
				desired_item.equip()
				$"../../../Sounds_SFX/Equip".play()
				display_button()
		"UnequipButton":
			if desired_item.bought == true and desired_item.equipped == true and GameManager.equipped_bag != null:
				GameManager.equipped_bag = null
				desired_item.unequip()
				$"../../../Sounds_SFX/Unequip".play()
				display_button()
		_:
			pass # If it's not a button with those specific names it'll just ignore them
