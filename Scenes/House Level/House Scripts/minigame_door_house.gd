extends StaticBody2D

# holds scenes that will be randomly chosen!
@export var minigames: Array[PackedScene] = [] 
@export var door_area: Area2D

signal near_minigame
signal away_minigame
signal minigame_won
signal minigame_lost

func _ready() -> void:
	door_area.area_entered.connect(_on_area_entered)
	door_area.area_exited.connect(_on_area_exited)
		
func open_minigame() -> void:
	# Picks a random minigame from array that holds all of them
	var index = randi() % minigames.size()
	var title_screen = minigames[index].instantiate()
	
	# In the each level, there will be a Canvas Layer Node called MinigameLayer, where
	# the minigames will be able to be displayed at the forefront of the current level
	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	if minigame_layer:
		minigame_layer.add_child(title_screen)
	
	# The title screen for each minigame pops up, when the start button is clicked the minigame starts
	if title_screen.has_method("_on_start_game_button_pressed"):
		title_screen.start_game.pressed.connect(func(): _on_minigame_started(title_screen))

# Door should detect burglar, and when burglar presses a key, minigame should begin
# If game is won, door disappears, if not, it stays
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("minigame_interaction"):
		near_minigame.emit()
		area.get_parent().poi_nearby(self)
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("minigame_interaction"):
		away_minigame.emit()
		area.get_parent().poi_leave(self)

# When a minigame begins, it's added to the canvas layer and signals for game control are added
# these signals are signals that each minigame has, minigames have their own methods of checking of when
# games were won or lost so they can emit the proper signal.
# All minigames will have the same signals that way scripts can be reusable and there won't be a clutter of
# scripts for different signal names
# All of this keeps the game modular so the structure of the game isn't so static
func _on_minigame_started(title_screen: Node2D) -> void:
	var minigame_instance = title_screen.minigame_scene.instantiate()
	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	if minigame_layer:
		minigame_layer.add_child(minigame_instance)	
	minigame_instance.game_won.connect(_on_minigame_won)
	minigame_instance.game_lost.connect(_on_minigame_lost)

# When a minigame is won, it will its signal
# in turn the minigame door will emit its own minigame won signal that the burglar will use
# to count up the number of minigames won
func _on_minigame_won() -> void:
	minigame_won.emit()
	$DoorOpening.play()
	hide()
	await $DoorOpening.finished
	MultiplayerManager.request_remove_item.rpc(get_path())
	
func _on_minigame_lost() -> void:
	minigame_lost.emit() # door stays, burglar is penalized
