extends Node2D

@export var vase_container: Node2D
@export var vase_buttons: Array[Button]
@export var ball: Sprite2D
@export var anim_player: AnimationPlayer

var tween: Tween
var ball_index: int = 0
var shuffling: bool = true
var vases = []

signal game_won
signal game_lost
func _ready():
	anim_player.play("RESET")
	vases = vase_container.get_children()
	
	for i in range(vase_buttons.size()):
		vase_buttons[i].pressed.connect(_on_vase_pressed.bind(i))
		
	start_game()
	
func start_game() -> void:
	
	var chosen_vase = vases.pick_random()
	var target_pos = chosen_vase.global_position
	ball_index = vases.find(chosen_vase)
	ball.position = target_pos - Vector2(0, 250)
	
	tween = create_tween()
	tween.tween_property(ball, "global_position", target_pos, 0.8).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	ball.visible = false
	shuffle_vases()

func shuffle_vases():
	anim_player.play("shuffle")
	shuffling = false
	
	
func _on_vase_pressed(index: int) -> void:
	if shuffling:
		return
	reveal_cup(index) 


func reveal_cup(index) -> void:
	shuffling = true
	var vase = vases[index]
	tween = create_tween()
	tween.tween_property(vase, "position", vase.position + Vector2(0, 40), 0.5)
	await tween.finished
	ball.visible = true
	
	if index == ball_index:
		game_won.emit()
		queue_free()
	else:
		game_lost.emit()
		queue_free()
