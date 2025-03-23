extends StaticBody2D

var ball_pos: Vector2
var dist: int
var move_by: int
var window_height: int
var paddle_height: int
#
func _ready() -> void:
	window_height = get_viewport_rect().size.y
	paddle_height = $ColorRect.get_size().y



func _process(delta: float) -> void:
	ball_pos = $"../Ball".position
	dist = position.y - ball_pos.y
	
	if abs(dist) > get_parent().PADDLE_SPEED * delta:
		move_by = get_parent().PADDLE_SPEED * delta * (dist / abs(dist))
	else:
		move_by = dist
	position.y -= move_by
	position.y = clamp(position.y, paddle_height / 2, window_height - paddle_height / 2)
	
