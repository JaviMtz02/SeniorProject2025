extends NodeState

var input: DeviceInput
@export var burglar: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var loot_interaction: Area2D
var last_frame: int

func _on_process(_delta: float) -> void:
	if not burglar.input_enabled:
		return
		
	if Input.is_action_just_pressed("attack"):
		transition.emit("Attack")
	elif is_moving():
		transition.emit("Walk")

func _on_physics_process(_delta: float) -> void:
	pass

func  _on_next_transition() -> void:
	pass

func is_moving() -> bool:
	var direction = input.get_vector("down", "left", "right", "up")
	return direction != Vector2.ZERO

func _on_enter() -> void:
	anim_sprite.frame = last_frame
	burglar.velocity = Vector2.ZERO
	
func _on_exit() -> void:
	pass
