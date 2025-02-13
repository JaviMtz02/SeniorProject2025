extends NodeState

@export var burglar: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var loot_interaction: Area2D
@export var speed: float = 50.0
var last_frame: int

func _on_process(_delta: float) -> void:
	get_input()

func _on_physics_process(_delta: float) -> void:
	burglar.move_and_slide()

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	# Use animation frame from direction
	pass
	
func _on_exit() -> void:
	last_frame = anim_sprite.frame # Stores last frame
	anim_sprite.stop()
	burglar.velocity = Vector2.ZERO
	
func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	burglar.velocity = direction * speed
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
		transition.emit("Idle")
		anim_sprite.stop()
		
