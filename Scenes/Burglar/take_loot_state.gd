extends NodeState

@export var burglar: CharacterBody2D
@export var loot_interaction: Area2D
@export var inventory_space: int = 10
var inventory: Array = []
var curr_loot: Area2D = null

#var pick_up_key = "ui_accept" # corresponds to X key
#func _on_process(_delta: float) -> void:
	#if Input.is_action_just_pressed(pick_up_key):
		#try_pick_up_loot(curr_loot)
#
#func _on_physics_process(_delta: float) -> void:
	#pass
#
#func try_pick_up_loot(loot: Area2D):
	#if inventory_space > len(inventory):
		#inventory.append(curr_loot)
		#inventory_space -= 1
		#curr_loot.queue_free()
		#print("Loot picked up", curr_loot.name)
	#else:
		#print("Loot: ", curr_loot.name, " could not be picked up")
	#
		#
#func  _on_next_transition() -> void:
	#pass
#
#func _on_enter() -> void:
	#pass
	#
#func _on_exit() -> void:
	#pass
