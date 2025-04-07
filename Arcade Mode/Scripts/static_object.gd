extends StaticBody2D
class_name StaticObject

class SpriteVariation:
	var texture: Texture2D
	var has_anim: bool
	
	func _init(tex: Texture2D, anim: bool) -> void:
		texture = tex
		has_anim = anim

var sprite_variations: Array[SpriteVariation] = []
@export var default_anim: String = "default"

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer if has_node("AnimationPlayer") else null

func _ready() -> void:
	rand_variation()

func rand_variation() -> void:
	if sprite_variations.size() > 0:
		var rand_idx = randi() % sprite_variations.size()
		var selected = sprite_variations[rand_idx]
		
		sprite.texture = selected.texture
		
		if anim_player and selected.has_anim:
			if anim_player.has_animation(default_anim):
				anim_player.play(default_anim)

func add_variation(texture: Texture2D, has_anim: bool) -> void:
	sprite_variations.append(SpriteVariation.new(texture, has_anim))
