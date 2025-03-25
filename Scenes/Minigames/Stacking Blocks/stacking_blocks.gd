extends Node2D

@onready var blocks_remaining: Label = $BlocksRemaining
@export var block: PackedScene
@export var end_line: Area2D
var check_after_landing = false
var blocks_available:int = 10

signal game_won
signal game_lost

func _ready() -> void:
	$StartGame.play()
	end_line.set_collision_layer_value(1, false)
	for item in get_tree().get_nodes_in_group("blocks"):
		item.connect("block_landed", Callable(self, "check_collission"))
	spawn_block()
	
func spawn_block() -> void:
	if(blocks_available > 0):
		var block_obj = block.instantiate()
		add_child(block_obj)
		block_obj.block_landed.connect(spawn_block)
		block_obj.block_landed.connect(check_collission)
		blocks_available -= 1
		blocks_remaining.text = "Blocks\nRemaining: " + str(blocks_available)

	
func disable_collission() -> void:
	end_line.set_collision_layer_value(1, false)
	check_after_landing = true
	
func check_collission() -> void:
	end_line.set_collision_layer_value(1, true)
	check_after_landing = false
	
	await get_tree().process_frame
	if end_line.has_overlapping_bodies():
		game_won.emit()
		queue_free()
	elif blocks_available == 0:
		game_lost.emit()
		queue_free()
	else:
		disable_collission()
