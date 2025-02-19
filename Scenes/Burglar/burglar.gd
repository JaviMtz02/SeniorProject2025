extends CharacterBody2D

#
@export var burglar: CharacterBody2D
@export var loot_interaction: Area2D
@export var inventory_space: int = 15 # default space of 15
@export var take_loot_button: AnimatedSprite2D
@export var deposit_button: AnimatedSprite2D
@export var value_label: Label
@export var inventory_label: Label
@export var time_label: Label
@export var level_node: Node2D # dynamically stores levels


@onready var timer: Timer = $Timer
@onready var door: Area2D = $"../Door"

var curr_inventory_size: int = 0 # Checks to see if the burglar has not surpassed the bounds of what the inventory allows
var curr_loot: Area2D = null # When we're near loot, we can get its details with this variable
var inventory: Array = [] # This is to know how many single pieces of loot were obtained, Could probably do this with a variable
var value_accu: int = 0 # current value of loot obtained, this resets to zero when deposited
var time_seconds: int
var time_minutes: int
var near_door: bool = false

func _ready() -> void:
	if level_node == null:
		level_node = get_parent()
		
	# Get level settings
	if get_parent().has_method("get_level_data"):
		var level_data = get_parent().get_level_data()
		time_minutes = level_data["time_minutes"]
		time_seconds = level_data["time_seconds"]
	# Hides buttons as they only need to appear when we're around specified things
	deposit_button.hide()
	take_loot_button.hide()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.start()
	
	# This should get modified when we add different items that the burglar can purchase to increase inventory
	inventory_label.text = "0/" + str(inventory_space)
	
	# Connects corresponding loot signals and door signals
	door.connect("deposit", Callable(self, "_on_deposit"))
	door.connect("off_deposit", Callable(self, "_on_off_deposit"))
	for loot in get_tree().get_nodes_in_group("loot"):
		loot.connect("burglar_nearby", Callable(self, "_on_burglar_nearby"))
		loot.connect("burglar_away", Callable(self, "_on_burglar_away"))
#
func _process(_delta: float) -> void:
	
	if near_door and Input.is_action_just_pressed("deposit"): # If you're near the door then you can deposit your loot
		level_node.deposit_loot(value_accu, inventory.size())      # That way you can pick up more, 
		inventory.clear()
		value_accu = 0
		curr_inventory_size = 0
		value_label.text = str(value_accu)
		inventory_label.text = "0/" + str(inventory_space)
		
	# If the character is currently around loot and it pressed the 't' key, try to pick it up
	if curr_loot != null and Input.is_action_just_pressed("take_loot"):
		try_pick_up_loot(curr_loot)
	#
		#
func try_pick_up_loot(loot: Area2D) -> void:
	if curr_inventory_size <= inventory_space and (inventory_space - curr_inventory_size) >= loot.inventory_space_req:
		curr_inventory_size += loot.inventory_space_req
		inventory.append(loot)
		value_accu += loot.value
		inventory_label.text = str(curr_inventory_size) + "/" + str(inventory_space)
		value_label.text = str(value_accu)
		# Remove loot from scene
		loot.queue_free()
		curr_loot = null
	else:
		# Want to add some sound here that alerts you that you cant pick it up
		print("Not enough space in inventory!")

#
func _on_burglar_nearby(loot: Area2D): # Burglar enters the area of the loot and button that tells which button to press appears
	curr_loot = loot
	take_loot_button.show()
	take_loot_button.play()

func _on_burglar_away(_loot: Area2D): # If burglar is not in the area of loot then we cannot pick up any loot
	curr_loot = null
	take_loot_button.stop()
	take_loot_button.hide()
	

func _on_timer_timeout() -> void:
	if time_seconds > 0:
		time_seconds -= 1
	else:
		if time_minutes > 0:
			time_minutes -= 1
			time_seconds = 59
	if time_seconds < 10:
		time_label.text = str(time_minutes) + ":0" + str(time_seconds)
	else:
		time_label.text = str(time_minutes) + ":" + str(time_seconds)
	
	if time_minutes == 0 and time_seconds == 0:
		timer.stop()
		## When timer ends, screen that shows stats will come out
#
## When signal is sent out, we are able to deposit our loot at the door
## The button specifying which button to press will appear
func _on_deposit() -> void:
	near_door = true
	deposit_button.show()
	deposit_button.play()
#
## When we're away from the door, we will not be able to deposit, otherwise it'll break the game
func _on_off_deposit() -> void:
	near_door = false
	deposit_button.hide()
	deposit_button.hide()
	
