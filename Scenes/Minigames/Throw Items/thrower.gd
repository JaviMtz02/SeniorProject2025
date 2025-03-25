extends Node2D

@export var item: PackedScene
@export var trajectory_point: PackedScene
@export var spawn_pos: Node2D

const NUMBER_OF_PROJECTILES := 7

var traj = []
var power: float = 0.0
var direction: Vector2
var first := true
var fire := false

signal hit
signal no_hit

func _ready() -> void:
	create_projectiles()

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	direction = (mouse_pos - global_position).normalized()
	power = (mouse_pos - global_position).length()
	
	rotation = direction.angle()
	if not fire:
		create_projectiles()
		
		if Input.is_action_just_pressed("attack"):
			var shot = item.instantiate()
			get_parent().add_child(shot)
			shot.in_bag.connect(_on_in_bag)
			shot.not_in_bag.connect(_on_not_in_bag)
			shot.global_position = traj[1].global_position

func create_projectiles() -> void:
	var projectile_offset_x = direction.x / NUMBER_OF_PROJECTILES
	var projectile_offset_y = direction.y / NUMBER_OF_PROJECTILES
	
	for i in range(NUMBER_OF_PROJECTILES):
		var pos = Vector2(
			spawn_pos.global_position.x + (i * 200) * projectile_offset_x,
			spawn_pos.global_position.y + (i * 200) * projectile_offset_y
		)
		
		if first:
			var traj_point = trajectory_point.instantiate()
			get_parent().add_child.call_deferred(traj_point)
			traj_point.global_position = pos
			traj.append(traj_point)
		
		traj[i].global_position = pos
	first = false

func _on_in_bag() -> void:
	hit.emit()
	
func _on_not_in_bag() -> void:
	no_hit.emit()
