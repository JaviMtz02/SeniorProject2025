extends Node2D

const MAIN_MENU: String = "res://Scenes/Menus/start_menu.tscn"

var mouse_pos: Vector2
@onready var go_back_button: TextureButton = $ShopLayer/ShopLayout/GoBackButton
@onready var available_cash: Label = $ShopLayer/ShopLayout/Cash

func _ready() -> void:
	# Initially hides the whole shop for loading effect
	$Sounds_SFX/Loading.play()
	$ShopLayer/ShopLayout.hide()
	$ShopLayer/InitialLayout/Loading.play("default")
	go_back_button.pressed.connect(_on_go_back_pressed)
	await get_tree().create_timer(2.0).timeout
	# Hides loading screen and shows shop, shop should show bag screen first
	$Sounds_SFX/Loading.play()
	$ShopLayer/InitialLayout.hide()
	$ShopLayer/InitialLayout/Loading.stop()
	$ShopLayer/ShopLayout.show()
	$ShopLayer/ShopLayout/WeaponsLayout.hide()
	$ShopLayer/ShopLayout/ShoesLayout.hide()
	$Sounds_SFX/Music.play()
	available_cash.text = str(GameManager.cash)
	
func _process(_delta: float) -> void:
	$Camera2D.position.x += 0.5

func _on_go_back_pressed() -> void:
	$Sounds_SFX/SwitchTab.play()
	await $Sounds_SFX/SwitchTab.finished
	 # go back button switches to main menu, this code follows the same format that Jacob did for the start menu
	get_tree().change_scene_to_file(MAIN_MENU)
