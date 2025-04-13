extends StaticBody2D

var win_height: int
var paddle_height : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = 1152
	paddle_height = $ColorRect.get_size().y



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		global_position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("down"):
		global_position.y += get_parent().PADDLE_SPEED * delta
	
	# Limit paddle movement to window
	global_position.y = clamp(global_position.y, paddle_height / 2, win_height - paddle_height / 2)
