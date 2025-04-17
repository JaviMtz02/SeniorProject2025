extends Control

const HOUSE_LEVEL: String = "res://Scenes/House Level/house.tscn"
const MUSEUM_LEVEL: String = "res://Scenes/Museum Level/museum.tscn"
const LAB_LEVEL: String = "res://Scenes/Lab Level/lab_level.tscn"
const PLAY_MENU: String= "res://Scenes/Menus/play_menu.tscn"


func _on_house_pressed() -> void:
	if TitleMusic.music.playing:
		TitleMusic.music.stop()
	$LevelEnter.play()
	await $LevelEnter.finished
	MultiplayerManager.load_game.rpc(HOUSE_LEVEL)

func _on_museum_pressed() -> void:
	if TitleMusic.music.playing:
		TitleMusic.music.stop()
	$LevelEnter.play()
	await $LevelEnter.finished
	MultiplayerManager.load_game.rpc(MUSEUM_LEVEL)

func _on_lab_pressed() -> void:
	if TitleMusic.music.playing:
		TitleMusic.music.stop()
	$LevelEnter.play()
	await $LevelEnter.finished
	MultiplayerManager.load_game.rpc(LAB_LEVEL)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(PLAY_MENU)
