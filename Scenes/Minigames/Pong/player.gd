extends StaticBody2D

var win_height: int
var paddle_height : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	paddle_height = $ColorRect.get_size().y



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("down"):
		position.y += get_parent().PADDLE_SPEED * delta
	
	# Limit paddle movement to window
	position.y = clamp(position.y, paddle_height / 2, win_height - paddle_height / 2)
