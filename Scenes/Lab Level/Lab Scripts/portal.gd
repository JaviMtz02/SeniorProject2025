extends Area2D

@export var portal: Area2D
@export var anim: AnimatedSprite2D
@export var orb: Area2D

var first_time: bool = true

signal burglar_nearby(loot: Area2D)
signal burglar_away(loot: Area2D)

func _ready() -> void:
	orb.connect("open_portal", Callable(self, "_on_portal_opened"))
	portal.hide()


func _on_portal_opened() -> void:
	portal.show()
	anim.play("portal_opening")
	await anim.animation_finished
	$Sound.play()
	anim.play("portal_open")


func _on_area_entered(area: Area2D) -> void:
		if area.is_in_group("loot_interaction") and int(area.get_parent().name) == multiplayer.get_unique_id() and first_time:
			emit_signal("burglar_nearby", self)
			area.get_parent().poi_nearby(self)
			first_time = false
