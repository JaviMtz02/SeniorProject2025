extends Node

# signal emit handled in animation player
signal attack_started
signal attack_finished

@onready var animation_player = $AnimationPlayer

var previous_animation : String = ""
var combo_window : float = 2.5 # seconds
var combo_timer : float = 0.0
var in_combo : bool = false
var combo_step : int = 0
var is_mid_swing : bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	# countdown for combo timer 
	if in_combo:
		combo_timer -= delta
		if combo_timer <= 0:
			in_combo = false
			reset_stance()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if not is_mid_swing: # prevent user from attacking mid swing
			attack()

func attack() -> void:
	# don't allow user to attack mid stance reset
	if animation_player.is_playing() and animation_player.current_animation.begins_with("reset_stance"):
		return
	
	is_mid_swing = true
	
	# handle which animation to play based on which point in combo the user is in
	if combo_step == 0: # first attack
		combo_step = 1
		in_combo = true
		combo_timer = combo_window
		animation_player.play("slash_down")
		previous_animation = "slash_down"
	elif combo_step == 1: # second attack
		combo_step = 0
		in_combo = false
		animation_player.play("slash_up")
		previous_animation = "slash_up"

func reset_stance() -> void:
	if previous_animation == "slash_down":
		combo_step = 0
		in_combo = false
		animation_player.play("reset_stance_below")
	else:
		animation_player.play("reset_stance_above")

func _on_animation_finished(anim_name : String) -> void:
	if anim_name == "slash_up":
		reset_stance()
	elif anim_name == "slash_down" or anim_name.begins_with("reset_stance"):
		is_mid_swing = false
