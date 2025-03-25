extends Node2D

@export var checkers: Array[Node2D] = []

func _ready() -> void:
	for checker in checkers:
		checker.checker_toggled.connect(_on_checker_toggled)

func _on_checker_toggled() -> void:
	if check_win_condition():
		print("You win") # Add something later

func check_win_condition() -> bool:
	
	if checkers.is_empty():
		return false
	
	for checker in checkers:
		if checker.is_flipped == false:
			return false
	return true
	
