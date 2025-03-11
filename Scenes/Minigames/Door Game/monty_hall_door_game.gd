extends Node2D

@export var door1: Node2D
@export var door2: Node2D
@export var door3: Node2D
@export var door_label: Label

var door_level: int = 1


func _ready() -> void:
	randomize_doors()
	
func randomize_doors():
	if door_level < 3:
		var outcomes = ["Game Over", "Go Back", "Next Level"]
		outcomes.shuffle()
		door1.outcome = outcomes[0]
		door2.outcome = outcomes[1]
		door3.outcome = outcomes[2]
	else:
		print("You win!")

func increase_level():
	door_level += 1
	door_label.text = "Door: " + str(door_level)
	randomize_doors()
	
func decrease_level():
	if door_level > 1:
		door_level -= 1
	door_label.text = "Door: " + str(door_level)
	randomize_doors()
