extends Node2D

@export var doors: Node
@export var label: Label

var outcomes_list: Array[String] = ["Go Forward", "Go Back", "Lose"]
var on_door: int = 1

signal game_won
signal game_lost

func _ready() -> void:
	for door in doors.get_children():
		door.forward.connect(_on_forward)
		door.back.connect(_on_back)
		door.lose.connect(_on_lose)
	take_turn()

func take_turn() -> void:
	var index: int = 0
	outcomes_list.shuffle()
	for door in doors.get_children():
		door.outcome = outcomes_list[index]
		door.can_click = true
		index += 1
		
func _on_forward() -> void:
	for door in doors.get_children():
		door.can_click = false
	on_door += 1
	if on_door > 3:
		game_won.emit()
		queue_free()
		
	update_display()
	take_turn()
	
func _on_back() -> void:
	for door in doors.get_children():
		door.can_click = false
	if on_door > 1:
		on_door -= 1
	update_display()
	take_turn()

func _on_lose() -> void:
	await show_outcome()
	game_lost.emit()
	queue_free()

func update_display() -> void:
	label.text = "Door: " + str(on_door)

func show_outcome() -> void:
	for door in doors.get_children():
		door.show_outcome()
	await get_tree().create_timer(1.5).timeout
