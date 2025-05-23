extends Node

const Player = preload("res://Arcade Mode/Player/player.tscn")
const Exit = preload("res://Arcade Mode/Environment/exit.tscn")
const GAMEOVER = preload("res://Arcade Mode/UI/death_screen.tscn")

@onready var wallMap : TileMapLayer = $Walls
@onready var floorMap : TileMapLayer = $Floor
@onready var UI: Control = %UI
@export var level_name: String = "arcade_level"
var borders = Rect2(1, 1, 47, 30)
var player = null
var object_placer = null

func _ready() -> void:
	UI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	TitleMusic.music.stop()
	$SFX.play()
	await get_tree().create_timer(6.0).timeout
	UI.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$BGMusic.play()
	generate()
	SignalBus.dead.connect(_on_dead)

func generate() -> void:
	var walker = Walker.new(Vector2(24, 15), borders)
	var map = walker.walk(350)
	
	player = Player.instantiate()
	add_child(player)
	player.position = map.front() * 32
	
	player.connect("health_change", %UI._on_player_health_change)
	player.emit_signal("health_change", player.health)
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position * 32
	
	# really dumb code -- FIX LATER
	var weapon: Node2D = player.get_node("Weapon")
	var gun = weapon.get_children()
	gun[0].connect("ammo_change", %UI._on_gun_ammo_change)
	gun[0].emit_signal("ammo_change", gun[0].ammo_capacity, gun[0].max_ammo)
	
	var available_rooms = walker.available_rooms
	walker.queue_free()
	
	for location in map:
		wallMap.erase_cell(location)
		floorMap.set_cell(location)
	
	var used_tiles = wallMap.get_used_cells()
	for tile in used_tiles:
		wallMap.erase_cell(tile)
	wallMap.set_cells_terrain_connect(used_tiles, 0, 0, 0)
	
	floorMap.set_cells_terrain_connect(map, 0, 0, 0)
	
	object_placer = ObjectPlacer.new()
	var instances = object_placer.place_objects(available_rooms, map, player.position)
	
	# Add all object instances to the scene
	for instance in instances:
		add_child(instance)

func reload_level() -> void:
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload_level (arcade)"):
		reload_level()

func _on_dead():
	var scene = GAMEOVER.instantiate()
	$Interface.add_child(scene)
