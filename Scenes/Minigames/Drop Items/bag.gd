extends CharacterBody2D


var moving_right: bool = true
var bag_speed: float = 300.0
var limit_right: int = 250
var limit_left: int = 850

func _process(delta: float) -> void:
	
	if moving_right:
		position.x += bag_speed * delta
		
	else:
		position.x -= bag_speed * delta
	
	if position.x > limit_left:
		moving_right = false
	elif position.x < limit_right:
		moving_right = true

func _physics_process(_delta: float) -> void:
	move_and_slide()
