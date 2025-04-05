extends Node2D

@export var flashlight: PointLight2D
@export var items: Node
@export var shadow: CanvasModulate
@export var background: ColorRect
@export var red_bg: TextureRect
@export var item_to_find: Sprite2D
@export var label: Label

@onready var countdown_timer: Timer = $CountdownTimer
@onready var time_left: Label = $Layout/TimeLeft


signal game_won
signal game_lost

var time: int = 15
var item_names: Array[String]  = []
var item_textures: Array[Texture2D] = []
var target_item: String = ""
var target_item_texture: Texture2D

func _ready() -> void:
	countdown_timer.wait_time = 1.0
	shadow.hide()
	flashlight.hide()
	background.show()
	red_bg.show()
	item_to_find.show()
	label.show()
	for item in items.get_children():
		if item is Sprite2D:
			item.node_name.connect(_on_node_name_received)
			item_names.push_back(item.name)
			item_textures.push_back(item.texture)
	play_game()
	
func _process(_delta: float) -> void:
	flashlight.global_position = get_global_mouse_position()
	
func play_game() -> void:
	var random_index = randi() % item_names.size()
	target_item = item_names[random_index]
	target_item_texture = item_textures[random_index]
	item_to_find.texture = target_item_texture
	await get_tree().create_timer(2.0).timeout
	countdown_timer.start()
	item_to_find.hide()
	shadow.show()
	flashlight.show()
	red_bg.hide()
	background.hide()
	label.hide()

	
func _on_node_name_received(item_name: String) -> void:
	if item_name == target_item:
		game_won.emit()
		queue_free()


func _on_countdown_timer_timeout() -> void:
	if time >= 10:
		time -= 1
		time_left.text = "Time: 00:" + str(time)
	elif time > 0 and time < 10:
		time -= 1
		time_left.text = "Time: 00:0" + str(time)
	else:
		game_lost.emit()
		queue_free()
		
