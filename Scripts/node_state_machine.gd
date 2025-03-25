class_name NodeStateMachine
extends Node

@export var initial_node_state : NodeState
var last_direction: Vector2 = Vector2.ZERO

var node_states : Dictionary = {}
var curr_node_state : NodeState
var curr_node_state_name : String
var parent_node_name: String

func _ready() -> void:
	var hitbox = get_parent().find_child("HitBox")
	if hitbox:
		hitbox.area_entered.connect(_on_area_entered)
		
	parent_node_name = get_parent().name
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
	
	if initial_node_state:
		initial_node_state._on_enter()
		curr_node_state = initial_node_state
		curr_node_state_name = curr_node_state.name.to_lower()
		

func _process(delta: float) -> void:
	if curr_node_state:
		curr_node_state._on_process(delta)

func _physics_process(delta: float) -> void:
	if curr_node_state:
		curr_node_state._on_physics_process(delta)
		curr_node_state._on_next_transition()
		#print(parent_node_name, " Current state: ", curr_node_state_name)

func transition_to(node_state_name: String) -> void:
	if node_state_name == curr_node_state.name.to_lower():
		return
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return
	if curr_node_state:
		curr_node_state._on_exit()
	new_node_state._on_enter()
	
	curr_node_state = new_node_state
	curr_node_state_name = curr_node_state.name.to_lower()
	# print("Current State: ", curr_node_state_name)	

func _on_area_entered(body):
	if curr_node_state.has_method("_on_area_entered"):
		curr_node_state._on_area_entered(body)	
