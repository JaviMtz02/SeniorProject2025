extends RigidBody2D

@export var power_factor: float = 1.5
@export var offset: float = 5.0
@export var bag_detection: Area2D

var gun

signal in_bag
signal not_in_bag

func _ready() -> void:
	gun = get_parent().find_child("Thrower", true, false)
	bag_detection.area_entered.connect(_on_area_entered)
	bag_detection.body_entered.connect(_on_body_entered)
	
	if gun != null:
		var direction = gun.direction 
		var power = gun.power
		linear_velocity = direction * power * power_factor

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("killzone"):
		not_in_bag.emit()
		queue_free()
		
func _on_area_entered(_area: Area2D) -> void:
	#add some sound here!
	in_bag.emit()
	queue_free()
