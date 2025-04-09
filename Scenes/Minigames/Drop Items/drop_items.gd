extends Node2D

signal game_won
signal game_lost

var tries_left: int = 3
var items_in_bag: int = 0
var items_to_drop: int = 5

@export var items: Node
@onready var items_in_bag_label: Label = $Labels/ItemsInBag

func _ready() -> void:
	for item in items.get_children():
		item.successful_drop.connect(_on_successful_drop)
		item.unsuccessful_drop.connect(_on_unsuccessful_drop)
		
func _on_successful_drop() -> void:
	items_in_bag += 1
	items_to_drop -= 1
	update_display()
	$ItemInBagSound.play()
	if items_in_bag == 5:
		game_won.emit()
		queue_free()
	

func _on_unsuccessful_drop() -> void:
	game_lost.emit()
	queue_free()

func update_display() -> void:
	items_in_bag_label.text = "Items in Bag: " + str(items_in_bag)	
