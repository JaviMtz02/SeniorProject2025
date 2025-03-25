extends Node2D

@export var button: Button
@export var outcome_textures: Array[Texture2D]
@export var outcome: String = ""
@export var result: Sprite2D
@export var anim: AnimatedSprite2D

var can_click: bool = true
var clicked: bool = false
signal forward
signal back
signal lose

func _ready() -> void:
	result.hide()
	button.pressed.connect(_on_button_pressed)
	

func _on_button_pressed() -> void:
	if can_click:
		open_door()
		clicked = true

func open_door() -> void:
	anim.play("door_open")
	await anim.animation_finished
	if outcome == "Go Forward":
		result.texture = outcome_textures[1]
		forward.emit()
		result.show()
		await get_tree().create_timer(0.5).timeout
		result.hide()
		anim.play("door_close")
		await anim.animation_finished
		clicked = false
	elif outcome == "Go Back":
		result.texture = outcome_textures[2]
		back.emit()
		result.show()
		await get_tree().create_timer(0.5).timeout
		result.hide()
		anim.play("door_close")
		await anim.animation_finished
		clicked = false
	else:
		result.texture = outcome_textures[0]
		result.show()
		await get_tree().create_timer(0.5).timeout
		lose.emit()
		clicked = false

func show_outcome() -> void:
	if clicked:
		return
	anim.play("door_open")
	await anim.animation_finished
	if outcome == "Go Forward":
		result.texture = outcome_textures[1]
		result.show()
	elif outcome == "Go Back":
		result.texture = outcome_textures[2]
		result.show()
	else:
		result.texture = outcome_textures[0]
		result.show()
