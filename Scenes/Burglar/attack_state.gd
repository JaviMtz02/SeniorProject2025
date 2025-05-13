extends NodeState

@export var burglar: CharacterBody2D
@export var anim_sprite: AnimatedSprite2D
@export var attack_scene: PackedScene

var attack_timer: Timer
var default_attack: PackedScene = preload("res://Scenes/Weapons/attack_hit_box.tscn")
func _ready() -> void:
	
	# This sets up how long the burglar will be in this state
	# modifying the wait time adds a larger delay into how frequently the burglar can attack
	if GameManager.equipped_weapon == null:
		attack_scene = default_attack
	else:
		attack_scene = GameManager.equipped_weapon.weapon
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.4  # Duration of attack animation	
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_finished)
	add_child(attack_timer)
	
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func  _on_next_transition() -> void:
	pass

func _on_enter() -> void:
	# Since we need to know in what direction we're gonna throw our item, in the node state machine script
	# we have a variable called last_direction that gives us the last input based on the walk state
	var direction = get_parent().last_direction
	burglar.velocity = Vector2.ZERO  # Stop moving
	
	# This will be changed dynamically based on what item the player chooses the equip
	var attack_instance = attack_scene.instantiate()
	
	# Gets absolute direction for item z_index and correct animation to play
	if abs(direction.x) > abs(direction.y): # Horizontal movement
		if direction.x > 0:
			anim_sprite.flip_h = true
			anim_sprite.play("throw_hoz")
			attack_instance.z_index = burglar.z_index + 1
		else:
			anim_sprite.flip_h = false
			anim_sprite.play("throw_hoz")
			attack_instance.z_index = burglar.z_index + 1
	else: # Vertical Movement
		if direction.y > 0:
			anim_sprite.play("throw_front")
			attack_instance.z_index = burglar.z_index + 1
			
	attack_timer.start()  # Start cooldown timer
	
	if int(get_parent().get_parent().name) == multiplayer.get_unique_id():
		get_parent().add_child(attack_instance)
		attack_instance.global_position = burglar.global_position
		attack_instance.direction = direction

func _on_exit() -> void:
	pass

func _on_attack_finished() ->void:
	# Transitions to the idle state which is a neutral state
	transition.emit("Idle")
