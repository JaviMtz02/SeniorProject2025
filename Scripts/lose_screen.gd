extends Node2D

@onready var camera: Camera2D = $Camera2D
@export var msgs: Array[String]
@onready var msg: Label = $ScreenLayout/Control/VBoxContainer/Label2

func _ready() -> void:
	var index = randi() % msgs.size()
	msg.text = msgs[index]
	
func _process(_delta: float) -> void:
	camera.position.x += 0.5
