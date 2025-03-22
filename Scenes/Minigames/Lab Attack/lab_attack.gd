extends Node2D

@export var time_label: Label
@export var lives_label: Label
@export var timer: Timer
@export var player: CharacterBody2D

var lives: int = 10
var time: int = 30

signal game_won
signal game_lost
func _ready() -> void:
	player.connect("player_hit", Callable(self, "_on_player_hit"))
	timer.start()


func _on_timer_timeout() -> void:
	if time > 0:
		time -= 1
		if time < 10:
			time_label.text = "Time: 00:0" + str(time)
		else:
			time_label.text = "Time: 00:" + str(time)
	if time == 0:
		game_won.emit()
		queue_free()
		
func _on_player_hit() -> void:
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	if lives == 0:
		game_lost.emit()
		queue_free()
