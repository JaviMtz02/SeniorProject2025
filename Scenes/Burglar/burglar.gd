extends CharacterBody2D

@export var burglar: CharacterBody2D
@export var loot_interaction: Area2D
@export var inventory_space: int = 10
var inventory: Array = []
var curr_loot: Area2D = null


func _ready() -> void:
	for loot in get_tree().get_nodes_in_group("loot"):
		loot.connect("burglar_nearby", Callable(self, "_on_burglar_nearby"))

func _process(_delta: float) -> void:
	# If the character is currently around loot and it pressed the x key, try to pick it up
	if curr_loot != null and Input.is_action_just_pressed("take_loot"):
		try_pick_up_loot(curr_loot)
		
func try_pick_up_loot(loot: Area2D) -> void:
	if inventory_space > loot.inventory_space_req:
		inventory.append(loot)
		inventory_space -= loot.inventory_space_req
		print("Picked up Loot: ", loot.name)
		
		# Remove loot from scene
		loot.queue_free()
		curr_loot = null
	else:
		print("Not enough space in inventory!")


func _on_burglar_nearby(loot: Area2D):
	curr_loot = loot
	print("Burglar is near loot: ", loot.name)
