extends Node2D

@export var item: PackedScene
@export var attempts_left: Label
@export var items_caught_label: Label

var check_after_landing = false
var tries_left: int = 5
var items_caught: int = 0

signal game_won
signal game_lost

func _ready() -> void:
	spawn_block()
	
func spawn_block() -> void:
	var item_obj = item.instantiate()
	add_child(item_obj)
	item_obj.null_space.connect(on_null_space)
	item_obj.block_landed.connect(spawn_block)
	items_caught += 1
	items_caught_label.text = "Items\nCaught: " + str(items_caught)
	check_game()
	
	
	
func on_null_space() -> void:
	var item_obj = item.instantiate()
	add_child(item_obj)
	item_obj.block_landed.connect(spawn_block)
	item_obj.null_space.connect(on_null_space)
	tries_left -= 1
	attempts_left.text = "Attempts\nLeft: " + str(tries_left)
	check_game()

func check_game() -> void:
	if items_caught >= 10:
		print("you won")
		game_won.emit()
	elif tries_left <= 0:
		print("boohoo")
		game_lost.emit()
