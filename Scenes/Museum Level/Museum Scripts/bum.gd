extends StaticBody2D

@export var label: Label
@export var texts: Array[String] = []
@export var control: Control
@export var anim: AnimatedSprite2D
@export var minigame: PackedScene
@export var level_node: Node2D

var burglar_near: bool = false
var is_typing: bool = false
var has_won_and_encountered: bool = false
var has_encountered: bool = false
var curr_text = ""
var passcode_reversed: String = "" # get passcode from global museum script
var msg: String = ""
var has_shown_passcode: bool = false
var first_time: bool = true

signal freeze
signal near_minigame
signal away_minigame
signal minigame_won
signal minigame_lost

signal play_game
@warning_ignore("unused_signal")

func _ready() -> void:
	if level_node == null:
		level_node = get_tree().current_scene
		passcode_reversed = str(level_node.door_code).reverse()
		msg = "Remember these numbers... " + passcode_reversed[0] + "... " + passcode_reversed[1] + "... " + passcode_reversed[2] + "... " + passcode_reversed[3] + "... " + passcode_reversed[4] + "...  " + passcode_reversed[5] + "..."
	control.hide()
	anim.hide()
	label.text = ""

func _process(_delta: float) -> void:
	if has_won_and_encountered and Input.is_action_just_pressed("open_minigame") and burglar_near:
		control.show()
		await show_and_type_text(msg)
		control.hide()
	elif burglar_near and Input.is_action_just_pressed("open_minigame") and not has_encountered:
		anim.hide()
		start_typing_effect()

func start_typing_effect() -> void:
	first_time = false
	control.show()
	await type_multiple_texts(0, 3)
	control.hide()
	play_game.emit()
	#open_minigame()

func type_multiple_texts(start: int, end: int) -> void:
	for i in range(start, end):
		await show_and_type_text(texts[i])

func show_and_type_text(curr: String) -> void:
	label.text = ""
	curr_text = curr
	is_typing = true
	await type_text(curr_text)
	await wait_for_next_text()
	
func type_text(curr: String) -> void:
	for i in range(curr.length()):
		if not is_typing:
			return
		await get_tree().create_timer(0.02).timeout
		label.text += curr[i]
	is_typing = false

func wait_for_next_text() -> void:
	await get_tree().create_timer(1.0).timeout


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Burglar"):
		near_minigame.emit()
		burglar_near = true
		body.poi_nearby(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Burglar"):
		away_minigame.emit()
		burglar_near = false
		body.poi_leave(self)

func open_minigame() -> void:
	var title_screen = minigame.instantiate()
	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	if minigame_layer:
		minigame_layer.add_child(title_screen)
	if title_screen.has_method("_on_start_game_button_pressed"):
		title_screen.start_game.pressed.connect(func(): _on_minigame_started(title_screen))
	
func _on_minigame_started(title_screen: Node2D) -> void:
	freeze.emit()
	var minigame_instance = title_screen.minigame_scene.instantiate()
	var minigame_layer = get_tree().current_scene.get_node("MinigameLayer")
	if minigame_layer:
		minigame_layer.add_child(minigame_instance)
	minigame_instance.game_won.connect(_on_minigame_won)
	minigame_instance.game_lost.connect(_on_minigame_lost)
	
func _on_minigame_won() -> void:
	has_won_and_encountered = true
	control.show()
	await type_multiple_texts(3, 7)
	await show_and_type_text(msg)
	await get_tree().create_timer(2.0).timeout
	minigame_won.emit()
	control.hide()
	control.hide()

func _on_minigame_lost() -> void:
	minigame_lost.emit()
	control.show()
	await type_multiple_texts(7, 10)
	control.hide()
	has_encountered = false
