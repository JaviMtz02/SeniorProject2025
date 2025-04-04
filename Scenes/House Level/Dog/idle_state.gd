extends NodeState

@export var dog: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var detector: RayCast2D


@onready var idle_state_timer: Timer = Timer.new() # creates a new instace of a timer
@export var idle_state_time_interval: float = 3.0 

var idle_state_timeout: bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer) # since we made the Timer, we need to add that node as a child of our scene
	
func _on_process(_delta: float) -> void:
	if dog.health <= 0:
		transition.emit("Dead")

func _on_physics_process(_delta: float) -> void:
		if detector.is_colliding():
			var target = detector.get_collider()
			if target and target.name == "Burglar": # Need to add burglar name
				transition.emit("Bark")
	

func  _on_next_transition() -> void:
	if idle_state_timeout:
		transition.emit("Walk")

func _on_enter() -> void:
	anim_sprite.play("idle")
	idle_state_timeout = false
	idle_state_timer.start()
	
func _on_exit() -> void:
	anim_sprite.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	idle_state_timeout = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		var damage_source = area.get_parent()
		var damage_val = damage_source.damage
		dog.take_damage(damage_val)
		transition.emit("Hurt")
