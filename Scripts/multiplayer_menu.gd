extends Control

const PLAY_MENU = "res://Scenes/Menus/play_menu.tscn"
const WAITING_SCREEN = "res://Scenes/Menus/waiting_screen.tscn"
@onready var buttons: VBoxContainer = $MarginContainer/Buttons
@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var error: Label = $Error
@onready var host_ip: TextEdit = $"Host IP"

func _ready() -> void:
	MultiplayerManager.player_connected.connect(_player_connected)

func host_select():
	var success = MultiplayerManager.start_host()
	if success:
		$AnimationPlayer.play("Connecting...")
		buttons.hide()
	else:
		$AnimationPlayer.play("Flash Error")
	
func join_select():
	if MultiplayerManager.start_client(host_ip.text):
		buttons.hide()
		$AnimationPlayer.play("Connecting...")
	else:
		error.text = "Failed to connect to the server" 
		$AnimationPlayer.play("Flash Error")
	
func back_select():
	get_tree().change_scene_to_file(PLAY_MENU)

# Function doesn't work if it doesn't have the same parameters as the signal
func _player_connected(_id:int, _info: Dictionary):
	get_tree().change_scene_to_file(WAITING_SCREEN)

func failed_connection():
	error.text = "Connection Failed"
	$AnimationPlayer.play("Flash Error")
	buttons.show()
