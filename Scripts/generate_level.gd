extends Node

const Player = preload("res://Scenes/Arcade Levels/aracde_player.tscn")
const Exit = preload("res://Scenes/Arcade Levels/exit.tscn")
#const Enemy = preload("res://Scenes/enemy.tscn")
#const Loot = preload("res://Scenes/loot.tscn")

@onready var floorMap = $Floor
@onready var tileMap = $Walls
var borders = Rect2(1, 1, 34, 23)
var player = null

func _ready() -> void:
	randomize()
	generate_level()

func generate_level() -> void:
	var walker = Walker.new(Vector2(17, 12), borders)
	var map = walker.walk(300)
	
	player = Player.instantiate()
	add_child(player)
	player.position = map.front() * 32
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position * 32
	exit.leaving_level.connect(reload_level)
	
	walker.queue_free()
	
	for location in map:
		tileMap.erase_cell(location)
		floorMap.set_cell(location)
	
	var used_tiles = tileMap.get_used_cells()
	for tile in used_tiles:
		tileMap.erase_cell(tile)
	tileMap.set_cells_terrain_connect(used_tiles, 0, 0, 0)
	
	floorMap.set_cells_terrain_connect(map, 0, 0, 0)

func place_object(object_scene, rooms):
	for room in rooms:
		if !(room.position * 32).distance_to(player.global_position) < 135:
			
			var object = object_scene.instantiate()
			add_child(object)
			object.global_position = room.position * 32 + Vector2(randi_range(-16, 16), randi_range(-16, 16))
			
			# Check for collision immediately
			if object is CharacterBody2D:
				# Wait for physics to process
				await get_tree().physics_frame
				
				# If the enemy is stuck and can't move it's probably in a wall
				var test_movement = object.test_move(object.transform, Vector2.RIGHT)
				if test_movement:
					# remove it
					object.queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload_level"):
		reload_level()

func reload_level() -> void:
	get_tree().reload_current_scene()
