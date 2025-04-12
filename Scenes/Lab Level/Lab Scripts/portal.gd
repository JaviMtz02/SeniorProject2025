extends Area2D

@export var portal: Area2D
@export var anim: AnimatedSprite2D
@export var orb: Area2D

signal level_complete

func _ready() -> void:
	orb.connect("open_portal", Callable(self, "_on_portal_opened"))
	portal.hide()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Burglar"):
		level_complete.emit()

func _on_portal_opened() -> void:
	portal.show()
	anim.play("portal_opening")
	await anim.animation_finished
	anim.play("portal_open")
