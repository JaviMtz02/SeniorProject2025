extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

@onready var heavy_sword : Node2D = $HeavySword
@onready var sword_rightpos : Marker2D = $SwordRightPosition
@onready var sword_leftpos : Marker2D = $SwordLeftPosition

var direction : Vector2 = Vector2.RIGHT
var MAX_SPEED : int = 80
var ACCELERATION : int = 500
var FRICTION : int = 500

var mouse_direction : int = 1
var can_change_direction : bool = true
var is_attacking : bool = false

func _ready() -> void:
	animation_tree.active = true
	if heavy_sword:
		heavy_sword.attack_started.connect(_on_sword_attack_started)
		heavy_sword.attack_finished.connect(_on_sword_attack_finished)

func _physics_process(delta: float) -> void:
	get_user_direction()
	
	if can_change_direction:
		get_mouse_position()
	
	if heavy_sword:
		heavy_sword.scale.x = mouse_direction
		if mouse_direction == 1:
			heavy_sword.position = sword_rightpos.position
		else:
			heavy_sword.position = sword_leftpos.position
	
	if direction != Vector2.ZERO:
		update_blend_positon()
		animation_tree.get("parameters/playback").travel("walk")
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		update_blend_positon()
		animation_tree.get("parameters/playback").travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

func get_user_direction() -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()

func get_mouse_position() -> void:
	if not is_attacking:
		var mouse_pos = get_global_mouse_position()
		mouse_direction = 1 if mouse_pos.x > global_position.x else -1

func update_blend_positon() -> void:
	if can_change_direction:
		animation_tree.set("parameters/idle/blend_position", mouse_direction)
		animation_tree.set("parameters/walk/blend_position", mouse_direction)

func _on_sword_attack_started():
	is_attacking = true
	can_change_direction = false

func _on_sword_attack_finished():
	is_attacking = false
	can_change_direction = true
