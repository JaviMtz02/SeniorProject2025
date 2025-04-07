extends Node2D


@onready var thrower: Node2D = $Thrower
@onready var bag: CharacterBody2D = $Bag
@onready var items_in_bag: Label = $Layout/ItemsInBag
@onready var tries_left_label: Label = $Layout/TriesLeft

var tries_left: int = 3
var items: int = 0

signal game_won
signal game_lost


func _ready() -> void:
	thrower.hit.connect(_on_hit)
	thrower.no_hit.connect(_on_no_hit)
	await get_tree().create_timer(0.5).timeout
	bag.pick_new_pos()


func _on_hit() -> void:
	items += 1
	$ItemInBag.play()
	update_display()
	check_game()
	bag.pick_new_pos()

func _on_no_hit() -> void:
	tries_left -= 1
	update_display()
	check_game()
	
func update_display() -> void:
	tries_left_label.text = "Tries Left: " + str(tries_left)
	items_in_bag.text = "Items in Bag: " + str(items)

func check_game() -> void:
	if items == 5:
		game_won.emit()
		queue_free()
	elif tries_left == 0:
		game_lost.emit()
		queue_free()
