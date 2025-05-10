extends Gun

@onready var sprite: Sprite2D = %Sprite

func get_weapon_sprite() -> Node:
	return sprite

func _ready() -> void:
	super._ready()
	ammo_capacity = 5
	damage = 20
