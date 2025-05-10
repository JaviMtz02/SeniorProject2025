extends Node2D
class_name Gun

signal ammo_change(ammo_capacity, max_ammo)

@export var ammo_capacity: int = 5
@export var max_ammo: int = 5
@export var fire_rate: float = 0.4
@export var reload_time: float = 0.25
@export var damage: int = 25
@export var bullet_range: int = 800
@export var bullet_scene: PackedScene = preload("res://Arcade Mode/Weapons/bullet.tscn")

# Components
@onready var pivot: Marker2D = $Pivot
@onready var shoot_point: Marker2D = %ShootPoint

# State variables
var mouse_position = null
var timer: float = 0.0
var can_fire: bool = true
var reloading: bool = false
var reload_indicator = null

# Constants
const CURSOR = preload("res://Arcade Mode/UI/basic_crosshair.png")
const RELOAD_INDICATOR = preload("res://Arcade Mode/UI/reload_indicator.tscn")

func _ready() -> void:
	var weapon = get_parent()
	if weapon:
		var player = weapon.get_parent()
		var weapon_pivot = player.get_node("WeaponPivot")
		position = Vector2.ZERO
		global_position = weapon_pivot.global_position
	
	Input.set_custom_mouse_cursor(CURSOR, Input.CURSOR_ARROW, Vector2(24, 24))
	ammo_change.emit(ammo_capacity, max_ammo)
	SignalBus.emit_ammo_change(ammo_capacity, max_ammo)

func _process(delta: float) -> void:
	handle_aiming()
	handle_weapon_state(delta)
	handle_input()
	manual_reload()
	update_reload_indicator()

func handle_aiming() -> void:
	mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	var sprite = get_weapon_sprite()
	if sprite:
		sprite.flip_v = mouse_position.x < global_position.x

func get_weapon_sprite() -> Node:
	return null

func handle_weapon_state(delta: float) -> void:
	if not can_fire:
		timer += delta
		if reloading:
			if timer >= reload_time:
				ammo_capacity += 1
				ammo_change.emit(ammo_capacity, max_ammo)
				SignalBus.emit_ammo_change(ammo_capacity, max_ammo)
				timer = 0.0
				if ammo_capacity >= max_ammo:
					finish_reload()
		elif timer >= fire_rate:
			can_fire = true
			timer = 0.0

func finish_reload() -> void:
	can_fire = true
	reloading = false
	ammo_capacity = max_ammo
	ammo_change.emit(ammo_capacity, max_ammo)
	SignalBus.emit_ammo_change(ammo_capacity, max_ammo)
	timer = 0.0

func start_reload() -> void:
	if not reloading and ammo_capacity < max_ammo:
		can_fire = false
		reloading = true
		timer = 0.0
	
func handle_input() -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if can_fire and ammo_capacity > 0:
		var new_bullet = bullet_scene.instantiate()
		$Gunshot.play()
		new_bullet.damage = damage
		new_bullet.bullet_range = bullet_range
		new_bullet.global_position = shoot_point.global_position
		new_bullet.global_rotation = shoot_point.global_rotation
		get_tree().get_root().add_child(new_bullet)
		
		ammo_capacity -= 1
		ammo_change.emit(ammo_capacity, max_ammo)
		SignalBus.emit_ammo_change(ammo_capacity, max_ammo)
		can_fire = false
		timer = 0.0

func manual_reload() -> void:
	if Input.is_action_just_pressed("reload_weapon") and not reloading and ammo_capacity < max_ammo:
		start_reload()

func update_reload_indicator() -> void:
	var player = get_parent()
	var has_indicator = player.has_node("ReloadIndicator")
	if ammo_capacity == 0 and not reloading:
		if not has_indicator:
			reload_indicator = RELOAD_INDICATOR.instantiate()
			reload_indicator.name = "ReloadIndicator"
			reload_indicator.scale = Vector2(0.3, 0.3)
			reload_indicator.position = Vector2(0, -20)
			player.add_child(reload_indicator)
	else:
		if has_indicator:
			player.get_node("ReloadIndicator").queue_free()
