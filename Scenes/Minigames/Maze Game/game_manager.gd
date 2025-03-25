extends Node2D

signal game_won
signal game_lost

@onready var lab_geek: CharacterBody2D = $LabGeek

func _ready() -> void:
	lab_geek.connect("orb_collected", Callable(self, "_on_orb_collected"))
	lab_geek.connect("caught", Callable(self, "_on_caught"))
	
func _on_orb_collected() -> void:
	game_won.emit()
	print("you won!")
	queue_free()

func _on_caught() -> void:
	game_lost.emit()
	print("you lost")
	queue_free()
