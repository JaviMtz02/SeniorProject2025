extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = 3
	for i in 8:
		var last_child = get_child(-1)
		var new_button = last_child.duplicate()
		new_button.button_index += 1
		add_child(new_button)
