extends Node2D

@export var camera_2D: Camera2D

func _ready() -> void:
	if multiplayer.get_unique_id() == str(get_parent().name).to_int():
		camera_2D.make_current()

func _process(delta: float) -> void:
	pass
