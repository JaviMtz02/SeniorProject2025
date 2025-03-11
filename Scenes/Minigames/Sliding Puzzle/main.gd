extends Area2D

@export var tiles:Array[Sprite2D] = []
var solved = []
var mouse = false

func _ready() -> void:
	start_game()

func start_game():
	solved = tiles.duplicate()
	shuffle_tiles()
	
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y / 16)
		var cols = int(mouse_copy.position.x / 16)
		check_neighbor(rows, cols)
		if tiles == solved:
			print("you win!")

func check_neighbor(rows, cols) -> void:
	var empty: bool = false
	var done: bool = false
	var pos = rows * 4 + cols
	
	while !empty and !done:
		var new_pos = tiles[pos].global_position
		if rows < 3:
			new_pos.y += 16
			empty = find_empty(new_pos, pos)
			new_pos.y -= 16
		if rows > 0:
			new_pos.y -= 16
			empty = find_empty(new_pos, pos)
			new_pos.y += 16
		if cols < 3:
			new_pos.x += 16
			empty = find_empty(new_pos, pos)
			new_pos.x -= 16
		if cols > 0:
			new_pos.x -= 16
			empty = find_empty(new_pos, pos)
			new_pos.x += 16
		done = true

func find_empty(position, pos) -> bool:
	var new_rows = int(position.y / 16)
	var new_cols = int(position.x / 16)
	var new_pos = new_rows * 4 + new_cols
	
	if tiles[new_pos] == $Slices/Tile16:
		swap_tiles(pos, new_pos)
		return true
	else:
		return false
		
func swap_tiles(tile_src, tile_dist) -> void:
	var temp_pos = tiles[tile_src].global_position
	tiles[tile_src].global_position = tiles[tile_dist].global_position
	tiles[tile_dist].global_position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dist]
	tiles[tile_dist] = temp_tile
	
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		mouse = event

func shuffle_tiles() -> void:
	var previous = 99
	var previous_two = 98
	for t in range(0,1000):
		var tile = randi() % 16

		if tiles[tile] != $Slices/Tile16 and tile != previous and tile != previous_two:
			var rows = int(tiles[tile].position.y / 16)
			var cols = int(tiles[tile].position.x / 16)
			check_neighbor(rows, cols)
			previous_two = previous
			previous = tile
