extends CharacterBody2D

@export var SPEED: float = 50.0
@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction = Vector2.ZERO

func _apply_animations(delta):
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
	
func _apply_movement_from_input(delta):
	direction = %InputSynchronizer.input_direction
	velocity = direction * SPEED
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
