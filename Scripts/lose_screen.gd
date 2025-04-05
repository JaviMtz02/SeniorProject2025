extends Node2D

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"

@onready var camera: Camera2D = $Camera2D
@export var msgs: Array[String]
@onready var msg: Label = $ScreenLayout/Control/VBoxContainer/Label2

func _ready() -> void:
	var index = randi() % msgs.size()
	msg.text = msgs[index]
	
func _process(_delta: float) -> void:
	camera.position.x += 0.5


func _on_button_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(LEVEL_SELECT))
