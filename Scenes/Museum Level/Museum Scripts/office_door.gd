extends StaticBody2D


@export var minigame: PackedScene
@export var door_area: Area2D
@export var random_number: int
@export var level_node: Node2D

signal near_minigame
signal away_minigame
signal minigame_won
signal minigame_lost

signal freeze

var by_door: bool = false

func _ready() -> void:
	random_number = randi_range(100000, 999999)
	if level_node == null:
		level_node = get_tree().current_scene
		level_node.door_code = random_number
		
	door_area.area_entered.connect(_on_area_entered)
	door_area.area_exited.connect(_on_area_exited)

func _process(_delta: float) -> void:
	if by_door and Input.is_action_just_pressed("open_minigame"):
		open_minigame()
		
func open_minigame() -> void:
	var title_screen = minigame.instantiate()
	
	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	if minigame_layer:
		minigame_layer.add_child(title_screen)
	
	if title_screen.has_method("_on_start_game_button_pressed"):
		title_screen.start_game.pressed.connect(func(): _on_minigame_started(title_screen))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("minigame_interaction"):
		by_door = true
		near_minigame.emit()
		
func _on_area_exited(_area: Area2D) -> void:
	by_door = false
	away_minigame.emit()


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
	#$DoorOpening.play()
	hide()
	#await $DoorOpening.finished
	queue_free()
	
func _on_minigame_lost() -> void:
	minigame_lost.emit()
