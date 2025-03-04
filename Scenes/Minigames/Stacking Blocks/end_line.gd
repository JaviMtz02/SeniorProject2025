extends Area2D

@export var end_line: Area2D
var check_after_landing = false
signal game_won

func _ready() -> void:
	set_collision_layer_value(1, false)
	for block in get_tree().get_nodes_in_group("blocks"):
		print(block)
		block.connect("block_landed", Callable(self, "check_collission"))
	
func disable_collission() -> void:
	set_collision_layer_value(1, false)
	check_after_landing = true
	
func check_collission() -> void:
	print("hello")
	set_collision_layer_value(1, true)
	check_after_landing = false
	
	if has_overlapping_bodies():
		print("AHHH")
	else:
		disable_collission()
