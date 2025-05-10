extends Area2D
class_name WeaponPickup

signal weapon_swap(new_gun_scene)

@onready var interact_button: PackedScene = preload("res://Arcade Mode/UI/interact_button.tscn")
@export var weapon_catalog: Array[PackedScene] = [
	preload("res://Arcade Mode/Weapons/pistol/pistol.tscn"),
	preload("res://Arcade Mode/Weapons/shotgun/shotgun.tscn"),
	preload("res://Arcade Mode/Weapons/rifle/assault_rifle.tscn")
]
@export var bob_height = 5.0
@export var bob_speed = 0.75

var weapon_ID: int = 0
var current_button = null
var player_in_range = false

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite, "position:y", $Sprite.position.y - bob_height, bob_speed)
	tween.tween_property($Sprite, "position:y", $Sprite.position.y, bob_speed)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		queue_free()
		SignalBus.emit_weapon_swap(weapon_catalog[weapon_ID])

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		current_button = interact_button.instantiate()
		current_button.global_position = global_position + Vector2(0, -25)
		current_button.scale = Vector2(0.5, 0.5)
		get_tree().current_scene.add_child(current_button)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		if current_button != null:
			current_button.queue_free()
			current_button = null
