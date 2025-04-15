extends CharacterBody2D

@onready var anim_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO
var last_direction : Vector2 = Vector2(1, 0)
var blend_value : float = 1.0
const SPEED : int = 80

signal health_change(health)
var MAX_HEALTH: int = 50
var health: int = 50

@onready var pistol: PackedScene = preload("res://Arcade Mode/Weapons/pistol/pistol.tscn")
@onready var shotgun: PackedScene = preload("res://Arcade Mode/Weapons/shotgun/shotgun.tscn")
@onready var rifle: PackedScene = preload("res://Arcade Mode/Weapons/rifle/assault_rifle.tscn")
@onready var weapon: Node2D = $Weapon

func _ready() -> void:
	anim_tree.active = true
	emit_signal("health_change", health)
	update_blend_position()

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()
	
	handle_mouse_facing()

func _process(_delta: float) -> void:
	if direction != Vector2.ZERO:
		is_walking(true)
		if direction.x != 0:
			last_direction = Vector2(direction.x, 0).normalized()
		update_blend_position()
	else:
		is_walking(false)

func handle_mouse_facing() -> void:
	var mouse_position = get_global_mouse_position()
	if mouse_position.x < global_position.x:
		blend_value = -1.0
	else:
		blend_value = 1.0
	update_blend_position()

func update_blend_position() -> void:
	#blend_value = direction.x if direction.x != 0 else last_direction.x
	anim_tree["parameters/idle/blend_position"] = blend_value
	anim_tree["parameters/walk/blend_position"] = blend_value

func is_walking(value : bool) -> void:
	anim_tree["parameters/conditions/is_walking"] = value
	anim_tree["parameters/conditions/idle"] = not value

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("damage"):
		health -= 5
		if health < 0:
			health = 0
		health_change.emit(health)
	elif event.is_action_pressed("heal"):
		health += 15
		if health > MAX_HEALTH:
			health = MAX_HEALTH
		health_change.emit(health)
	elif event.is_action_pressed("pistol"):
		clear_weapon_children(weapon)
		var pistol_inst = pistol.instantiate() 
		weapon.add_child(pistol_inst)
	elif event.is_action_pressed("shotgun"):
		clear_weapon_children(weapon)
		var shotgun_inst = shotgun.instantiate() 
		weapon.add_child(shotgun_inst)
	elif event.is_action_pressed("rifle"):
		clear_weapon_children(weapon)
		var rifle_inst = rifle.instantiate() 
		weapon.add_child(rifle_inst)

func clear_weapon_children(weapon: Node2D) -> void:
	var children = weapon.get_children()
	if children:
		for child in children:
			child.queue_free()
