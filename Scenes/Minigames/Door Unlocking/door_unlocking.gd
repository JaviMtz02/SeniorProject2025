extends Node2D

@onready var label: Label = $Label

@export var pointer: Sprite2D
@export var bars: Array[Node2D]
@export var speed: float = 1000.0
@export var moving_right: bool = true

var limit_left: float = 100.0
var limit_right: float = 1075.0
var tries: int = 3
const ACCEL: float = 250.0

signal game_won
signal game_lost

func _process(delta: float) -> void:
	check_input()
	if moving_right:
		pointer.position.x += speed * delta
		if pointer.position.x >= limit_right:
			moving_right = false
	else:
		pointer.position.x -= speed * delta
		if pointer.position.x <= limit_left:
			moving_right = true
			
func check_input() -> void:
	if Input.is_action_just_pressed("attack"):
		check_hit()
		
func check_hit() -> void:
	var closest_bar = bars[0]
	var closest_dist = abs(pointer.position.x - bars[0].position.x)
	
	for bar in bars:
		var dist = abs(pointer.position.x - bar.position.x)
		if dist < closest_dist:
			closest_dist = dist
			closest_bar = bar
			
	
	if closest_bar == bars[2]:
		game_won.emit()
		print("you win")
		queue_free()
	elif closest_bar == bars[1] or bars[3]:
		if tries > 0:
			speed += ACCEL
			tries -= 1
			label.text = "Tries Left: " + str(tries)
		else:
			print("you lose")
			game_lost.emit()
			queue_free()
	else:
		print("you lose")
		game_lost.emit()
		queue_free()
