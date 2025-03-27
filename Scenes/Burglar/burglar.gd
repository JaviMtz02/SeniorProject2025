extends CharacterBody2D

# This script basically acts as the game manager for the levels
# It controls time, loot obtained, and minigames starting
@export var burglar: CharacterBody2D
@export var loot_interaction: Area2D
@export var minigame_interaction: Area2D
@export var inventory_space: int = 15 # default space of 15, this should be modifiable when we add inventory upgrades
@export var take_loot_button: AnimatedSprite2D
@export var deposit_button: AnimatedSprite2D
@export var minigame_button: AnimatedSprite2D
@export var value_label: Label
@export var inventory_label: Label
@export var time_label: Label
@export var level_node: Node2D # dynamically stores levels
@export var minigame_doors: Node

@onready var timer: Timer = $Timer

var curr_inventory_size: int = 0 # Checks to see if the burglar has not surpassed the bounds of what the inventory allows
var curr_loot: Area2D = null # When we're near loot, we can get its details with this variable
var inventory: Array = [] # This is to know how many single pieces of loot were obtained, Could probably do this with a variable
var value_accu: int = 0 # current value of loot obtained, this resets to zero when deposited
var time_seconds: int
var time_minutes: int
var near_door: bool = false
var input_enabled: bool = true
var minigames_won: int = 0

func _ready() -> void:
	if MultiplayerManager.is_multiplayer() and int(name) != multiplayer.get_unique_id():
		$StateMachine.process_mode = Node.PROCESS_MODE_DISABLED
	
	if level_node == null:
		level_node = get_parent().get_parent()
		
	# Get level settings
	if level_node.has_method("get_level_data"):
		var level_data = level_node.get_level_data()
		time_minutes = level_data["time_minutes"]
		time_seconds = level_data["time_seconds"]
		
	# Hides buttons as they only need to appear when we're around specified things
	deposit_button.hide()
	take_loot_button.hide()
	minigame_button.hide()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.start()
	
	# This should get modified when we add different items that the burglar can purchase to increase inventory
	inventory_label.text = "0/" + str(inventory_space)
	
	# Connects corresponding loot signals and door signals for depositing collected loot
	for door in get_tree().get_nodes_in_group("deposit_doors"):
		door.connect("deposit", Callable(self, "_on_deposit"))
		door.connect("off_deposit", Callable(self, "_on_off_deposit"))
	
	# Connects signals for minigames, each minigame is stored inside a door scene
	for minigame_door in get_tree().get_nodes_in_group("doors"):
		minigame_door.connect("near_minigame", Callable(self, "_on_near_minigame"))
		minigame_door.connect("away_minigame", Callable(self, "_on_away_minigame"))
		minigame_door.connect("minigame_won", Callable(self, "_on_minigame_won"))
		minigame_door.connect("minigame_lost", Callable(self, "_on_minigame_lost"))
		
	for loot in get_tree().get_nodes_in_group("loot"):
		loot.connect("burglar_nearby", Callable(self, "_on_burglar_nearby"))
		loot.connect("burglar_away", Callable(self, "_on_burglar_away"))
	
	if level_node.level_name == "laboratory":
		for interactable in get_tree().get_nodes_in_group("time_adders"):
			interactable.connect("add_time", Callable(self, "_on_add_time"))
#
func _process(_delta: float) -> void:
	if near_door and Input.is_action_just_pressed("deposit"): # If you're near the door then you can deposit your loot
		$SFX/Deposit.play()
		level_node.deposit_loot(value_accu, inventory.size())      # That way you can pick up more, 
		inventory.clear()
		value_accu = 0
		curr_inventory_size = 0
		value_label.text = str(value_accu)
		inventory_label.text = "0/" + str(inventory_space)
		
	# If the character is currently around loot and it pressed the 't' key, try to pick it up
	if curr_loot != null and Input.is_action_just_pressed("take_loot"):
		try_pick_up_loot(curr_loot)


func try_pick_up_loot(loot: Area2D) -> void:
	# If the current inventory size is less than the total inventory space, and if those two are greater
	# than or equal to the loot's inventory space required that we are currently trying to pick up, then
	# we can pick up the loot
	if curr_inventory_size <= inventory_space and (inventory_space - curr_inventory_size) >= loot.inventory_space_req:
		curr_inventory_size += loot.inventory_space_req
		inventory.append(loot)
		value_accu += loot.value
		
		#UI updates
		inventory_label.text = str(curr_inventory_size) + "/" + str(inventory_space)
		value_label.text = str(value_accu)
		
		# Play appropriate pickup sound and remove loot from scene
		if loot.is_in_group("coins"):
			$SFX/CoinPickup.play()
			loot.hide()
			await $SFX/CoinPickup.finished
		else:
			$SFX/LootPickup.play()
			loot.hide()
			await $SFX/LootPickup.finished
		loot.queue_free()
		curr_loot = null
	else:
		$SFX/CannotPickup.play() # if loot can't be picked up, a sound will play letting the player know that it can't be picked up

# Function that decreases timer
func _on_timer_timeout() -> void:
	if input_enabled:
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


##################### INTERACTIBLE SIGNALS #####################################
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
	
	#  Burglar enters the area of the loot and button that tells which button to press appears
func _on_burglar_nearby(loot: Area2D): 
	curr_loot = loot
	take_loot_button.show()
	take_loot_button.play()

func _on_burglar_away(_loot: Area2D): # If burglar is not in the area of loot then we cannot pick up any loot
	curr_loot = null
	take_loot_button.stop()
	take_loot_button.hide()

# Button to play minigame appears/disappears based off of the two functions below
func _on_near_minigame() -> void:
	minigame_button.show()
	minigame_button.play()
	
func _on_away_minigame() -> void:
	minigame_button.stop()
	minigame_button.hide()

# This is for the stats at the end of the level
# To achieve the star for perfect run on minigames, the player's minigames_won var should be
# exactly the amount of doors in the levels that contain minigames, whenever a minigame is lost, the var
# will go down by a point, so it will be impossible to get the perfect run star
func _on_minigame_won() -> void:
	minigames_won += 1
	input_enabled = true
	
func _on_minigame_lost() -> void:
	$SFX/CannotPickup.play()
	minigames_won -= 1
	input_enabled = true
	decide_punishment()

# If the player loses the game, then something bad must happen
func decide_punishment() -> void:
	var option: int = randi() % 2
	if option == 0 and value_accu > 0:
		value_accu -= randi() % value_accu
		value_label.text = str(value_accu)
	elif option == 1:
		time_seconds -= randi() % 16
	

func _on_mob_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("mob_near"):
		decide_punishment()


# Time adder signal that adds time to the game!
func _on_add_time() -> void:
	time_minutes += 1
