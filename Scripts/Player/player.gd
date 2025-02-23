class_name Player extends CharacterBody2D

@export var _player_input: PlayerInput
@export var SPEED: float = 50.0
@export var anim_sprite: AnimatedSprite2D

func _enter_tree():
	_player_input.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta: float) -> void:
	var input_dir = _player_input.input_dir
	var direction = input_dir.normalized()
	velocity = direction * SPEED
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y): # Horizontal movement
			if direction.x > 0:
				anim_sprite.flip_h = true
				anim_sprite.play("left_right")
			else:
				anim_sprite.flip_h = false
				anim_sprite.play("left_right")
		else: # Vertical Movement
			if direction.y > 0:
				anim_sprite.play("forward")
			else:
				anim_sprite.play("back")
	else:
		anim_sprite.frame = 0
		anim_sprite.stop()
	move_and_slide()
