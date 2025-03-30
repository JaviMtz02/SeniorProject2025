extends Node2D

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	anim_player.animation_finished.connect(_on_anim_finish)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	anim_player.play("break")

func _on_anim_finish(anim_name) -> void:
	if anim_name == "break":
		queue_free()
