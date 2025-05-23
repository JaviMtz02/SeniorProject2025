extends Node2D


@export var attack_speed: float = 150.0
@export var lifetime: float = 1.5
@export var timer: Timer
@export var damage: int = 1
@export var rotation_speed: float = 15.0
@export var hitbox: Area2D
@export var sound: AudioStreamPlayer2D

var direction: Vector2

func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	$ThrowSound.play()
	timer.start()

func _process(delta: float) -> void:
	position += direction * attack_speed * delta
	rotation += rotation_speed * delta

func _on_area_entered(area: Area2D) ->void:
	if area.is_in_group("blocks"):
		$ColissionSound.play()
		
