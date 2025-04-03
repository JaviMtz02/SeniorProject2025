extends RefCounted # used for objects that are automatically freed when no references point to them anymore


class_name buyable

# Attributes
var name: String
var item_type: String
var price: int
var equipped: bool = false
var bought: bool = false


func _init(item_name: String, _item_type: String, item_price: int) -> void: # Constructor
	name = item_name
	item_type = _item_type
	price = item_price

func buy() -> void: # If player has enough cash, this function will run
	if !bought:
		bought = true

func equip() -> void:
	if bought && not equipped:
		equipped = true
