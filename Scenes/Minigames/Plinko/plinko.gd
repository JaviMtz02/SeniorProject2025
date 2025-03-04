extends Node2D

@export var ball: PackedScene
@export var stack_limit: float = 285
var score = 0
var ball_amount = 1
@onready var score_label: Label = $Score
@onready var ball_amount_label: Label = $BallAmount


func _ready() -> void:
	for score in get_tree().get_nodes_in_group("ground"):
		score.connect("add_points", Callable(self, "_on_add_points"))
	spawn_ball()
	
func spawn_ball() -> void:
	var ball_obj = ball.instantiate()
	add_child(ball_obj)
	ball_obj.ball_landed.connect(spawn_ball)

func _on_add_points(area: Area2D):
	score += area.score
	ball_amount += 1
	score_label.text = "Score: " + str(score)
	ball_amount_label.text = "Ball: " + str(ball_amount)
	
# Need to add balls used, and how to end the minigame
