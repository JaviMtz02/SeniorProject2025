extends StaticBody2D


func _process(delta):
	position.x = lerp(position.x, get_global_mouse_position().x, 0.2)
