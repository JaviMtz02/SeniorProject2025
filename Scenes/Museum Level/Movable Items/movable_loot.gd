extends RigidBody2D

@export var value: int = 0
@export var level_node: Node2D

func _ready() -> void:
	if level_node == null:
		level_node = get_tree().current_scene
	for door in get_tree().get_nodes_in_group("deposit_doors"):
		door.connect("deposit", Callable(self, "_on_deposit"))

func _on_deposit() -> void:
	level_node.deposit_loot(value, 1)
	# Play some sound here
	queue_free()
