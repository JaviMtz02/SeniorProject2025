extends Area2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

const SPEED: int = 500

var direction
var travel_distance = 0
var stop = false
var damage: int = 0
var bullet_range: int = 800

func _physics_process(delta: float) -> void:
	if not stop:
		direction = Vector2.RIGHT.rotated(rotation)
		position += direction * SPEED * delta
		
		travel_distance += SPEED * delta
		if travel_distance > bullet_range:
			stop_bullet()

func stop_bullet() -> void:
	stop = true
	anim_player.play("hit")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	stop_bullet()
	if body.has_method("take_damage"):
		body.take_damage(damage)
