extends NodeState

<<<<<<< HEAD

=======
var input: DeviceInput
>>>>>>> a03a642c978d21c5e6fbffaac2be47d4dcd9c418
@export var burglar: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var loot_interaction: Area2D
@export var speed: float = 50.0
@export var footsteps_sound: AudioStreamPlayer2D

var push_force: float = 1.0

var last_frame: int

func _on_process(_delta: float) -> void:
	get_input()
	if Input.is_action_just_pressed("attack"):
		transition.emit("Attack")
	

func _on_physics_process(_delta: float) -> void:
	burglar.move_and_slide()
	
	for i in burglar.get_slide_collision_count():
		var c = burglar.get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	footsteps_sound.play()
	
func _on_exit() -> void:
	last_frame = anim_sprite.frame # Stores last frame
	anim_sprite.stop()
	burglar.velocity = Vector2.ZERO
	
func get_input():
<<<<<<< HEAD
	if not burglar.input_enabled:
		burglar.velocity = Vector2.ZERO
		return
		
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		get_parent().last_direction = direction
=======
	var direction = input.get_vector("left", "right", "up", "down")
>>>>>>> a03a642c978d21c5e6fbffaac2be47d4dcd9c418
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
		footsteps_sound.stop()
		anim_sprite.frame = 0
		transition.emit("Idle")
		anim_sprite.stop()
		
