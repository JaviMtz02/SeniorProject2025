extends CharacterBody2D

@export var texture: Sprite2D
@export var bullet_pos: Node2D
@export var timer: Timer
var bullet_scene = preload("res://Scenes/Minigames/Lab Attack/bullet.tscn")

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	
func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and timer.is_stopped():
		fire()
		timer.start()

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.dir = rotation
	bullet.pos = bullet_pos.global_position
	bullet.rota = global_rotation
	
	get_parent().add_child(bullet)


func _on_timer_timeout() -> void:
	pass
