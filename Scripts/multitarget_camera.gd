extends Camera2D

signal max_zoomed

@export var targets_parent_node: Node2D ## Parent node containing targets. For most cases we will be adding the Players node
@export var move_speed: float = 0.5 ## Camera position lerp speed
@export var zoom_speed: float = 0.05 ## Camera zoom lerp speed
@export var min_zoom: float = 2.5 ## Minimum zoom distance
@export var max_zoom: float = 5 ## Maximum zoom distance
@export var margin: Vector2 = Vector2(60, 60) ## Margin space around the targets

var targets = []
@onready var screen_size = get_viewport_rect().size

func _ready():
	await targets_parent_node.players_are_spawned
	for target in targets_parent_node.get_children():
		add_target(target)

func add_target(t):
	if not t in targets:
		targets.append(t)
		
func remove_target(t):
	if t in targets:
		targets.erase(t)

# Make sure to use global_position since most of their positions are based off their parent node. 
# This is especially important for the players in the Players: Node2D node.
func _process(delta: float):
	if !targets:
		return
	
	# Find the center position of all targets
	var p = Vector2.ZERO
	for target in targets:
		p += target.global_position
	p /= targets.size()
	position = lerp(position, p, move_speed)
	
	# Find the bounding box that contains all targets
	var r = Rect2(targets[0].global_position, Vector2.ZERO)
	for target in targets:
		r = r.expand(target.global_position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	
	# Calculate the required zoom
	var zoom_x = screen_size.x / r.size.x
	var zoom_y = screen_size.y / r.size.y
	var target_zoom = min(zoom_x, zoom_y)

	# Clamp zoom within limits
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	# Emit signal that lets whatever needs to know that the max zoom is hit, perhaps to activate a player out of bounds indicator?
	if target_zoom == max_zoom:
		max_zoomed.emit()
	
	# Apply zoom smoothly
	zoom = lerp(zoom, Vector2.ONE * target_zoom, zoom_speed)
