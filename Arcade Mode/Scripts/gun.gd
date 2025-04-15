extends Node
class_name Gun

signal ammo_change(ammo_capacity)

@onready var pivot: Marker2D = $Pivot
@onready var gun: Sprite2D = %Gun
@onready var shoot_point: Marker2D = %ShootPoint
const BULLET = preload("res://Arcade Mode/Weapons/bullet.tscn")
const CURSOR = preload("res://Arcade Mode/UI/basic_crosshair.png")
const RELOAD_INDICATOR = preload("res://Arcade Mode/UI/reload_indicator.tscn")

var mouse_position = null
var ammo_capacity: int = 5
var max_ammo: int = 5
var fire_rate: float = 0.35
var reload_time: float = 0.3
var timer: float = 0.0
var can_fire: bool = true
var reloading: bool = false
var reload_indicator = null
