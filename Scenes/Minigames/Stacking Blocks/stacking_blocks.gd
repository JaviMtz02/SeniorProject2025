extends Node2D

@export var block: PackedScene
@export var end_line: Area2D
var check_after_landing = false
signal game_won

func _ready() -> void:
	end_line.set_collision_layer_value(1, false)
	for item in get_tree().get_nodes_in_group("blocks"):
		print(item)
		item.connect("block_landed", Callable(self, "check_collission"))
	spawn_block()
	
func spawn_block() -> void:
	var block_obj = block.instantiate()
	add_child(block_obj)
	block_obj.block_landed.connect(spawn_block)

	
func disable_collission() -> void:
	end_line.set_collision_layer_value(1, false)
	check_after_landing = true
	
func check_collission() -> void:
	print("hello")
	end_line.set_collision_layer_value(1, true)
	check_after_landing = false
	
	if end_line.has_overlapping_bodies():
		print("AHHH")
	else:
		disable_collission()
