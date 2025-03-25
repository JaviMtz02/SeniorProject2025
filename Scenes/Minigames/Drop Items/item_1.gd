extends RigidBody2D

@export var item: RigidBody2D
@export var pickup_area: Area2D
@export var picked_up: bool = false
@export var dropped: bool = false

signal successful_drop
signal unsuccessful_drop

func _ready() -> void:
	pickup_area.body_entered.connect(_on_body_entered)
	pickup_area.area_entered.connect(_on_area_entered)
	item.freeze = true


func _process(_delta: float) -> void:
	if picked_up and dropped:
		item.freeze = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		successful_drop.emit()
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("killzone"):
		unsuccessful_drop.emit()
		queue_free()
