extends Control

const MULTIPLAYER_MENU: String = "res://Scenes/Menus/multiplayer_menu.tscn"
const LEVEL_SELECT: String = "res://Scenes/Menus/level_select.tscn"

@onready var players: Label = $MarginContainer/VBoxContainer/HBoxContainer/Players
@onready var level_select: Button = $"MarginContainer/VBoxContainer/Level Select"
@onready var local_ip: Label = $"Local IP"

func _ready():
	$AnimationPlayer.play("Waiting for Host...")
	players.text = str(MultiplayerManager.players.keys())
	
	MultiplayerManager.player_connected.connect(player_joined)
	MultiplayerManager.player_disconnected.connect(player_left)
	if multiplayer.is_server():
		level_select.visible = true
		# This causes quite a bit of delay unfortunately. Fix if possible
		local_ip.text = "Local IP: " + MultiplayerManager.get_local_ip()
	else:
		local_ip.hide()

func back_pressed():
	MultiplayerManager.leave_game()
	get_tree().change_scene_to_file(MULTIPLAYER_MENU)
	
func level_selected():
	if not multiplayer.is_server():
		return
	# TODO level select's back button currently does not go to the right place. add variable back button...
	get_tree().change_scene_to_file(LEVEL_SELECT)
	
# Function doesn't work if it doesn't have the same parameters as the signal
func player_joined(_id: int, _info: Dictionary):
	players.text = str(MultiplayerManager.players.keys())

func player_left(_id: int):
	players.text = str(MultiplayerManager.players.keys())
