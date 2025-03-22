extends Area2D


# Blue time adder adds a Minute, takes 45 seconds to recharge
@export var anim: AnimatedSprite2D
@onready var cooldown_timer: Timer = $Timer


var can_add_time: bool = true
signal add_time

func _ready() -> void:
	cooldown_timer.wait_time = 45.0
	cooldown_timer.one_shot = true
	anim.play("ready") # static animation 
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Burglar") and can_add_time:
		can_add_time = false
		add_time.emit() # emits signal for burglar to add time
		# add sound here
		anim.play("shut_down")
		cooldown_timer.start()
		

func _on_timer_timeout() -> void:
	can_add_time = true
	anim.play("recharge")
	
