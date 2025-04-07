extends RigidBody2D

@export var block: RigidBody2D
@export var move_speed: float = 5.0 # speed at which the object moves
var direction: int = 1 # direction to where block will move
var dropped: bool = false
var landed: bool = false
var drop_speed: float = 2.5

signal block_landed

func _ready():
	add_to_group("blocks")
	block.position = Vector2(550, 64)
	block.freeze = true
	
func _process(_delta) -> void:
	if not dropped:
		position.x += move_speed * direction
		if position.x >= 800:
			direction = -1
		elif position.x <= 300:
			direction = 1
	
	if Input.is_action_just_pressed("attack") and not dropped: # if the down key is pressed, and the block can move, the block will drop
		block.freeze = false
		linear_velocity = Vector2(0, drop_speed)
		dropped = true
		

func _on_body_entered(_body: Node) -> void:
	if not landed:
		call_deferred("_emit_landing_signal")
		landed = true

func _emit_landing_signal():
	$BlockLanded.play()
	block_landed.emit()
