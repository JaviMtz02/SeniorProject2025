extends Node2D

@export var anim: AnimatedSprite2D
@export var pattern: Sprite2D
@export var coin_patterns: Array[Texture2D]
var is_flipped = false
var card_pattern = -1;

signal coin_flipped(coin)

func _ready() -> void:
	pattern.visible = false
	anim.frame_changed.connect(_on_frame_changed)

func set_pattern(index: int) -> void:
	card_pattern = index
	pattern.scale = Vector2(3,3)
	pattern.texture = coin_patterns[index]


func flip() -> void:
	if is_flipped:
		return
	is_flipped = true
	anim.play()
	
func _on_frame_changed():
	if anim.frame == 6:
		anim.stop()
		if is_flipped:
			pattern.visible = true
			coin_flipped.emit(self)
		
func _on_button_pressed() -> void:
	flip()

func reset() -> void:
	is_flipped = false
	pattern.visible = false
	anim.play()
