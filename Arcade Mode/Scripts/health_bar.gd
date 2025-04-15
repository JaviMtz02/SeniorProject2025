extends HBoxContainer

func _on_ui_health_change(health: Variant) -> void:
	$HealthProgress.value = health
