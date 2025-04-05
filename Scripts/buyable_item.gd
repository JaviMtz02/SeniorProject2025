extends RefCounted # used for objects that are automatically freed when no references point to them anymore


class_name buyable

# Attributes
var name: String
var item_type: String
var price: int
var equipped: bool = false
var bought: bool = false

# Item specific variables
var weapon: PackedScene
var capacity: int
var speed: float

func _init(item_name: String, _item_type: String, item_price: int, item_scene: PackedScene, item_space: int, item_speed: float) -> void: # Constructor
	name = item_name
	item_type = _item_type
	price = item_price
	weapon = item_scene
	capacity = item_space
	speed = item_speed

func buy() -> void: # If player has enough cash, this function will run
	if !bought:
		bought = true

func equip() -> void:
	if bought && not equipped:
		equipped = true

func unequip() -> void:
	if bought && equipped:
		equipped = false
