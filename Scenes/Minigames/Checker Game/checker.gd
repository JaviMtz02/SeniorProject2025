extends Node2D

@export var anim: AnimatedSprite2D
@export var button: Button

var is_flipped = false
@export var affected_checkers: Array[Node2D] = []

signal checker_toggled()

func _ready():
	anim.frame_changed.connect(_on_frame_changed)
	for checker in affected_checkers:
		self.checker_toggled.connect(checker._on_checker_toggled)

func _on_button_pressed() -> void:
	toggle()
	checker_toggled.emit()
	
func toggle() -> void:
	is_flipped = !is_flipped
	update_sprite()
	
func update_sprite() -> void:
	if is_flipped:
		anim.play("flip")
	else:
		anim.play("unflip")

func _on_frame_changed():
	if anim.frame == 6:
		if is_flipped:
			anim.animation = "unflip"
			anim.stop()
		else:
			anim.animation = "flip"
			anim.stop()

func _on_checker_toggled() -> void:
	toggle()
