extends CharacterBody2D

@export var burglar: CharacterBody2D
@export var anim: AnimatedSprite2D

var speed = 250.0
var item_to_pick = null
var is_holding_item: bool = false
var pickup_offset = Vector2(0, 15)
var held_item = null

func get_input():
	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input_x != 0:
		if input_x > 0:
			anim.flip_h = true
			anim.play("left_right")
		elif input_x < 0:
			anim.flip_h = false
			anim.play("left_right")
	else:
		anim.frame = 0
		anim.stop()
		
	velocity = Vector2(input_x, 0) * speed

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if not is_holding_item and item_to_pick:
			pick_up_item()
		elif is_holding_item:
			drop_item()
			
func _physics_process(_delta):
	get_input()
	move_and_slide()


func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("blocks"):
		item_to_pick = body



func _on_pick_up_area_body_exited(_body: Node2D) -> void:
	item_to_pick = null
	
func pick_up_item() -> void:
	is_holding_item = true
	held_item = item_to_pick
	held_item.get_parent().remove_child(held_item)
	burglar.add_child(held_item)
	$PickupSound.play()
	held_item.global_position = burglar.global_position + pickup_offset
	held_item.picked_up = true
	burglar.show()

func drop_item() -> void:
	is_holding_item = false
	held_item.dropped = true
	item_to_pick = null
	$DropSound.play()
