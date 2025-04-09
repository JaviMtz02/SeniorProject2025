extends Node2D

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"

@export var parallax_bg: ParallaxBackground
@export var camera: Camera2D
@export var completion_textures: Array[Texture2D]

var speed: float = 1.0
var loot_collected: int
var cash_accum: int
var curr_score: int = 0
var cash_target_score: int
var loot_target_score: int
var completed_minigames: bool
var collected_all_loot: bool

@onready var value_label: Label = $ScreenLayout/Control/Value
@onready var loot_obtained_label: Label = $ScreenLayout/Control/LootObtained
@onready var score_timer: Timer = $ScreenLayout/Control/ScoreTimer
@onready var loot_timer: Timer = $ScreenLayout/Control/LootTimer
@onready var anim_player: AnimationPlayer = $ScreenLayout/Control/AnimationPlayer
@onready var button: Button = $ScreenLayout/Control/Button

func _ready() -> void:
	#update variables here 
	cash_accum = GameManager.curr_level_cash
	loot_collected = GameManager.curr_level_loot_collected
	collected_all_loot = GameManager.collected_all_loot
	completed_minigames = GameManager.completed_minigames
	$ScreenLayout/Control/Level.hide()
	$ScreenLayout/Control/Loot.hide()
	$ScreenLayout/Control/Minigame.hide()
	$ScreenLayout/Control/ColorRect.hide()
	$ScreenLayout/Control/Label.hide()
	button.hide()
	value_label.hide()
	loot_obtained_label.hide()
	
	anim_player.play("end_screen")

	
func _process(_delta: float) -> void:
	camera.position.x += speed


func show_achievements() -> void:
	$ScreenLayout/Control/Label.show()
	$ScreenLayout/Control/ColorRect.show()
	$ScreenLayout/Control/Level.texture = completion_textures[0]
	$SFX/ObjectiveComplete.play()
	$ScreenLayout/Control/Level.show()
	await get_tree().create_timer(0.4).timeout
	if collected_all_loot:
		$ScreenLayout/Control/Loot.texture = completion_textures[1]
		$SFX/ObjectiveComplete.play()
		$ScreenLayout/Control/Loot.show()
	else:
		$ScreenLayout/Control/Loot.show()
	await get_tree().create_timer(0.4).timeout
	if completed_minigames:
		$ScreenLayout/Control/Minigame.texture = completion_textures[2]
		$SFX/ObjectiveComplete.play()
		$ScreenLayout/Control/Minigame.show()
	else:
		$ScreenLayout/Control/Minigame.show()
	
func update_score() -> void:
	value_label.show()
	button.show()
	cash_target_score = cash_accum
	if cash_target_score > curr_score:
		score_timer.start()
		await score_timer.timeout
		
func update_loot() -> void:
	loot_obtained_label.show()
	curr_score = 0
	loot_target_score = loot_collected
	if loot_target_score > curr_score:
		loot_timer.start()
		await loot_timer.timeout

func _on_score_timer_timeout() -> void:
	if curr_score < cash_target_score:
		curr_score += 1
		value_label.text = "Cash Obtained: " + str(curr_score)
		score_timer.start()
		$SFX/CashAccumulating.play()
	else:
		score_timer.stop()
		
func _on_loot_timer_timeout() -> void:
	if curr_score < loot_target_score:
		curr_score += 1
		loot_obtained_label.text = "Loot Collected: " + str(curr_score)
		loot_timer.start()
	else:
		loot_timer.stop()


func _on_button_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(LEVEL_SELECT))
