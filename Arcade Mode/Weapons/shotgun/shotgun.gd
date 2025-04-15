extends Gun

@onready var sprite: Sprite2D = %Sprite

func get_weapon_sprite() -> Node:
	return sprite

func _ready() -> void:
	super._ready()
	
	ammo_capacity = 2
	max_ammo = 2
	fire_rate = 0.8
	reload_time = 0.6
	damage = 50
	bullet_range = 55
