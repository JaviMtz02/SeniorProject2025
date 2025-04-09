extends RigidBody2D

@warning_ignore("narrowing_conversion")

@export var item: RigidBody2D
@export var item_textures: Sprite2D
@export var direction_force: float = 500
var dropped: bool = false
var landed: bool = false
var drop_speed: float = 2.5

signal block_landed
signal null_space

func _ready():
	$Thrown.play()
	add_to_group("blocks")
	apply_random_movement()

	
func _process(_delta) -> void:
	if not dropped:
		dropped = true
	if position.x < 350:
		apply_force(Vector2(direction_force, 0))
	elif position.x > 700:
		apply_force(Vector2(-direction_force, 0))
		
		

func _emit_landing_signal():
	queue_free()
	block_landed.emit()

func _emit_null_signal():
	queue_free()
	null_space.emit()
	
func _on_body_entered(body: Node) -> void:
	if not landed and body.is_in_group("ground"):
		call_deferred("_emit_landing_signal")
		landed = true
	elif not landed and body.is_in_group("killzone"):
		call_deferred("_emit_null_signal")
		
func apply_random_movement() -> void:
	item.gravity_scale = randi_range(4,7)
	item.rotation = randi_range(-PI, PI)
	item.position = Vector2(randi_range(100, 900), 300)
	var speed = randf_range(150, 400)
	var random_angle = randf_range(-PI / 6, PI)
	linear_velocity = Vector2(cos(random_angle) * speed, speed)
	apply_impulse(Vector2.ZERO, Vector2(randi_range(-100, 100), randi_range(300, 500)))
