extends CharacterBody2D

signal dead()

@onready var anim_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO
var last_direction : Vector2 = Vector2(1, 0)
var blend_value : float = 1.0
const SPEED : int = 60

signal health_change(health)
var MAX_HEALTH: int = 50
var health: int = 75
var is_dead: bool = false

@onready var pistol: PackedScene = preload("res://Arcade Mode/Weapons/pistol/pistol.tscn")
@onready var shotgun: PackedScene = preload("res://Arcade Mode/Weapons/shotgun/shotgun.tscn")
@onready var rifle: PackedScene = preload("res://Arcade Mode/Weapons/rifle/assault_rifle.tscn")
@onready var weapon: Node2D = $Weapon

func _ready() -> void:
	add_to_group("player")
	anim_tree.active = true
	emit_signal("health_change", health)
	SignalBus.weapon_swap.connect(_on_weapon_swap)
	update_blend_position()

func _physics_process(_delta: float) -> void:
	if !is_dead:
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
	anim_tree["parameters/die/blend_position"] = blend_value

func is_walking(value : bool) -> void:
	anim_tree["parameters/conditions/is_walking"] = value
	anim_tree["parameters/conditions/idle"] = not value

func take_damage(damage: int) -> void:
	health -= damage
	$Damage.play()
	health_change.emit(health)
	if health <= 0:
		is_dead = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_custom_mouse_cursor(null)
		SignalBus.emit_dead()
		anim_tree["parameters/conditions/die"] = true
		clear_weapon_children(weapon)
		var game_over_screen = get_node("/root/YourMainScene/CanvasLayer/GameOverScreen")
		if game_over_screen:
			game_over_screen.show_death_screen()
	else:
		modulate = Color(1, 0.3, 0.3)  # Red flash
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 1)  # Back to normal

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("damage"):
		health -= 60
		if health < 0:
			health = 0
		health_change.emit(health)
	elif event.is_action_pressed("heal"):
		health += 60
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

func _on_weapon_swap(new_gun_scene):
	clear_weapon_children(weapon)
	var new_gun = new_gun_scene.instantiate()
	weapon.add_child(new_gun)

func clear_weapon_children(weapon_node: Node2D) -> void:
	var children = weapon_node.get_children()
	if children:
		for child in children:
			child.queue_free()
