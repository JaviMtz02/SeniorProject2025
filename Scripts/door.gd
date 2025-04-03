extends Area2D

signal deposit

func _on_area_entered(area: Area2D) -> void:
	print(area)
	var obj = area.get_parent()
	if obj.is_in_group("Burglar"):
		area.get_parent().poi_nearby(self)
	else:
		deposit.emit(area.get_parent())

func _on_area_exited(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj.is_in_group("Burglar"):
		area.get_parent().poi_leave(self)
