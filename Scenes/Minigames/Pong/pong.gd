extends Node2D


var score: Array[int] = [0,0]
const PADDLE_SPEED : int = 500
@onready var player_score: Label = $PlayerScore
@onready var cpu_score: Label = $CPUScore
@onready var ball_timer: Timer = $BallTimer

signal game_won
signal game_lost

func _on_ball_timer_timeout() -> void:
	check_game()
	$Ball.new_ball()


func _on_score_left_body_entered(_body: Node2D) -> void:
	score[1] += 1
	cpu_score.text = str(score[1])
	ball_timer.start()


func _on_score_right_body_entered(_body: Node2D) -> void:
	score[0] += 1
	player_score.text = str(score[0])
	ball_timer.start()

func check_game() -> void:
	if score[0] == 5:
		game_won.emit()
		queue_free()
	elif score[1] == 5:
		game_lost.emit()
		queue_free()
