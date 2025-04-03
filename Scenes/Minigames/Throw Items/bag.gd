extends CharacterBody2D

var speed: float = 100.0
var moving: bool = false
var target_pos: Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if moving:
		if target_pos < global_position:
			position.x -= speed * delta
		else:
			position.x += speed * delta
			
		if abs(position.x - target_pos.x) < 5.0:
			moving = false
			
func pick_new_pos() -> void:
	var random_offset = Vector2(
		randf_range(700, 1050),
		global_position.y
	)
	target_pos = random_offset
	moving = true

func stop_movement() -> void:
	velocity = Vector2.ZERO
	moving = false
	
