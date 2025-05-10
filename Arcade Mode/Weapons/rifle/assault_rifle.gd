extends Gun

@onready var sprite: Sprite2D = %Sprite

func get_weapon_sprite() -> Node:
	return sprite

func _ready() -> void:
	super._ready()
	
	ammo_capacity = 10
	max_ammo = 10
	fire_rate = 0.175
	reload_time = 0.25
	damage = 18
