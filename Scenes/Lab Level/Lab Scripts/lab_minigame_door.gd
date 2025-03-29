extends StaticBody2D


@export var minigames: Array[PackedScene] = [] 
@export var door_area: Area2D
@export var toggled_door: StaticBody2D

signal near_minigame
signal away_minigame
signal minigame_won
signal minigame_lost
signal freeze

func _ready() -> void:
	door_area.area_entered.connect(_on_area_entered)
	door_area.area_exited.connect(_on_area_exited)
		
func open_minigame() -> void:
	var index = randi() % minigames.size()
	var title_screen = minigames[index].instantiate()

	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	
	if minigame_layer:
		minigame_layer.add_child(title_screen)
	
	if title_screen.has_method("_on_start_game_button_pressed"):
		title_screen.start_game.pressed.connect(func(): _on_minigame_started(title_screen))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("minigame_interaction"):
		near_minigame.emit()
		area.get_parent().poi_nearby(self)
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("minigame_interaction"):
		away_minigame.emit()
		area.get_parent().poi_leave(self)

func _on_minigame_started(title_screen: Node2D) -> void:
	freeze.emit()
	var minigame_instance = title_screen.minigame_scene.instantiate()
	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	if minigame_layer:
		minigame_layer.add_child(minigame_instance)	
	minigame_instance.game_won.connect(_on_minigame_won)
	minigame_instance.game_lost.connect(_on_minigame_lost)

func _on_minigame_won() -> void:
	minigame_won.emit()
	toggled_door.queue_free() # opens door that needs this door to open
	hide()
	queue_free()
	
func _on_minigame_lost() -> void:
	minigame_lost.emit()
