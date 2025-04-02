extends Area2D

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().poi_nearby(self)

func _on_area_exited(area: Area2D) -> void:
	area.get_parent().poi_leave(self)
