extends Node2D


@export var grid_size: int = 4
@export var tile_textures: Array[Texture2D]
@export var tile_scene: PackedScene
var tile_size: Vector2 # tiles should be 	16x16
var empty_space: Vector2i # tracks empty tile position
var tiles: Dictionary # stores tiles with their grid positions

# SHUFFLE AND MOVE TILE FUNCTIONS ARE MESSING UP THE GAME, needs to be fixed!
func _ready() -> void:
	create_puzzle()
	shuffle_tiles(100)
	
func create_puzzle() -> void:
	var index = 0
	for row in range(grid_size):
		for col in range(grid_size):
			var pos = Vector2i(col, row)
			if index < tile_textures.size() - 1:
				var tile_instance = tile_scene.instantiate()
				tile_instance.texture_normal = tile_textures[index]
				tile_instance.position = Vector2(pos.x * 16, pos.y * 16)
				tile_instance.set_meta("grid_pos", pos)
			
				tile_instance.tile_clicked.connect(_on_tile_clicked)
			
				add_child(tile_instance)
				tiles[pos] = tile_instance
				index += 1
			else:
				empty_space = pos

func _on_tile_clicked(tile) -> void:
	var tile_pos = tile.get_meta("grid_pos")
	if tile_pos in get_adjacent_positions(empty_space):
		move_tile(tile_pos)
		
func shuffle_tiles(moves: int):
	for i in range(moves):
		var neighbors = get_adjacent_positions(empty_space)
		var random_tile_pos = neighbors.pick_random()
		move_tile(random_tile_pos, true)

func get_adjacent_positions(pos: Vector2i) -> Array:
	var neighbors = []
	var directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	
	for dir in directions:
		var new_pos = pos + dir
		if new_pos.x >= 0 and new_pos.x < grid_size and new_pos.y >= 0 and new_pos.y < grid_size:
			neighbors.append(new_pos)
	return neighbors

func move_tile(target_pos: Vector2i, instant: bool = false) -> void: # this needs to be fixed!
	var old_empty = empty_space
	var tile = tiles.get(target_pos, null)
	if tile:
		tiles.erase(target_pos)
		tiles[empty_space] = tile
		tile.set_meta("grid_pos", old_empty)
		
		var target_pixel = Vector2(empty_space.x * 16, empty_space.y * 16)
		if instant:
			tile.position = target_pixel
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(tile, "position", target_pixel, 0.2)
		empty_space = target_pos
