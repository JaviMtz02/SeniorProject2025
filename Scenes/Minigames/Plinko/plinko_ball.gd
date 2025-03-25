extends RigidBody2D

@export var ball: RigidBody2D
@export var move_speed: float = 2.5 # speed at which the object moves
var drop_speed: float = 2.5
var direction: int = 1 # direction to where block will move
var dropped: bool = false
var landed: bool = false
var can_play: bool = false

signal ball_landed

func _ready():
	ball.position = Vector2(550, 465)
	for score in get_tree().get_nodes_in_group("ground"):
		score.connect("add_points", Callable(self, "_on_add_points"))
	ball.freeze = true
	
func _process(_delta) -> void:
	if not dropped:
		position.x += move_speed * direction
		if position.x >= 660:
			direction = -1
		elif position.x <= 440:
			direction = 1
	
	if Input.is_action_just_pressed("down") and not dropped: # if the down key is pressed, and the block can move, the block will drop
		ball.freeze = false
		linear_velocity = Vector2(0, drop_speed)
		dropped = true

func _on_add_points(_area: Area2D):
	if not landed:
		ball.physics_material_override.bounce = 0
		call_deferred("_emit_landing_signal")
		landed = true
	
func _emit_landing_signal():
	ball_landed.emit()
	queue_free()
	
		
