extends CharacterBody2D

# Signal gets sent out when a player collides with an enemy

@export var speed = 50.0
@export var anim: AnimatedSprite2D
@export var chaser: CharacterBody2D
@export var orb: Area2D

# continuosly gets input for direction
func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y): # Horizontal movement
			if direction.x > 0:
				anim.flip_h = true
				anim.play("left_right")
			else:
				anim.flip_h = false
				anim.play("left_right")
		else: # Vertical Movement
			if direction.y > 0:
				anim.play("forward")
			else:
				anim.play("back")
	else:
		anim.frame = 0
		anim.stop()

func _physics_process(_delta):
	get_input()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == chaser:
		print("You lost!")
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == orb:
		print("You win")
