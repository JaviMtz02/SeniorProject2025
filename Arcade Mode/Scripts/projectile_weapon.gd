extends Node2D

signal ammo_change(ammo_capacity)

@onready var pivot: Marker2D = $Pivot
@onready var gun: Sprite2D = %Gun
@onready var shoot_point: Marker2D = %ShootPoint
const BULLET = preload("res://Arcade Mode/Weapons/bullet.tscn")
const CURSOR = preload("res://Arcade Mode/UI/basic_crosshair.png")
const RELOAD_INDICATOR = preload("res://Arcade Mode/UI/reload_indicator.tscn")

var mouse_position = null
var ammo_capacity: int = 5
var max_ammo: int = 5
var fire_rate: float = 0.35
var reload_time: float = 0.3
var timer: float = 0.0
var can_fire: bool = true
var reloading: bool = false
var reload_indicator = null

func _ready() -> void:
	Input.set_custom_mouse_cursor(CURSOR, Input.CURSOR_ARROW, Vector2(24, 24))
	ammo_change.emit(ammo_capacity)

func _process(delta: float) -> void:
	handle_aiming()
	handle_weapon_state(delta)
	handle_input()
	manual_reload()
	update_reload_indicator()

func handle_aiming() -> void:
	mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	gun.flip_v = mouse_position.x < global_position.x

func handle_weapon_state(delta: float) -> void:
	if not can_fire:
		timer += delta
		
		if reloading:
			# Check if we've reached the time to add another bullet
			if timer >= reload_time:
				# Add one bullet
				ammo_capacity += 1
				# Emit the signal to update UI
				ammo_change.emit(ammo_capacity)
				# Reset timer for next bullet
				timer = 0.0
				
				# If we're full, finish reloading
				if ammo_capacity >= max_ammo:
					finish_reload()
		elif timer >= fire_rate:
			can_fire = true
			timer = 0.0

func finish_reload() -> void:
	can_fire = true
	reloading = false
	# Ensure ammo is at max
	ammo_capacity = max_ammo
	ammo_change.emit(ammo_capacity)
	timer = 0.0

func start_reload() -> void:
	# Only start reload if we're not already reloading and not at full ammo
	if not reloading and ammo_capacity < max_ammo:
		can_fire = false
		reloading = true
		timer = 0.0
	
func handle_input() -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if can_fire and ammo_capacity > 0:
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = shoot_point.global_position
		new_bullet.global_rotation = shoot_point.global_rotation
		shoot_point.add_child(new_bullet)
		
		ammo_capacity -= 1
		ammo_change.emit(ammo_capacity)
		can_fire = false
		timer = 0.0

func manual_reload() -> void:
	if Input.is_action_just_pressed("reload_weapon") and not reloading and ammo_capacity < max_ammo:
		start_reload()

func update_reload_indicator() -> void:
	var player = get_parent() # Simply get the parent node
	
	# Check if the reload indicator exists in the player
	var has_indicator = player.has_node("ReloadIndicator")
	
	if ammo_capacity == 0 and not reloading:
		# Show the reload indicator if it doesn't exist
		if not has_indicator:
			var reload_indicator = RELOAD_INDICATOR.instantiate()
			reload_indicator.name = "ReloadIndicator"
			
			# Make it smaller by setting the scale
			reload_indicator.scale = Vector2(0.3, 0.3) # Adjust this value to your preference
			
			# Position it closer to the player's head
			reload_indicator.position = Vector2(0, -20) # Adjust this Y value to move it closer
			
			player.add_child(reload_indicator)
	else:
		# Hide the reload indicator if it exists
		if has_indicator:
			player.get_node("ReloadIndicator").queue_free()
