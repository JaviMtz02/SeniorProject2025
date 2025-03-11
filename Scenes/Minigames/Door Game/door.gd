extends Node2D

@export var outcome: String
@export var anim: AnimatedSprite2D
@export var outcome_sprite: Sprite2D
@export var textures: Array[Texture2D]
@export var game_state: Node2D

var is_open = false


func _ready() -> void:
	anim.frame_changed.connect(_on_frame_changed)
	outcome_sprite.hide()
	

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and not is_open:
		open_door()
		

func open_door() -> void:
	is_open = true
	anim.play("open")
	
	if outcome == "Game Over":
		outcome_sprite.texture = textures[2]
		# should send signal that game is over, buggy rn because 
		# game doesn't do anything because havent added end condition
		print("Game Over!!!") 
		is_open = false
	elif outcome == "Go Back":
		outcome_sprite.texture = textures[0]
		
		game_state.decrease_level()
		game_state.randomize_doors()
		is_open = false
	else:
		outcome_sprite.texture = textures[1]
		
		game_state.increase_level()
		game_state.randomize_doors()
		is_open = false

func _on_frame_changed() -> void:
		if anim.frame == 8:
			anim.pause()
			outcome_sprite.show()
		await get_tree().create_timer(1.5).timeout
		anim.play()
		outcome_sprite.hide()
		if anim.frame == 0:
			anim.stop()
		
