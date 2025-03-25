extends Area2D

@export var portal: Area2D
@export var anim: AnimatedSprite2D
@export var orb: Area2D

@onready var burglar: CharacterBody2D = get_tree().get_first_node_in_group("Burglar")

func _ready() -> void:
	orb.connect("open_portal", Callable(self, "_on_portal_opened"))
	portal.hide()



func _on_body_entered(body: Node2D) -> void:
	if body == burglar:
		print("YOU WIN")

func _on_portal_opened() -> void:
	print("i am open!")
	portal.show()
	anim.play("portal_opening")
	await anim.animation_finished
	anim.play("portal_open")
