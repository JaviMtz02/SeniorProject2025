extends CharacterBody2D


var window_size: Vector2
const START_SPEED: int = 500
const ACCEL: int = 50
var speed: int
var dir: Vector2
const MAX_Y_VECTOR: float = 0.6

func _ready() -> void:
	window_size = get_viewport_rect().size
	
func new_ball() -> void:
	#Randomize start position and direction
	$"../NewBall".play()
	position.x = window_size.x / 2
	position.y = randi_range(200, window_size.y - 200)
	speed = START_SPEED
	dir = random_direction()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		$"../Collision".play()
		collider = collision.get_collider()
		if collider == $"../Player" or collider == $"../CPU":
			speed += ACCEL
			dir = new_dir(collider)
		else:
			dir = dir.bounce(collision.get_normal())

func random_direction() -> Vector2:
	var _new_dir: Vector2
	_new_dir.x = [1, -1].pick_random()
	_new_dir.y = [1, -1].pick_random()
	return _new_dir.normalized()

func new_dir(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var _new_dir_: Vector2
	
	if dir.x > 0:
		_new_dir_.x = -1
	else:
		_new_dir_.x = 1
	_new_dir_.y = (dist / (collider.paddle_height / 2)) * MAX_Y_VECTOR
	return _new_dir_.normalized()
